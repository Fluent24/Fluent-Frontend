import 'package:fluent/env/env.dart';
import 'package:fluent/screens/feedback_screen.dart';
import 'package:fluent/screens/learn_screen.dart';
import 'package:fluent/screens/main_screen.dart';
import 'package:fluent/screens/register_screen.dart';
import 'package:fluent/screens/review_screen.dart';
import 'package:fluent/screens/splash_screen.dart';
import 'package:fluent/screens/test_screen.dart';
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
      '/review': (context) => ReviewScreen(),
      '/test': (context) => TestScreen(),
    },
    onGenerateRoute: (settings) {
      if (settings.name == '/learn') {
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return LearnScreen();
            },
            transitionsBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child,
                ) {
              var begin = const Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.ease;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(position: animation.drive(tween), child: child);
            }
        );
      }

      if (settings.name == '/feedback') {
        if (settings.arguments != null) {
          // return MaterialPageRoute(builder: (context) {
          //   return FeedbackScreen(script: settings.arguments as String);
          // });
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return FeedbackScreen(script: settings.arguments as String);
            },
            transitionsBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child,
            ) {
              var begin = const Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.ease;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(position: animation.drive(tween), child: child);
            }
          );
        }
      }
    },
  ));
}