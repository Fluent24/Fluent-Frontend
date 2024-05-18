import 'package:fluent/widgets/interest_box.dart';
import 'package:fluent/widgets/progress_bar.dart';
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  // 사용자 프로필 + 오늘 학습량 + 연속 학습 일수 + 랭킹 표시 영역
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2.6,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blueAccent.withOpacity(0.9),
                          Colors.blueAccent
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 닉네임 + 랭크 표시 영역
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 닉네임 표시
                                const Text(
                                  'Soonook',
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                // 랭크 아이콘 + 랭크 이름
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/ranks/silver.png',
                                      scale: 50,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Silver',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // 프로필 이미지
                            Container(
                              constraints: const BoxConstraints(maxHeight: 70),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(70),
                                ),
                                color: Colors.white,
                                shadows: const [
                                  BoxShadow(
                                    color: Colors.blueGrey,
                                    offset: Offset(0, 1),
                                    spreadRadius: 0,
                                    blurRadius: 5,
                                  )
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(70),
                                child: Image.asset(
                                  'assets/images/profile_bread.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // 오늘의 학습 달성률 표시 영역
                        const Text(
                          'Daily Achievement',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 15),
                        ProgressBar(
                            percent: 0.6, barColor: const Color(0xFF9DFFCA)),
                      ],
                    ),
                  ),

                  // 하단 위젯 영역 (관심사, 학습하기, 복습하기 영역)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.7,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 사용자 관심사 영역
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.only(
                                    left: 25, top: 10, bottom: 23, right: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blueGrey.withOpacity(0.5),
                                        offset: const Offset(0, 3),
                                        blurRadius: 5,
                                        spreadRadius: 1,
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
                                          'Interests',
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
                                    color: Colors.blueAccent.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blueGrey.withOpacity(0.6),
                                        offset: const Offset(0, 3),
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                      ),
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 학습하기 라벨
                                    const Text(
                                      'Daily Course',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    TextButton(
                                      onPressed: () {
                                        // 학습하기 화면으로 이동
                                        Navigator.pushNamed(context, '/learn');
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        minimumSize: const Size(double.infinity, 0),
                                        foregroundColor: Colors.grey,
                                      ),
                                      child: const Text(
                                        'Start',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blueAccent,
                                          letterSpacing: 1,
                                        ),
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
                                    color: Colors.redAccent.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blueGrey.withOpacity(0.5),
                                        offset: const Offset(0, 3),
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                      ),
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 복습하기 라벨
                                    const Text(
                                      'Sentence Review',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
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
                                        ),
                                        minimumSize: const Size(double.infinity, 0),
                                        foregroundColor: Colors.grey,
                                      ),
                                      child: const Text(
                                        'Start',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.redAccent,
                                          letterSpacing: 1,
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
