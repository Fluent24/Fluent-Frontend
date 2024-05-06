import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
final class Env {
  @EnviedField(varName: 'KAKAO_NATIVE_APP_KEY', obfuscate: true)
  static final String kakaoNativeAppKey = _Env.kakaoNativeAppKey;

  @EnviedField(varName: 'KAKAO_JAVASCRIPT_KEY', obfuscate: true)
  static final String kakaoJavaScriptKey = _Env.kakaoJavaScriptKey;
}