import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(milliseconds: 1500),
      () {
        // 런치 스크린 동안 처리할 로직
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF7F4E9),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/fluent_icon.png'),
                  const Text(
                    'Fluent',
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF755757),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 150,
              child: GestureDetector(
                onTap: () {
                  // 로그인 버튼 클릭 로직 수행
                  hashKeyCheck().then((value) {
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('kakao hash check'),
                          content: Text('$value'),
                          actions: [
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('뒤로 가기'),
                            )
                          ],
                        );
                      },
                    );
                  });
                },
                child: Image.asset(
                    'assets/images/kakao/kakao_login_medium_narrow.png'),
              ),
            ),
          ],
        ));
  }

  // [kakao] hash key 존재 여부 반환하는 함수
  Future hashKeyCheck() async {
    var hash = await KakaoSdk.origin;

    if (hash.isNotEmpty) {
      return '해시 키 존재';
    } else {
      return '해시 키 없음';
    }
  }
}
