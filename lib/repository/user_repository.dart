import 'dart:io';

import 'package:fluent/common/dio/dio.dart';
import 'package:fluent/env/env.dart';
import 'package:fluent/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

// retrofit Headers를 사용하는 경우 hide 필요
import 'package:dio/dio.dart' hide Headers;
import 'package:shared_preferences/shared_preferences.dart';

part 'user_repository.g.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  // watch - 변경 발생 시, provider를 다시 build
  // provider 내부에서 사용 시에 watch 사용하는 것 권장
  final dio = ref.watch(dioProvider);

  final repository =
      UserRepository(dio, baseUrl: '${Env.serverEndpoint}/api/members');

  return repository;
});

/// 사용자 정보 관련 API 통신 영역
@RestApi()
abstract class UserRepository {
  // baseUrl: ${Env.serverEndpoint}/api/members
  factory UserRepository(Dio dio, {String baseUrl}) = _UserRepository;

  /// 프로필 정보 등록하기
  // 초기 사용자 로그인이므로 Header 토큰 제외 x
  @POST('/')
  @MultiPart() // 이미지 파일을 서버로 전송하므로 Multipart 요청 진행해야 함
  Future<UserModel> registerUserInfo({
    @Part() required String email,
    @Part() required String name,
    @Part() required List<String> favorites,
    @Part(name: 'profileImage') File? profileImage, // 프로필 이미지 파일 추가
  });

  /// 사용자 정보 가져오기
  // ${Env.serverEndpoint}/api/members
  @GET('')
  @Headers({
    'accessToken': 'true',
  })
  Future<UserModel> getUserInfo();

  /// 모든 사용자 목록 가져오기
  // ${Env.serverEndpoint}/api/members/all
  @GET('/all')
  @Headers({
    'accessToken': 'true',
  })
  Future<List<UserModel>> getUserPaginate();

  /// 승급 요청
  // ${Env.serverEndpoint}/api/members/udateTier
  @POST('/updateTier')
  @Headers({
    'accessToken': 'true',
  })
  Future<UserModel> promoProcess({
    @Body() required double avgScore,
  });
}

/// 사용자 정보 캐싱 영역
enum InfoType {
  name,
  profile,
  tier,
  favorites,
  exp,
  email,
}

class UserCacheRepository {
  /// shared_preferences에 사용자 정보 저장
  static Future<void> writeUserModel({required UserModel userModel}) async {
    await _writeUserInfo(type: InfoType.name, data: userModel.nickName);
    await _writeUserInfo(
        type: InfoType.profile, data: userModel.profilePictureUrl);
    await _writeUserInfo(type: InfoType.tier, data: userModel.tier);
    await _writeUserInfo(type: InfoType.favorites, data: userModel.favorites);
    await _writeUserInfo(type: InfoType.exp, data: userModel.exp);
    await _writeUserInfo(type: InfoType.email, data: userModel.email);
  }

  // 캐시에 사용자 정보 한 요소 저장 - 덮어쓰기
  static Future<void> _writeUserInfo(
      {required InfoType type, required dynamic data}) async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    switch (type) {
      case InfoType.name:
        await prefs.setString('userName', data);
        break;
      case InfoType.profile:
        await prefs.setString('profilePictureUrl', data ?? 'null');
        break;
      case InfoType.tier:
        await prefs.setString('tier', data);
        break;
      case InfoType.favorites:
        await prefs.setStringList('favorites', data);
        break;
      case InfoType.email:
        await prefs.setString('email', data);
        break;
      case InfoType.exp:
        await prefs.setString('exp', data);
        break;
      default:
        break;
    }
  }

  /// 사용자 정보 한 요소를 읽어오는 함수
  static Future<dynamic>? readUserInfo({required InfoType type}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic data;

    switch (type) {
      case InfoType.name:
        data = prefs.getString('userName');
        break;
      case InfoType.profile:
        data = prefs.getString('profilePictureUrl');
        break;
      case InfoType.tier:
        data = prefs.getString('tier');
        break;
      case InfoType.favorites:
        data = prefs.getStringList('favorites');
        break;
      case InfoType.email:
        data = prefs.getString('email');
        break;
      case InfoType.exp:
        data = prefs.getString('exp');
        break;
      default:
        break;
    }

    return data;
  }

  // 사용자 정보 캐시에서 삭제
  static Future<void> deleteUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('userName');
    await prefs.remove('profilePictureUrl');
    await prefs.remove('tier');
    await prefs.remove('favorites');
    await prefs.remove('email');
  }
}
