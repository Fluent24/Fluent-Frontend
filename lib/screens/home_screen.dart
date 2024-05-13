import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// 홈(학습하기) 화면
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.1),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Daily Course / Required Time / Start Button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              // outline design
              decoration: ShapeDecoration(
                  color: const Color(0xFF0047FF).withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  )),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                // Daily Course / required time / start button
                child: Column(
                  children: [
                    // Daily Course / required time
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '🏆 Daily Course',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Nunito',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '12m',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Nunito',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // start button
                    GestureDetector(
                      onTap: () {
                        // 학습하기 화면으로 이동
                        Navigator.pushNamed(context, '/learn');
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            )),
                        child: const Center(
                          child: Text(
                            'Start',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontFamily: 'Nunito',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Review Course / required time / start button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              // outline design
              decoration: ShapeDecoration(
                  color: const Color(0xFFE15959).withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  )),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                // Daily Course / required time / start button
                child: Column(
                  children: [
                    // Daily Course / required time
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '🧾 Review Course',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Nunito',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '9m',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Nunito',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // start button
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                      child: GestureDetector(
                        onTap: () {
                          // 복습하기 화면으로 이동
                        },
                        child: const Center(
                          child: Text(
                            'Start',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontFamily: 'Nunito',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Consecutive Learning Days / Rating
            Container(
              margin: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Consecutive Learning Days
                  Expanded(
                    flex: 10,
                    child: Container(
                      height: 100,
                      padding: const EdgeInsets.all(10),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.white,
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Consecutive Days',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.local_fire_department,
                                size: 50,
                                color: Colors.redAccent,
                              ),
                              Text(
                                '9 Days',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Rating
                  Expanded(
                    flex: 10,
                    child: Container(
                      height: 100,
                      padding: const EdgeInsets.all(10),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.white,
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Grade',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                '🏆',
                                style: TextStyle(fontSize: 30),
                              ),
                              Text(
                                'Gold',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
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
}
