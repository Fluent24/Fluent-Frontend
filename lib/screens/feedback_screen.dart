// 피드백 화면
// Script와 Feedback이 한 줄씩 적혀야 함
// 디바이스 크기에 따라 다르지만, 테스트 기기 기준 한 줄당 20자에서 잘라서 출력
import 'package:fluent/widgets/text.dart';
import 'package:fluent/widgets/waveform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:fluent/common/utils/dialog_util.dart';

import '../provider/promo_provider.dart';
import '../provider/question_provider.dart';
import '../provider/user_provider.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  String userScript;
  double totalScore;
  FeedbackScreen(
      {super.key, required this.userScript, required this.totalScore});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    final questionModel = ref.read(questionModelProvider); // 피드백 확인 -> 퀴즈모델 초기화
    final userData = ref.watch(userModelProvider);
    final promoState = ref.watch(promoModelProvider.notifier);

    // API로부터 데이터를 가져오는 중일 때
    if (questionModel.isLoading || userData.isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              waveForm(),
              SectionText(
                text: 'Loading...',
                fontStyle: FontStyle.italic,
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
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

              DialogUtil.showConfirmDialog(
                context: context,
                title: 'Do you really want to stop learning?',
                subtitle: 'you can check your feedback at Review Page',
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
                        decoration: BoxDecoration(
                            // gradient: LinearGradient(
                            //   colors: [
                            //     Colors.blueAccent,
                            //     Colors.blueAccent.withOpacity(0.8),
                            //     Colors.blueAccent.withOpacity(0.6),
                            //     Colors.blueAccent.withOpacity(0.4),
                            //     Colors.blueAccent.withOpacity(0.2),
                            //   ],
                            //   begin: Alignment.topCenter,
                            //   end: Alignment.bottomCenter,
                            // ),
                            ),
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
                                        'assets/images/tiers/silver.png',
                                        scale: 50,
                                      ),
                                    ),
                                  ],
                                ),

                                // 문제 푼 개수
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
                                        text:
                                            '${ref.read(promoModelProvider).currentStep} / 3',
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
                            margin: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                              top: 20.0,
                              bottom: 5.0,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 35.0, vertical: 25.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: SectionText(
                                    text: 'Feedback',
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // 문제 --> 문제 길이에 따라 fontSize 조절하는 작업 필요
                                Expanded(
                                  child: Scrollbar(
                                    thumbVisibility: true,
                                    radius: const Radius.circular(10.0),
                                    thickness: 5.0,
                                    trackVisibility: true,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: SingleChildScrollView(
                                        child: Text(
                                          widget.userScript,
                                          style: const TextStyle(
                                            fontSize: 20,
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
                                          borderRadius:
                                              BorderRadius.circular(45),
                                        ),
                                        minimumSize: const Size(120, 0),
                                      ),
                                      child: Column(
                                        children: [
                                          const FaIcon(
                                              FontAwesomeIcons.headphones),
                                          const SizedBox(height: 3),
                                          SectionText(
                                            text: 'Listen',
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // 점수 영역 (totalScore)
                          Container(
                            width: MediaQuery.of(context).size.width / 1.8,
                            height: 55.0,
                            margin: const EdgeInsets.all(15),
                            child: SectionText(
                              text:
                                  '🏆 Score ${widget.totalScore.toStringAsFixed(2)}',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      // Exit 버튼 + Next 버튼
                      if (promoState.isPromo)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.bottomCenter,
                              width: MediaQuery.of(context).size.width / 2.5,
                              height: MediaQuery.of(context).size.height / 1.1,
                              margin: const EdgeInsets.all(15.0),
                              child: TextButton(
                                onPressed: () async {
                                  // 홈 화면으로 이동
                                  // 다음 문제로 이동할 때마다 popAndPush 방식으로 이동해서 pop만 해도 홈 화면으로 감
                                  // 정말 나가겠습니까? AlertDialog 띄우기
                                  await DialogUtil.showConfirmDialog(
                                    context: context,
                                    title:
                                        'Do you really want to stop learning?',
                                    subtitle:
                                        'you can check your feedback at Review Page',
                                    reverse: true,
                                    route: Routes.main,
                                  ).then((value) {
                                    // 승급 진행 중에 나간 경우, 승급전 리셋
                                    if (ref
                                            .read(promoModelProvider)
                                            .currentStep <
                                        3) {
                                      promoState.reset();
                                    }
                                  });
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      Colors.white.withOpacity(0.8),
                                  foregroundColor: Colors.grey,
                                  minimumSize: const Size(double.infinity, 0),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: SectionText(
                                  text: 'Exit',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            // Next 버튼
                            Container(
                              alignment: Alignment.bottomCenter,
                              width: MediaQuery.of(context).size.width / 2.5,
                              height: MediaQuery.of(context).size.height / 1.1,
                              margin: const EdgeInsets.all(15),
                              child: TextButton(
                                onPressed: () async {
                                  // questionModel 초기화 후 다음 문제로 이동
                                  ref
                                      .read(questionModelProvider.notifier)
                                      .reset();

                                  if (!mounted) return;
                                  Navigator.pushReplacementNamed(
                                      context, '/learn');
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      Colors.blueAccent.withOpacity(0.8),
                                  minimumSize: const Size(double.infinity, 0),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: SectionText(
                                  text: 'Next',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (!promoState.isPromo)
                          Container(
                            alignment: Alignment.bottomCenter,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 1.1,
                            margin: const EdgeInsets.all(15),
                            child: TextButton(
                              onPressed: () async {
                                // 퀴즈 종료 -> 홈 화면으로 이동
                                Future.delayed(const Duration(milliseconds: 1000), () => Navigator.pop(context));
                              },
                              style: TextButton.styleFrom(
                                backgroundColor:
                                Colors.blueAccent.withOpacity(0.8),
                                minimumSize: const Size(double.infinity, 0),
                                padding:
                                const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: SectionText(
                                text: 'Done',
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
  }
}
