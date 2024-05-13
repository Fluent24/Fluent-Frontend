import 'package:fluent/screens/home_screen.dart';
import 'package:fluent/screens/leaderboard_screen.dart';
import 'package:fluent/screens/my_profile_screen.dart';
import 'package:flutter/material.dart';
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
    const HomeScreen(), // 홈 화면
    const LeaderboardScreen(), // 리더보드 화면
    const MyProfileScreen(), // 내 프로필 화면
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screenType.elementAt(_selectedIndex),
      bottomNavigationBar: Theme(
        // bottom navigation bar 기본 애니메이션 효과 제거
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            // speaking icon
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                child: Center(child: Image.asset('assets/images/speaking.png'),),
              ),
              activeIcon: Container(
                margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.blueAccent.withOpacity(0.3),
                ),
                child: Center(child: Image.asset('assets/images/speaking.png'),),
              ),
              label: '',
            ),
            // leaderboard icon
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                child: Center(child: Image.asset('assets/images/leaderboard.png'),),
              ),
              activeIcon: Container(
                margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.blueAccent.withOpacity(0.3),
                ),
                child: Center(child: Image.asset('assets/images/leaderboard.png'),),
              ),
              label: '',
            ),
            // profile icon
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                child: Center(child: Image.asset('assets/images/profile.png'),),
              ),
              activeIcon: Container(
                margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.blueAccent.withOpacity(0.3),
                ),
                child: Center(child: Image.asset('assets/images/profile.png'),),
              ),
              label: '',
            ),
          ],
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
