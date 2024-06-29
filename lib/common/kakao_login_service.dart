import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:fluent/env/env.dart';
import 'package:fluent/models/token.dart';
import 'package:http/http.dart' as http;

// 카카오 로그인 관련 처리 함수
// [Refactor] LoginService 인터페이스 만들어 override 방식으로 변경하기
class KakaoLoginService {
  /// 카카오 로그인 실행
  Future<bool> kakaoLogin() async {
    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
        return true;
      } catch (error) {
        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소 처리 (예: 뒤로 가기)
        // 로그인 버튼 다시 클릭하여 로그인 시도하면 됨
        if (error is PlatformException && error.code == 'CANCELED') {
          return false;
        }

        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
          return true;
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
          return false;
        }
      }
    }
    // 카카오톡 실행 불가능한 경우
    else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
        return true;
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
        return false;
      }
    }
  }

  /// 카카오 로그아웃 - TokenManager에서 기존 카카오 토큰 제거
  Future<void> kakaoLogout() async {
    try {
      await UserApi.instance.logout();
      print('로그아웃 성공, SDK에서 토큰 삭제');
    } catch (error) {
      print('로그아웃 실패, SDK에서 토큰 삭제 $error');
    }
  }

  /// 토큰 존재 여부 확인 및 유효성 검사
  Future<bool> checkExistKakaoToken() async {
    // 카카오 토큰 존재 여부 확인
    // 카카오 토큰 존재 --> 최초 사용자 여부 체크 (email, uid 서버로 송신) --> 페이지 이동
    if (await AuthApi.instance.hasToken()) {
      try {
        AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
        print('토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn}');
        return true;
      }
      // Access Token 만료 시에 UserApi.instance.accessTokenInfo()에서 자동으로 갱신 작업 실행
      // 따라서 아래 catch 문은 실행되지 않음 (Ref: https://devtalk.kakao.com/t/topic/130662/4)
      catch (error) {
        // 토큰 유효 기간이 만료된 경우
        if (error is KakaoException && error.isInvalidTokenError()) {
          print('토큰 만료 $error');
        }
        // 토큰 정보가 잘못된 경우
        else {
          print('토큰 정보 조회 실패 $error');
        }

        return false;
      }
    }
    // 카카오 토큰 존재 X --> 로그인 실행
    else {
      print('발급된 토큰 없음');
      return false;
    }
  }

  /// 카카오 토큰 존재하며 유효한 경우 서버로 사용자 정보 송신하여 최초 사용자 여부 파악
  /// Request - 사용자 정보 [uid, email, profile img]
  /// Response - jwt 토큰 정보 수신 [accessToken, refreshToken, expirationTime, tokenType, issuedAt
  Future<TokenModel?> sendUserInfo() async {
    try {
      User user = await UserApi.instance.me();
      print('사용자 정보 요청 성공'
          '\n회원번호: ${user.id}'
          '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
          '\n이메일: ${user.kakaoAccount?.email}'
          '\n프로필: ${user.kakaoAccount?.profile?.profileImageUrl}');

      // JWT 토큰 받아오기
      var requestData = {
        'kakaoAccount': user.kakaoAccount?.email,
        'kakaoPK': user.id,
        'profile': user.kakaoAccount?.profile?.profileImageUrl,
      };
      var uri = Uri.parse('${Env.serverEndpoint}/api/v1/auth/sign-in');
      var response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        print('JWT 토큰 발급 성공: ${jsonData['accessToken']}');
        return TokenModel.fromJson(jsonData);
      } else {
        print('잘못된 응답을 수신하였습니다.');
        return null;
      }
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
      return null;
    }
  }
}
