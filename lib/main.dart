import 'package:fluent/env/env.dart';
import 'package:fluent/screens/feedback_screen.dart';
import 'package:fluent/screens/feedback_test_screen.dart';
import 'package:fluent/screens/learn_screen.dart';
import 'package:fluent/screens/main_screen.dart';
import 'package:fluent/screens/my_profile_screen.dart';
import 'package:fluent/screens/register_screen.dart';
import 'package:fluent/screens/history_screen.dart';
import 'package:fluent/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  runApp(ProviderScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/feedback_test',
      routes: {
        '/': (context) => SplashScreen(),
        '/main': (context) => MainScreen(),
        '/review': (context) => ReviewScreen(),
        '/profile': (context) => MyProfileScreen(),
        '/register': (context) => RegisterScreen(),
        '/feedback_test': (context) => FeedbackTestScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/learn') {
          if (settings.arguments != null) {
            print('[LOG] ARGUMENTS: ${settings.arguments}');
            return PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  final int quizId = settings.arguments as int;
                  return LearnScreen(quizId: quizId);
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
          else {
            print('[LOG] LEARN NO ARGUMENT');
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
        }
    
        if (settings.name == '/feedback') {
          if (settings.arguments != null) {
            // return MaterialPageRoute(builder: (context) {
            //   return FeedbackScreen(script: settings.arguments as String);
            // });
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                final argumentMap = settings.arguments as Map<String, dynamic>;
                final userScript = argumentMap['userScript'] as String;
                final totalScore = argumentMap['score'] as double;
                return FeedbackScreen(userScript: settings.arguments as String, totalScore: totalScore);
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

        // 기본적으로는 null을 반환하여 처리하지 않는 경로는 MaterialApp의 routes에서 처리하도록 합니다.
        return null;
      },
    ),
  ));
}