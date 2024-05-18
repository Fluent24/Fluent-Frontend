import 'package:fluent/screens/home_screen.dart';
import 'package:fluent/screens/leaderboard_screen.dart';
import 'package:fluent/screens/my_profile_screen.dart';
import 'package:fluent/screens/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 화면 선택 위치 (bottom navigation bar)
  int _selectedIndex = 0;

  // bottom navigation bar와 연동할 위젯 목록
  // 1. 홈(학습하기), 2. 리더보드, 3. 내 프로필
  final List<Widget> _screenType = [
    // const HomeScreen(), // 홈 화면
    const TestScreen(),
    const LeaderboardScreen(), // 리더보드 화면
    const MyProfileScreen(), // 내 프로필 화면
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 홈, 리더보드, 프로필 화면 전체 백그라운드 white70 설정됨
      backgroundColor: const Color(0xFFE7EEF7),
      body: _screenType.elementAt(_selectedIndex),
      bottomNavigationBar: Theme(
        // bottom navigation bar 기본 애니메이션 효과 제거
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 10),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey.withOpacity(0.8),
            iconSize: 24,
            elevation: 0,
            selectedFontSize: 11,
            selectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
            unselectedFontSize: 9,
            unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400),
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.house), label: 'Home'),
              BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.rankingStar), label: 'Leaderboard'),
              BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.solidUser), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}

// 로그아웃 예시
/*
Center(
        child: TextButton(
          onPressed: () async {
            try {
              await UserApi.instance.logout();
              print('로그아웃 성공, SDK에서 토큰 삭제');
              Navigator.popAndPushNamed(context, '/');
            }
            catch (error) {
              print('로그아웃 실패, SDK에서 토큰 삭제 $error');
            }
          },
          child: const Text(
            '로그아웃',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
 */
