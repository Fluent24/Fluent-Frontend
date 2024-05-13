import 'package:fluent/env/env.dart';
import 'package:fluent/screens/learn_screen.dart';
import 'package:fluent/screens/main_screen.dart';
import 'package:fluent/screens/register_screen.dart';
import 'package:fluent/screens/review_screen.dart';
import 'package:fluent/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 환경 변수 불러오기
  await FlutterConfig.loadEnvVariables();

  // kakao SDK 초기화
  KakaoSdk.init(
    nativeAppKey: Env.kakaoNativeAppKey,
    javaScriptAppKey: Env.kakaoJavaScriptKey,
  );

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/main',
    routes: {
      // '/': (context) => SplashScreen(),
      '/register': (context) => RegisterScreen(),
      '/main': (context) => MainScreen(),
      '/learn': (context) => LearnScreen(),
      '/review': (context) => ReviewScreen(),
    },
  ));
}
