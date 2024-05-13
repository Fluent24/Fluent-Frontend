// 학습하기 화면
import 'package:flutter/material.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  String testScript = "I have to catch up on so many emails";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFF).withOpacity(0.8),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 문제 스크립트 영역
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  // 듣고 있어요...
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: const Color(0xFF1B48FF),
                    ),
                    child: const Center(
                      child: Text(
                        '듣고 있어요 ...',
                        style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 문제
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      testScript,
                      style: const TextStyle(
                        fontSize: 32,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // 다시 듣기 / 다음 문제 / 음성 녹음
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          // 다시 듣기
                          Container(
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              color: const Color(0xFF0085FF).withOpacity(0.4),
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            padding: const EdgeInsets.all(10),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.refresh_rounded,
                                  size: 24,
                                ),
                                Text(
                                  '다시 듣기',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // 다음 문제
                          Container(
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              color: const Color(0xFF0085FF).withOpacity(0.4),
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            padding: const EdgeInsets.all(10),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.skip_next,
                                  size: 24,
                                ),
                                Text(
                                  '다음 문제',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: ShapeDecoration(
                          shape: CircleBorder(
                            side: BorderSide(
                              color: Colors.black.withOpacity(0.4),
                              width: 2,
                            ),
                          ),
                          color: Colors.redAccent,
                        ),
                        padding: const EdgeInsets.all(15),
                        child: const Icon(
                          Icons.mic,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            const SizedBox(height: 50),

            // wave form 영역 -> 나중에 애니메이션 달아줘야 함
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white,
              ),
              child: Image.asset('assets/images/wave_form.png', height: 70,),
            ),
          ],
        ),
      ),
    );
  }
}
