// 학습하기 화면
import 'dart:convert';
import 'dart:io';

import 'package:audio_wave/audio_wave.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:fluent/common/dialog_util.dart';
import 'package:fluent/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import '../env/env.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  // 2문장
  String testScript =
      "Watching the LA Dodgers baseball game is one of my dreams to achieve. I really want to go watch the game during this schedule.";
  //  3문장
  // String testScript =
  //     "Watching the LA Dodgers baseball game is one of my dreams to achieve. I really want to go watch the game during this schedule. I really hope it doesn't rain on the day I go to see it. I really want to go watch the game during this schedule. I really hope it doesn't rain on the day I go to see it.";

  // 녹음 및 음성 파일 재생 컨트롤 변수
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String audioPath = '';

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    audioRecord = Record();
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    audioRecord.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFE7EEF7),
        body: PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            // showDialog
            await showConfirmDialog(
              context: context,
              title: 'Do you really want to stop learning?',
              subtitle: 'You won\'t be able to get feedback on this sentence.',
              reverse: true,
              route: Routes.main,
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
                                      'assets/images/ranks/silver.png',
                                      scale: 50,
                                    ),
                                  ),
                                ],
                              ),

                              // 문제 푼 개수
                              Row(
                                children: [
                                  Text(
                                    'Daily Achievement',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    '2 / 5',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
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
                                    padding: testScript.split('.').length > 3
                                        ? const EdgeInsets.only(right: 16.0)
                                        : const EdgeInsets.all(0),
                                    child: Text(
                                      testScript,
                                      style: TextStyle(
                                        fontSize:
                                            testScript.split('.').length > 3
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
                                        borderRadius: BorderRadius.circular(45),
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
                                          : Colors.blueAccent.withOpacity(0.9),
                                      foregroundColor: Colors.white,
                                      iconColor: Colors.white,
                                      elevation: 1,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(45),
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
                                        Text(
                                          isRecording ? 'Stop' : 'Speak',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.italic,
                                            color: isRecording
                                                ? Colors.black
                                                : Colors.white,
                                          ),
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
                                  ? waveForm()
                                  : const Text(
                                      'Check Pronunciation',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        color: Colors.lightBlueAccent,
                                      ),
                                    ),
                            ),
                          )
                        : Container(),

                    // Next 버튼
                    Container(
                      alignment: Alignment.bottomCenter,
                      height: MediaQuery.of(context).size.height / 1.1,
                      margin: const EdgeInsets.all(15),
                      child: TextButton(
                        onPressed: () async {
                          // 사용자의 녹음 파일 존재하는 경우
                          if (audioPath != '') {
                            // 녹음 파일 제출 후 피드백 화면으로 이동

                            // outputPath 설정하기
                            // String outputPath = createNewFilePath(audioPath);

                            // .m4a -> .wav 파일 형식 변환
                            // await convertM4AToWav(audioPath, outputPath);

                            // AI 서버로 송신
                            await _sendSTT(audioPath);

                            if (!mounted) return;
                            Navigator.pushReplacementNamed(context, '/feedback',
                                arguments: testScript);
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: audioPath != ''
                              ? Colors.blueAccent.withOpacity(0.8)
                              : Colors.grey,
                          foregroundColor:
                              audioPath != '' ? Colors.blueAccent : Colors.grey,
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
            ],
          ),
        ),
      ),
    );
  }

  // 음성 파형 위젯
  Widget waveForm() {
    return AudioWave(
      width: 200,
      height: 32,
      spacing: 3,
      beatRate: const Duration(milliseconds: 100),
      bars: [
        AudioWaveBar(heightFactor: 0.3, color: Colors.lightBlueAccent),
        AudioWaveBar(heightFactor: 0.6, color: Colors.lightBlueAccent),
        AudioWaveBar(heightFactor: 0.8, color: Colors.lightBlueAccent),
        AudioWaveBar(heightFactor: 0.5, color: Colors.lightBlueAccent),
        AudioWaveBar(heightFactor: 0.6, color: Colors.lightBlueAccent),
        AudioWaveBar(heightFactor: 0.3, color: Colors.lightBlueAccent),
        AudioWaveBar(heightFactor: 0.5, color: Colors.lightBlueAccent),
        AudioWaveBar(heightFactor: 0.4, color: Colors.lightBlueAccent),
        AudioWaveBar(heightFactor: 0.7, color: Colors.lightBlueAccent),
        AudioWaveBar(heightFactor: 0.8, color: Colors.lightBlueAccent),
        AudioWaveBar(heightFactor: 0.5, color: Colors.lightBlueAccent),
        AudioWaveBar(heightFactor: 0.3, color: Colors.lightBlueAccent),
        AudioWaveBar(heightFactor: 0.7, color: Colors.lightBlueAccent),
        AudioWaveBar(heightFactor: 0.7, color: Colors.lightBlueAccent),
        AudioWaveBar(heightFactor: 0.9, color: Colors.lightBlueAccent),
        AudioWaveBar(heightFactor: 0.5, color: Colors.lightBlueAccent),
        AudioWaveBar(heightFactor: 0.4, color: Colors.lightBlueAccent),
        AudioWaveBar(heightFactor: 0.7, color: Colors.lightBlueAccent),
        AudioWaveBar(heightFactor: 0.3, color: Colors.lightBlueAccent),
        AudioWaveBar(heightFactor: 0.5, color: Colors.lightBlueAccent),
      ],
    );
  }

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

  // wav로 변환한 파일 저장할 위치 설정 함수
  // String createNewFilePath(String inputPath) {
  //   print('Input path: $inputPath');
  //   // 마지막 / 위치 찾기
  //   int lastSlashIndex = inputPath.lastIndexOf('/');
  //   String directory =
  //
  //   // / 이전까지 문자열 추출하여 디렉터리 경로로 사용
  //   String directory = inputPath.substring(0, lastSlashIndex);
  //
  //   // 디렉터리 경로와 새 파일 이름 결합
  //   String outputPath = '$directory/test.wav';
  //
  //   print('Output path: $outputPath');
  //
  //   return outputPath;
  // }
}
