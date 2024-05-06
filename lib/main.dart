import 'package:fluent/env/env.dart';
import 'package:fluent/screens/main_screen.dart';
import 'package:fluent/screens/register_screen.dart';
import 'package:fluent/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // kakao SDK 초기화
  KakaoSdk.init(
    nativeAppKey: Env.kakaoNativeAppKey,
    javaScriptAppKey: Env.kakaoJavaScriptKey,
  );

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => SplashScreen(),
      '/register': (context) => RegisterScreen(),
      '/main': (context) => MainScreen(),
    },
  ));
}
