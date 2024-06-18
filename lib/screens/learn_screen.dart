// 학습하기 화면
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:fluent/common/dio/dio.dart';
import 'package:fluent/common/utils/data_utils.dart';
import 'package:fluent/common/utils/dialog_util.dart';
import 'package:fluent/env/env.dart';
import 'package:fluent/models/history.dart';
import 'package:fluent/models/question.dart';
import 'package:fluent/provider/history_provider.dart';
import 'package:fluent/provider/promo_provider.dart';
import 'package:fluent/provider/question_provider.dart';
import 'package:fluent/provider/user_provider.dart';
import 'package:fluent/repository/user_repository.dart';
import 'package:fluent/widgets/text.dart';
import 'package:fluent/widgets/waveform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:record/record.dart';

class LearnScreen extends ConsumerStatefulWidget {
  int? quizId; // 복습하기를 통해 이동한 경우 quizId가 부여됨
  int? historyId; // 복습하기인 경우 historyId 부여됨
  LearnScreen({super.key, this.quizId, this.historyId});

  @override
  ConsumerState<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends ConsumerState<LearnScreen> {
  // 녹음 및 음성 파일 재생 컨트롤 변수
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String audioPath = '';
  bool isLoadingQuestion = true;
  bool isSubmit = false;
  QuestionModel questionModel = QuestionModel.empty();

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    audioRecord = Record();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadQuestion();
    });
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    audioRecord.dispose();
    super.dispose();
  }

  void loadQuestion() async {
    try {
      // 학습하기 모드
      if (widget.quizId == null) {
        print('[LOG] LEARNING MODE');
        await ref.watch(questionModelProvider.notifier).getQuestion().then((_) {
          setState(() {
            questionModel = ref.read(questionModelProvider);
            isLoadingQuestion = false;
          });
        });
      }
      // 복습하기 모드
      else {
        print('[LOG] REVIEW MODE');
        await ref
            .watch(questionModelProvider.notifier)
            .getQuestionWithId(widget.quizId!)
            .then((_) {
          setState(() {
            questionModel = ref.read(questionModelProvider);
            isLoadingQuestion = false;
          });
        });
      }
    } catch (e) {
      print('[LOG] Failed to fetch question in page: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userModelProvider);
    final promoState = ref.watch(promoModelProvider.notifier);

    // API로부터 데이터를 가져오는 중일 때
    if (isLoadingQuestion || userData.isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: waveForm(),
        ),
      );
    } else if (questionModel.isError || userData.isError) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SectionText(
            text: 'No Data',
          ),
        ),
      );
    } else {
      return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFE7EEF7),
          body: PopScope(
            canPop: false,
            onPopInvoked: (didPop) {
              if (!Navigator.canPop(context)) {
                // Navigator가 lock 상태인 경우 dialog를 열지 않음
                return;
              }

              void onPopLogic() {
                if (ref.read(promoModelProvider).currentStep < 3) {
                  promoState.reset();
                }
                ref.read(questionModelProvider.notifier).reset();
              }

              // showDialog
              DialogUtil.showConfirmDialog(
                context: context,
                title: 'Do you really want to stop learning?',
                subtitle:
                    'You won\'t be able to get feedback on this sentence.',
                reverse: true,
                route: widget.quizId == null ? Routes.main : Routes.history,
                onPopLogic: onPopLogic,
              );
            },
            child: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(20),
                      ),
                      Column(
                        children: [
                          // 난이도
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 25),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.blueAccent,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueAccent.withOpacity(0.5),
                                    offset: const Offset(0, 3),
                                    blurRadius: 5,
                                    spreadRadius: 0,
                                  )
                                ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Level',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Image.asset(
                                        'assets/images/tiers/${questionModel.tier}.png',
                                        scale: 50,
                                      ),
                                    ),
                                  ],
                                ),

                                // 문제 푼 개수 - 승급전일 때 활성화
                                if (promoState.isPromo)
                                  Row(
                                    children: [
                                      SectionText(
                                        text: 'Promo',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                      const SizedBox(width: 10),
                                      SectionText(
                                        // learn 화면에서는 currentStep + 1, feedback 화면에서는 currentStep 보여주기
                                        text:
                                            '${ref.read(promoModelProvider).currentStep + 1} / 3',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),

                          // 문제 스크립트 영역
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 1.7,
                            margin: const EdgeInsets.all(20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 35.0, vertical: 25.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Listen & Speak',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w900,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black,
                                  ),
                                ),

                                const SizedBox(height: 10.0),

                                // 문제 --> 문제 길이에 따라 fontSize 조절하는 작업 필요
                                Expanded(
                                  child: Scrollbar(
                                    thumbVisibility: true,
                                    radius: const Radius.circular(10.0),
                                    thickness: 5.0,
                                    trackVisibility: true,
                                    child: SingleChildScrollView(
                                      padding: questionModel.question
                                                  .split('.')
                                                  .length >
                                              3
                                          ? const EdgeInsets.only(right: 16.0)
                                          : const EdgeInsets.all(0),
                                      child: Text(
                                        questionModel.question,
                                        style: TextStyle(
                                          fontSize: questionModel.question
                                                      .split('.')
                                                      .length >
                                                  3
                                              ? 16.0
                                              : 20.0,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.black,
                                          height: 2, // 줄간격
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 30),

                                // 다시 듣기 / 다음 문제 / 음성 녹음
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    // 다시 듣기
                                    ElevatedButton(
                                      onPressed: () {
                                        // 레퍼런스 음성 파일 다시 재생하기
                                        final filePath = ref
                                            .read(questionModelProvider)
                                            .refAudio;
                                        audioPlayer.play(UrlSource(filePath));
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor:
                                            Colors.blueAccent.withOpacity(0.9),
                                        foregroundColor: Colors.white,
                                        iconColor: Colors.white,
                                        elevation: 1,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(45),
                                        ),
                                        minimumSize: const Size(120, 0),
                                      ),
                                      child: const Column(
                                        children: [
                                          FaIcon(FontAwesomeIcons.headphones),
                                          SizedBox(height: 3),
                                          Text(
                                            'Listen',
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // 녹음하기 (Speak)
                                    ElevatedButton(
                                      onPressed: isRecording
                                          ? stopRecording
                                          : startRecording,
                                      style: TextButton.styleFrom(
                                        backgroundColor: isRecording
                                            ? Colors.white
                                            : Colors.blueAccent
                                                .withOpacity(0.9),
                                        foregroundColor: Colors.white,
                                        iconColor: Colors.white,
                                        elevation: 1,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(45),
                                        ),
                                        minimumSize: const Size(120, 0),
                                      ),
                                      child: Column(
                                        children: [
                                          FaIcon(
                                            isRecording
                                                ? FontAwesomeIcons.stop
                                                : FontAwesomeIcons.microphone,
                                            color: isRecording
                                                ? Colors.red
                                                : Colors.white,
                                          ),
                                          const SizedBox(height: 3),
                                          SectionText(
                                            text:
                                                isRecording ? 'Stop' : 'Speak',
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.italic,
                                            color: isRecording
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // 녹음본 확인하기 버튼 (check)
                      audioPath != ''
                          ? Container(
                              alignment: Alignment.bottomCenter,
                              height: MediaQuery.of(context).size.height / 1.2,
                              margin: const EdgeInsets.all(15),
                              child: TextButton(
                                onPressed: () {
                                  // 녹음 파일 재생
                                  playRecording();
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 0),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: isRecording
                                    ? waveForm(period: 1500)
                                    : SectionText(
                                        text: 'Check Pronunciation',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.lightBlueAccent,
                                      ),
                              ),
                            )
                          : Container(),

                      // Submit 버튼
                      Container(
                        alignment: Alignment.bottomCenter,
                        height: MediaQuery.of(context).size.height / 1.1,
                        margin: const EdgeInsets.all(15),
                        child: TextButton(
                          onPressed: () async {
                            // 사용자의 녹음 파일 존재하는 경우
                            if (audioPath != '') {
                              setState(() {
                                isSubmit = true;
                              });

                              /// 녹음 파일 제출 후 피드백 화면으로 이동 과정

                              /// 발음 평가 AI 모델로부터 점수와 사용자 스크립트를 받는다.
                              /*
                                curl -X POST ip/infer2/ -H "Content-Type:multipart/form-data" -F "files=/절대경로/test.m4a"
                               */

                              print(
                                  '[LOG] [LEARN] AUDIO FILE PATH : $audioPath');
                              final dio = Dio();
                              // final dio = ref.read(dioProvider);

                              dio.options = BaseOptions(
                                connectTimeout: const Duration(seconds: 60),
                                receiveTimeout: const Duration(seconds: 60),
                              );

                              // 로깅 인터셉터 추가
                              dio.interceptors.add(LogInterceptor(
                                responseBody: true,
                                requestBody: true,
                                requestHeader: true,
                              ));

                              // int maxRetry = 1; // 재시도 횟수
                              // int retryInterval = 1; // 재시도 간격 (1초)
                              //
                              // int retryCount = 0;
                              // bool shouldRetry = true;

                              // while (shouldRetry) {
                              try {
                                final file = File(audioPath);

                                /// 파일 정보 확인
                                if (await file.exists()) {
                                  final fileSize = await file.length();

                                  print('[LOG] 파일 크기 : $fileSize 바이트');

                                  String uri = '${Env.aiEndpoint}/infer4/';
                                  FormData formData = FormData.fromMap({
                                    'files': await MultipartFile.fromFile(
                                      audioPath,
                                    ),
                                  });
                                  final response = await dio.post(
                                    uri,
                                    data: formData,
                                    options: Options(
                                      headers: {
                                        'Content-Type': 'multipart/form-data',
                                      },
                                    ),
                                  );

                                  print('[LOG] [LEARN] GET AI RESPONSE');

                                  if (response.statusCode == 200) {
                                    // shouldRetry = false;
                                    var jsonData = response.data[0];

                                    print(
                                        '[LOG] [LEARN] AI RESPONSE: $jsonData');
                                    // 사용자 발음 스크립트
                                    final userScript =
                                        jsonData['transcription'] as String;
                                    final totalScore = (jsonData['total_score'])
                                        .roundToDouble();

                                    /// 히스토리에 문제 푼 기록을 등록한다.
                                    final historyManager =
                                        ref.read(historyModelProvider.notifier);

                                    print('[LOG] [LEARN] FETCH HISTORY LIST');

                                    // 복습하기 모드인 경우 현재 히스토리를 삭제한다.
                                    if (widget.quizId != null &&
                                        widget.historyId != null) {
                                      await historyManager
                                          .deleteHistory(widget.historyId!);
                                      print(
                                          '[LOG] [LEARN] DELETE OLD HISTORY IN LIST');
                                    }

                                    // 현재 시간 yyyy-MM-dd 로 변경
                                    final String now =
                                        DateTimeUtil.formatDateTime(
                                            DateTime.now());
                                    final newHistoryModel = HistoryModel(
                                      score: totalScore,
                                      solverDate: now,
                                      memberId: userData.email,
                                      quizId: questionModel.quizId!,
                                    );
                                    await historyManager
                                        .addHistory(newHistoryModel);

                                    print(
                                        '[LOG] [LEARN] ADD NEW HISTORY IN LIST');

                                    // 승급전인 경우 기록한다.
                                    if (promoState.isPromo) {
                                      promoState.addScore(totalScore);

                                      final promoModel =
                                          ref.read(promoModelProvider);
                                      // 승급 심사
                                      if (promoModel.scores.length == 3) {
                                        ref
                                            .read(userModelProvider.notifier)
                                            .updateUser(
                                                promoModel.averageScore);
                                        promoState.reset(); // 승급전 완료 -> 초기화
                                      }

                                      print(
                                          '[LOG] [LEARN] PROCESS USER PROMOTION');
                                    }

                                    /// 사용자 정보 갱신
                                    else {
                                      ref
                                          .read(userModelProvider.notifier)
                                          .getUser();

                                      print('[LOG] [LEARN] UPDATE USER EXP');
                                    }

                                    /// Navigator로 이동한다.
                                    Future.delayed(
                                      const Duration(milliseconds: 500),
                                      () {
                                        if (!mounted) return;
                                        Navigator.pushReplacementNamed(
                                            context, '/feedback',
                                            arguments: {
                                              'questionScript':
                                                  questionModel.question,
                                              'userScript': userScript,
                                              'totalScore': totalScore
                                            });
                                      },
                                    );
                                  }
                                }
                                else {
                                  print('[ERR] 파일이 존재하지 않습니다.');
                                }
                              } on DioError catch (e) {
                                if (e.response != null) {
                                  print(
                                      '[ERR] DioError response: ${e.response}');
                                  print(
                                      '[ERR] DioError response status: ${e.response!.statusCode}');
                                  print(
                                      '[ERR] DioError response data: ${e.response!.data}');

                                  if (e.response!.statusCode == 400) {
                                    print('[ERR] DioError response: 400');
                                    // shouldRetry = false;
                                  }
                                } else {
                                  print('[ERR] DioError: ${e.error}');
                                  print('[ERR] DioError message: ${e.message}');
                                  print('[ERR] DioError Error Type ${e.type}');
                                  print(
                                      '[ERR] DioError Stack Trace ${e.stackTrace}');
                                  // if (retryCount < maxRetry) {
                                  //   retryCount++;
                                  //   print('[ERR] [LEARN] RETRY ATTEMP $retryCount');
                                  //   await Future.delayed(Duration(seconds: retryInterval));
                                  // }
                                  // else {
                                  //   // shouldRetry = false;
                                  //   print('[ERR] [LEARN] MAX RETRY ATTEMPS REACHED');
                                  // }
                                }
                              } catch (e) {
                                print('[ERR] Error: $e');
                                // shouldRetry = false;
                              }
                              // }
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: audioPath != ''
                                ? Colors.blueAccent.withOpacity(0.8)
                                : Colors.grey,
                            foregroundColor: audioPath != ''
                                ? Colors.blueAccent
                                : Colors.grey,
                            minimumSize: const Size(double.infinity, 0),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: SectionText(
                            text: 'Submit',
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSubmit)
                  Stack(
                    children: [
                      // 터치 차단 배리어
                      ModalBarrier(
                        color: Colors.black.withOpacity(0.3),
                        dismissible: false,
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            waveForm(),
                            const SizedBox(height: 6.0),
                            SectionText(
                              text: 'Loading...',
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      );
    }
  }

  // 음성 파형 위젯
  // Widget waveForm() {
  //   return AudioWave(
  //     width: 200,
  //     height: 32,
  //     spacing: 3,
  //     beatRate: const Duration(milliseconds: 100),
  //     bars: [
  //       AudioWaveBar(heightFactor: 0.3, color: Colors.lightBlueAccent),
  //       AudioWaveBar(heightFactor: 0.6, color: Colors.lightBlueAccent),
  //       AudioWaveBar(heightFactor: 0.8, color: Colors.lightBlueAccent),
  //       AudioWaveBar(heightFactor: 0.5, color: Colors.lightBlueAccent),
  //       AudioWaveBar(heightFactor: 0.6, color: Colors.lightBlueAccent),
  //       AudioWaveBar(heightFactor: 0.3, color: Colors.lightBlueAccent),
  //       AudioWaveBar(heightFactor: 0.5, color: Colors.lightBlueAccent),
  //       AudioWaveBar(heightFactor: 0.4, color: Colors.lightBlueAccent),
  //       AudioWaveBar(heightFactor: 0.7, color: Colors.lightBlueAccent),
  //       AudioWaveBar(heightFactor: 0.8, color: Colors.lightBlueAccent),
  //       AudioWaveBar(heightFactor: 0.5, color: Colors.lightBlueAccent),
  //       AudioWaveBar(heightFactor: 0.3, color: Colors.lightBlueAccent),
  //       AudioWaveBar(heightFactor: 0.7, color: Colors.lightBlueAccent),
  //       AudioWaveBar(heightFactor: 0.7, color: Colors.lightBlueAccent),
  //       AudioWaveBar(heightFactor: 0.9, color: Colors.lightBlueAccent),
  //       AudioWaveBar(heightFactor: 0.5, color: Colors.lightBlueAccent),
  //       AudioWaveBar(heightFactor: 0.4, color: Colors.lightBlueAccent),
  //       AudioWaveBar(heightFactor: 0.7, color: Colors.lightBlueAccent),
  //       AudioWaveBar(heightFactor: 0.3, color: Colors.lightBlueAccent),
  //       AudioWaveBar(heightFactor: 0.5, color: Colors.lightBlueAccent),
  //     ],
  //   );
  // }

  // 녹음 시작
  Future<void> startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        await audioRecord.start();
        setState(() {
          isRecording = true;
        });
      }
    } catch (error) {
      print('ERROR start Recording: $error');
    }
  }

  // 녹음 정지
  Future<void> stopRecording() async {
    try {
      String? path = await audioRecord.stop();

      // 캐시에 저장되는데, 파일 전송하고 나서 캐시에 남은 음성 파일 지워야 함
      setState(() {
        isRecording = false;
        audioPath = path ?? '';
      });
      print('PATH: $path');
    } catch (error) {
      print('ERROR stop Recording: $error');
    }
  }

  // 녹음 파일 재생
  Future<void> playRecording() async {
    try {
      Source urlSource = UrlSource(audioPath);
      await audioPlayer.play(urlSource);
    } catch (error) {
      print('ERROR play Recording: $error');
    }
  }

  Future _sendSTT(String filePath) async {
    try {
      print('전송하기');
      final sttUrl = Uri.parse('${Env.aiEndpoint}/infer/');

      print('PATH $filePath');
      var request = http.MultipartRequest('POST', sttUrl);
      request.files.add(await http.MultipartFile.fromPath('files', filePath));

      final streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        print('File upload Success');
        http.Response response =
            await http.Response.fromStream(streamedResponse);

        // JSON 응답 파싱
        var responseData = json.decode(response.body);
        print(responseData);
        // if (responseData != null && responseData['total_score'] != null) {
        //   double score = responseData['total_score'];
        //   print("Score: $score");
        // }
        // else {
        //   print("ERROR - No text converted or wrong JSON format: ${responseData}");
        // }
      } else {
        print("뭔가 문제 있음: ${streamedResponse.statusCode}");
      }
    } catch (error) {
      print('ERROR send file: $error');
    }
  }

  Future<void> convertM4AToWav(String inputPath, String outputPath) async {
    // FFmpeg 명령 이용하여 m4a 파일 -> wav 파일로 변환
    String command =
        "-i $inputPath -vn -acodec pcm_s161e -ar 44100 -ac 2 $outputPath";

    // FFmpeg 명령 실행
    FFmpegKit.execute(command).then((session) async {
      final returnCode = await session.getReturnCode();

      // 성공적으로 실행되었는지 확인
      if (ReturnCode.isSuccess(returnCode)) {
        print('LOG - Conversion successful: $outputPath');
      } else if (ReturnCode.isCancel(returnCode)) {
        print('LOG - Conversion cancelled');
      } else {
        print('LOG - Conversion failed with return code: $returnCode}');
      }
    });
  }
}
