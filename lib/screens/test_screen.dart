import 'package:fluent/widgets/interest_box.dart';
import 'package:fluent/widgets/progress_bar.dart';
import 'package:fluent/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  double progress = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // 사용자 프로필 + 오늘 학습량 + 연속 학습 일수 + 랭킹 표시 영역
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 4.2,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueAccent.withOpacity(0.9),
                        Colors.blueAccent
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.5),
                        offset: const Offset(0, 2),
                        spreadRadius: 1,
                        blurRadius: 1,
                      )
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 오늘의 학습 달성률 표시 영역
                      SectionText(text: '오늘의 학습 목표', color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800,),
                      const SizedBox(height: 20),
                      ProgressBar(
                          percent: 0.6, barColor: const Color(0xFF9DFFCA)),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12.0),

            // 하단 위젯 영역 (관심사, 학습하기, 복습하기 영역)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  // 사용자 관심사 영역
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.only(
                        left: 25, top: 10, bottom: 23, right: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            offset: const Offset(0, 2),
                            blurRadius: 1,
                            spreadRadius: 0,
                          ),
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 관심사 라벨 + 수정 버튼
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '관심사',
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // 프로필 수정 중 관심사 수정 화면으로 이동
                                Navigator.pushNamed(context, '/register');
                              },
                              icon: const FaIcon(FontAwesomeIcons
                                  .solidPenToSquare),
                              iconSize: 18,
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // 관심사 영역
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          // 사용자가 선택한 관심사 반영하도록 변경
                          children: [
                            InterestBox(
                              text: '연애',
                              boxColor: Colors.pinkAccent,
                            ),
                            const SizedBox(width: 10),
                            InterestBox(
                              text: '여행',
                              boxColor: Colors.lightGreen,
                            ),
                            const SizedBox(width: 10),
                            InterestBox(
                              text: '운동',
                              boxColor: Colors.blueAccent,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 학습하기
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            offset: const Offset(0, 2),
                            blurRadius: 1,
                            spreadRadius: 0,
                          ),
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 학습하기 라벨
                        SectionText(
                          text: '일일 학습하기',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),

                        const SizedBox(height: 10),

                        TextButton(
                          onPressed: () {
                            // 학습하기 화면으로 이동
                            Navigator.pushNamed(context, '/learn');
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            minimumSize: const Size(double.infinity, 0),
                            foregroundColor: Colors.white,
                          ),
                          child: SectionText(
                            text: 'Start',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 복습하기
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            offset: const Offset(0, 2),
                            blurRadius: 1,
                            spreadRadius: 0,
                          ),
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 복습하기 라벨
                        SectionText(
                          text: '문장 복습하기',
                          fontSize: 24,
                          fontWeight: FontWeight.w700
                        ),

                        const SizedBox(height: 10),

                        TextButton(
                          onPressed: () {
                            // 학습하기 화면으로 이동
                            Navigator.pushNamed(context, '/review');
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                color: Colors.blueAccent,
                                width: 1,
                              )
                            ),
                            minimumSize: const Size(double.infinity, 0),
                            foregroundColor: Colors.blueAccent,
                          ),
                          child: SectionText(
                            text: 'Start',
                            fontSize: 16,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateProgress(int completeTask) {
    setState(() {
      progress = completeTask / 5;

      // 진행률 바는 100%로 채워야 함
      if (progress > 1) {
        progress = 1;
      }
    });
  }
}
