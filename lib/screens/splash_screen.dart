import 'package:fluent/common/secure_storage/token_manage.dart';
import 'package:fluent/models/token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/services/kakao_login_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool isButtonVisible = false;

  @override
  void initState() {
    super.initState();
    // _kakaoLoginServicece.kakaoLogout();
    // 카카오 토큰 존재 체크하여 로그인 버튼 활성화 여부 결정
    // checkLogin();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final loginState = ref.watch(kakaoLoginServiceProvider);
    print('[LOG] BUTTON : ${isButtonVisible}');

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
              child: isButtonVisible
                  ? GestureDetector(
                      child: Image.asset(
                          'assets/images/kakao/kakao_login_medium_wide.png'),
                      onTap: () async {
                        await ref.read(kakaoLoginServiceProvider.notifier).kakaoLogin();
                        final newLoginState = ref.watch(kakaoLoginServiceProvider);

                        if (newLoginState == KakaoLoginState.loggedIn) {
                          setState(() {
                            isButtonVisible = false;
                          });
                          Future.delayed(const Duration(seconds: 2), () => Navigator.pushReplacementNamed(context, '/main'),);
                        }
                        else if (newLoginState == KakaoLoginState.firstTimeLogin) {
                          setState(() {
                            isButtonVisible = false;
                          });
                          Future.delayed(const Duration(seconds: 2), () => Navigator.pushReplacementNamed(context, '/register'),);
                        }
                        else {
                          setState(() {
                            isButtonVisible = true;
                          });
                        }
                      },
                    )
                  : const CircularProgressIndicator(
                      color: Colors.grey,
                      strokeWidth: 5.0,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// 토큰 존재 여부에 따라 카카오 로그인 버튼 활성화 설정 메소드
  Future<void> _checkLogin() async {
    print('[LOG] CHECK LOGIN START');
    final kakaoLoginService = ref.read(kakaoLoginServiceProvider.notifier);
    final tokenExists = await kakaoLoginService.checkExistKakaoToken();

    if (tokenExists) {
      var response = await kakaoLoginService.sendUserInfo();

      // 서버에 사용자 정보 송신 후 무언가 받은 경우
      if (response?["data"] != null) {
        // 등록되지 않은 사용자라는 메시지를 수신한 경우
        if (response!["data"] is String) {
          print('[LOG] 등록되지 않은 사용자입니다.');
          if (!mounted) return;
          Future.delayed(const Duration(seconds: 2), () => Navigator.pushReplacementNamed(context, '/register'),);
        }
        // 서버로부터 jwt 토큰을 수신한 경우 토큰을 캐시에 저장
        else {
          print('[LOG] 등록된 사용자 입니다. JWT 토큰을 조회합니다.');
          TokenModel jwtToken = response["data"];
          TokenManage tokenManage = ref.read(tokenMangeProvider);
          tokenManage.saveToken(jwtToken);
          setState(() {
            isButtonVisible = false;
          });

          if (!mounted) return;
          Future.delayed(const Duration(milliseconds: 500), () => Navigator.pushReplacementNamed(context, '/main'),);
        }
      }
      else {
        print('[LOG] 서버로부터 토큰을 발급 받지 못했습니다.');
        setState(() {
          isButtonVisible = true;
        });
      }
    }
    else {
      print('[LOG] 유효한 카카오 토큰이 존재하지 않습니다.');
      setState(() {
        isButtonVisible = true;
      });
    }
  }
}
