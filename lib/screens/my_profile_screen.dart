import 'package:fl_chart/fl_chart.dart';
import 'package:fluent/widgets/chart.dart';
import 'package:fluent/widgets/profile_image.dart';
import 'package:fluent/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// 내 프로필 화면
class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white24,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 사용자 프로필 영역
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 5.5,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueAccent,
                      Colors.blueAccent.withOpacity(0.8)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.6),
                      offset: const Offset(0, 1),
                      spreadRadius: 3,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileImage(
                      size: 80,
                      canEdit: true,
                    ),

                    // 프로필 닉네임 + 랭크 영역
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionText(
                          text: 'Soonook',
                          fontWeight: FontWeight.w900,
                          fontSize: 32,
                          color: Colors.white,
                        ),
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

                    // 프로필 수정 버튼
                    IconButton(
                      onPressed: () {
                        // 프로필 수정 중 관심사 수정 화면으로 이동
                        Navigator.pushNamed(context, '/register');
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.solidPenToSquare,
                        color: Colors.white,
                      ),
                      iconSize: 30.0,
                    ),
                  ],
                ),
              ),

              // 주간 차트 영역
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: const Offset(0, 1),
                      blurRadius: 1,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionText(
                      text: '주간 학습 차트',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),

                    const SizedBox(height: 16.0),
                    // 그래프 --> 6주치 데이터 받아오기
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.blueGrey.withOpacity(0.15),
                      ),
                      child: WeeklyLineChart(),
                    ),

                    const SizedBox(height: 12.0),
                  ],
                ),
              ),

              // 로그아웃
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: const Offset(0, 1),
                      blurRadius: 1,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    // 카카오 로그아웃 및 토큰 삭제 후 앱 종료
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  child: SectionText(
                    text: '로그아웃',
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildLineChart() {
  //
  // }
}
