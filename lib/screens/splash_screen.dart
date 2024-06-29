import 'package:fluent/common/token_manage_service.dart';
import 'package:fluent/models/token.dart';
import 'package:flutter/material.dart';

import '../common/kakao_login_service.dart';

class SplashScreen extends StatefulWidget {
  bool isButtonVisible = true;
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final KakaoLoginService _kakaoLoginServicece = KakaoLoginService();

  @override
  void initState() {
    super.initState();
    // _kakaoLoginServicece.kakaoLogout();
    // 카카오 토큰 존재 체크하여 로그인 버튼 활성화 여부 결정
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/splash_icon.png',
                    scale: 5,
                  ),

                  const SizedBox(height: 50.0),
                ],
              ),
            ),
      
            Positioned(
              bottom: MediaQuery.of(context).size.height / 6,
              child: widget.isButtonVisible ? GestureDetector(
                child: Image.asset(
                    'assets/images/kakao/kakao_login_medium_wide.png'),
                onTap: () async {
                  // 카카오톡 로그인 로직 처리
                  await _kakaoLoginServicece.kakaoLogin().then((value) async {
                    // 로그인 성공한 경우 서버에 사용자 정보 보내고, JWT 토큰 수신
                    if (value) {
                      TokenModel? jwtToken = await _kakaoLoginServicece.sendUserInfo();
      
                      // JWT 토큰 수신한 경우, secure_storage에 저장
                      if (jwtToken != null) {
                        TokenManageService tokenManager = TokenManageService();
                        tokenManager.saveToken(jwtToken);
      
                        setState(() {
                          widget.isButtonVisible = false;
                        });
      
                        // 화면 이동
                        if (!mounted) return;
                        Future.delayed(const Duration(milliseconds: 1500), () => Navigator.pushReplacementNamed(context, '/main'));
                      }
                      else {
                        print('토큰 발급 받지 못함');
                        setState(() {
                          widget.isButtonVisible = true;
                        });
                        return;
                      }
                    }
                    else {
                      print('로그인 실패');
                      setState(() {
                        widget.isButtonVisible = true;
                      });
                      return;
                    }
                  },);
                },
              ) : const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 5.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 토큰 존재 여부에 따라 카카오 로그인 버튼 활성화 설정 메소드
  Future<void> checkLogin() async {
    await _kakaoLoginServicece.checkExistKakaoToken().then((value) async {
      // 토큰 존재 & 유효한 경우
      if (value) {
        TokenModel? jwtToken = await _kakaoLoginServicece.sendUserInfo();

        // [Refactor] 아래 화면 이동 부분 함수로 빼기
        // JWT 토큰 수신한 경우, secure_storage에 저장
        if (jwtToken != null) {
          TokenManageService tokenManager = TokenManageService();
          tokenManager.saveToken(jwtToken);
          setState(() {
            widget.isButtonVisible = false;
          });

          // 화면 이동
          if (!mounted) return;
          Future.delayed(const Duration(milliseconds: 1500), () => Navigator.pushReplacementNamed(context, '/main'));
        }
        else {
          print('토큰 발급 받지 못함');
          setState(() {
            widget.isButtonVisible = true;
          });
        }
      }
      else {
        print('유효한 토큰 존재하지 않음');
        setState(() {
          widget.isButtonVisible = true;
          print('로그인 버튼 출력');
        });
      }
    });
  }
}
