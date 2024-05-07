import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
    );
  }
}
