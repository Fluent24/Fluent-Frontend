import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fluent/common/secure_storage/token_manage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:fluent/env/env.dart';
import 'package:fluent/models/token.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dio/dio.dart';

/// 카카오 로그인 상태
enum KakaoLoginState {
  /// 기존 사용자 로그인
  loggedIn,
  /// 최초 사용자 로그인
  firstTimeLogin,
  /// 로그인 실패
  loginFailed,
  /// 로그아웃 or 재접속
  loggedOut
}

final kakaoLoginServiceProvider = StateNotifierProvider<KakaoLoginService, KakaoLoginState>((ref) {
  final dio = ref.watch(dioProvider);
  final tokenManage = ref.watch(tokenMangeProvider);
  return KakaoLoginService(dio: dio, tokenManage: tokenManage);
});

// 카카오 로그인 관련 처리 함수
// [Refactor] LoginService 인터페이스 만들어 override 방식으로 변경하기
class KakaoLoginService extends StateNotifier<KakaoLoginState> {
  final Dio dio;
  final TokenManage tokenManage;

  KakaoLoginService({required this.dio, required this.tokenManage}) : super(KakaoLoginState.loggedOut);

  /// 카카오 로그인 실행
  Future<void> kakaoLogin() async {
    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        print('[LOG] 카카오톡으로 로그인 성공');
        state = KakaoLoginState.loggedIn;
      } catch (error) {
        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소 처리 (예: 뒤로 가기)
        // 로그인 버튼 다시 클릭하여 로그인 시도하면 됨
        if (error is PlatformException && error.code == 'CANCELED') {
          state = KakaoLoginState.loginFailed;
        }
        else {
          state = KakaoLoginState.loginFailed;
        }
      }
    }
    // 카카오톡 실행 불가능한 경우
    else {
      try {
        await loginWithKakaoAccount();
        print('[LOG] 카카오계정으로 로그인 성공');
        state = KakaoLoginState.loggedIn;
      } catch (error) {
        print('[LOG] 카카오계정으로 로그인 실패 $error');
        state = KakaoLoginState.loginFailed;
      }
    }
  }

  /// 카카오 계정으로 로그인 (웹뷰)
  Future<void> loginWithKakaoAccount() async {
    // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
    try {
      await UserApi.instance.loginWithKakaoAccount();
      print('[LOG] 카카오계정으로 로그인 성공');
      state = KakaoLoginState.loggedIn;
    } catch (error) {
      print('[LOG] 카카오계정으로 로그인 실패 $error');
      state = KakaoLoginState.loginFailed;
    }
  }

  /// 카카오 로그아웃 - TokenManager에서 기존 카카오 토큰 제거
  Future<void> kakaoLogout() async {
    try {
      await UserApi.instance.logout();
      print('[LOG] 로그아웃 성공, SDK에서 토큰 삭제');
      state = KakaoLoginState.loggedOut;
    } catch (error) {
      print('[LOG] 로그아웃 실패, SDK에서 토큰 삭제 $error');
      state = KakaoLoginState.loggedOut;
    }
  }

  /// 토큰 존재 여부 확인 및 유효성 검사
  Future<bool> checkExistKakaoToken() async {
    // 카카오 토큰 존재 여부 확인
    // 카카오 토큰 존재 --> 최초 사용자 여부 체크 (email, uid 서버로 송신) --> 페이지 이동
    if (await AuthApi.instance.hasToken()) {
      try {
        AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
        print('[LOG] 토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn}');
        return true;
      }
      // Access Token 만료 시에 UserApi.instance.accessTokenInfo()에서 자동으로 갱신 작업 실행
      // 따라서 아래 catch 문은 실행되지 않음 (Ref: https://devtalk.kakao.com/t/topic/130662/4)
      catch (error) {
        // 토큰 유효 기간이 만료된 경우
        if (error is KakaoException && error.isInvalidTokenError()) {
          print('[LOG] 토큰 만료 $error');
          return false;
        }
        // 토큰 정보가 잘못된 경우
        else {
          print('[LOG] 토큰 정보 조회 실패 $error');
          return false;
        }
      }
    }
    else {
      print('[LOG] 발급된 토큰 없음');
      return false;
    }
  }

  /// 카카오 토큰 존재하며 유효한 경우 서버로 사용자 정보 송신하여 최초 사용자 여부 파악
  /// Request - 사용자 정보 [uid, email, profile img]
  /// Response - jwt 토큰 정보 수신 [accessToken, refreshToken, expirationTime, tokenType, issuedAt
  Future<Map<String, dynamic>?> sendUserInfo() async {
    try {
      User user = await UserApi.instance.me();
      print('[LOG] 사용자 정보 요청 성공'
          '\n회원번호: ${user.id}'
          '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
          '\n이메일: ${user.kakaoAccount?.email}'
          '\n프로필: ${user.kakaoAccount?.profile?.profileImageUrl}');

      final String? userEmail = user.kakaoAccount?.email;

      // 이메일 캐시에 저장하기
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', userEmail ?? '');

      // JWT 토큰 받아오기
      var requestData = {
        'email': userEmail,
      };

      var response = await dio.post(
        '${Env.serverEndpoint}/auth/login',
        data: json.encode(requestData),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );


      if (response.statusCode == 200) {
        var jsonData = response.data;
        print('[AUTH] JWT 토큰 발급 성공: ${jsonData['accessToken']}');
        return {"data": TokenModel.fromJson(jsonData)};
      } else if (response.statusCode == 401) {
        // 최초 로그인 시, 등록되어 있지 않음 -> 프로필 등록 페이지로 이동
        if (response.data == "Member not found") {
          // 최초 사용자 접속 시
          print('[AUTH] 사용자 등록 절차가 필요합니다.');
          return {"data": userEmail};
        }
      } else {
        print('[LOG] 잘못된 응답을 수신하였습니다.');
        return null;
      }
    } catch (error) {
      print('[LOG] 사용자 정보 요청 실패: $error');
    }

    return null;
  }
}
