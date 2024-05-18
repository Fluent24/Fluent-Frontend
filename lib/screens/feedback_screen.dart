// 피드백 화면
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:fluent/common/dialog_util.dart';

class FeedbackScreen extends StatefulWidget {
  String script;
  FeedbackScreen({super.key, required this.script});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFE7EEF7),
        body: PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            await showConfirmDialog(context: context, canSave: true);
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
                                    '1 / 5',
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
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Feedback',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w900,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black,
                                ),
                              ),

                              const SizedBox(height: 20),

                              // 문제 --> 문제 길이에 따라 fontSize 조절하는 작업 필요
                              Text(
                                widget.script,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black,
                                  height: 2, // 줄간격
                                ),
                              ),

                              const SizedBox(height: 30),

                              // 다시 듣기 / 다음 문제 / 음성 녹음
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                      minimumSize: const Size(220, 0),
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
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Exit 버튼
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.bottomCenter,
                          width: MediaQuery.of(context).size.width / 2.5,
                          height: MediaQuery.of(context).size.height / 1.1,
                          margin: const EdgeInsets.all(15),
                          child: TextButton(
                            onPressed: () async {
                              // 홈 화면으로 이동
                              // 다음 문제로 이동할 때마다 popAndPush 방식으로 이동해서 pop만 해도 홈 화면으로 감
                              // 정말 나가겠습니까? AlertDialog 띄우기
                              await showConfirmDialog(context: context, canSave: true);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.8),
                              foregroundColor: Colors.grey,
                              minimumSize: const Size(double.infinity, 0),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'Exit',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
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
                            onPressed: () {
                              // 다음 문제로 이동
                              Navigator.pushReplacementNamed(context, '/learn');
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blueAccent.withOpacity(0.8),
                              minimumSize: const Size(double.infinity, 0),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
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
