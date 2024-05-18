import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   Future.delayed(
  //     Duration(milliseconds: 1500),
  //     () async {
  //       // 런치 스크린 동안 처리할 로직
  //       if (await AuthApi.instance.hasToken()) {
  //         try {
  //           AccessTokenInfo tokenInfo =
  //               await UserApi.instance.accessTokenInfo();
  //           print('토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn}');
  //           // 여기서 넘어가면 바로 메인 화면
  //           Navigator.popAndPushNamed(context, '/main');
  //         } catch (error) {
  //           if (error is KakaoException && error.isInvalidTokenError()) {
  //             print('토큰 만료 $error');
  //           } else {
  //             print('토큰 정보 조회 실패 $error');
  //           }
  //
  //           try {
  //             // 카카오계정으로 로그인
  //             OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
  //             print('로그인 성공 ${token.accessToken}');
  //           } catch (error) {
  //             print('로그인 실패 $error');
  //           }
  //         }
  //       } else {
  //         print('발급된 토큰 없음');
  //
  //         try {
  //           OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
  //           print('로그인 성공 ${token.accessToken}');
  //         } catch (error) {
  //           print('로그인 실패 $error');
  //         }
  //       }
  //     },
  //   );
  // }

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
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      // 로그인 버튼 클릭 로직 수행
                      /*hashKeyCheck().then((value) {
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
                      });*/

                      // 카카오톡 실행 가능 여부 확인
                      // 실행 가능 -> 카카오톡으로 로그인
                      // 실행 불가능 -> 카카오계정으로 로그인
                      if (await isKakaoTalkInstalled()) {
                        try {
                          OAuthToken token =
                              await UserApi.instance.loginWithKakaoTalk();
                          print('카카오톡 로그인 성공 ${token.accessToken}');

                          try {
                            User user = await UserApi.instance.me();
                            print('사용자 정보 요청 성공'
                                '\n회원번호: ${user.id}'
                                '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
                                '\n이메일: ${user.kakaoAccount?.email}');
                          } catch (error) {
                            print('사용자 정보 요청 실패 $error');
                          }
                        } catch (error) {
                          print('카카오톡 로그인 실패 $error');

                          // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인 취소한 경우,
                          // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소 처리 (ex. 뒤로가기)
                          if (error is PlatformException &&
                              error.code == 'CANCELED') {
                            return;
                          }

                          // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
                          try {
                            await UserApi.instance.loginWithKakaoAccount();
                            print('카카오계정으로 로그인 성공');
                          } catch (error) {
                            print('카카오계정으로 로그인 실패 $error');
                          }
                        }
                      } else {
                        try {
                          await UserApi.instance.loginWithKakaoAccount();
                          print('카카오계정으로 로그인 성공');
                        } catch (error) {
                          print('카카오계정으로 로그인 실패 $error');
                        }
                      }
                    },
                    child: Image.asset(
                        'assets/images/kakao/kakao_login_medium_narrow.png'),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
