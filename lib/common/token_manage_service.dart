import 'dart:convert';

import 'package:fluent/models/token.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluent/models/token.dart';

// 토큰 관리 로직
class TokenManageService {
  // Single-ton pattern (클래스의 인스턴스가 1개만 생성되도록 하는 디자인 패턴)
  static final TokenManageService _instance = TokenManageService._internal();
  final FlutterSecureStorage _tokenStorage = FlutterSecureStorage();

  // Private Constructor
  TokenManageService._internal();

  // Public Factory Constructor
  factory TokenManageService() {
    return _instance;
  }

  // JWT 토큰 저장
  Future<void> saveToken(TokenModel tokenModel) async {
    String jsonData = json.encode(tokenModel.toJson());
    await _tokenStorage.write(key: 'jwt_token_data', value: jsonData);
  }

  // JWT 토큰 데이터 로드
  Future<TokenModel?> loadToken() async {
    String? jsonData = await _tokenStorage.read(key: 'jwt_token_data');

    if (jsonData != null) {
      return TokenModel.fromJson(json.decode(jsonData));
    }

    return null;
  }

  // JWT 토큰 데이터 삭제 메소드
  Future<void> deleteToken() async {
    await _tokenStorage.delete(key: 'jwt_token_data');
  }

  // accessToken 업데이트 메소드
  // refreshToken 사용하여 업데이트 되었을 때 사용
  Future<void> updateAccessToken(
      String newAccessToken, DateTime newIssuedAt) async {
    TokenModel? tokenModel = await loadToken();

    if (tokenModel != null) {
      TokenModel updatedToken = TokenModel(
        accessToken: newAccessToken,
        refreshToken: tokenModel.refreshToken,
        expirationTime: tokenModel.expirationTime,
        tokenType: tokenModel.tokenType,
        issuedAt: newIssuedAt,
      );

      // 갱신된 토큰 저장 (덮어쓰기)
      await saveToken(updatedToken);
    }
  }
}
