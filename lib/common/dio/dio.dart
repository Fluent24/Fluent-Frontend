import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fluent/common/secure_storage/token_manage.dart';
import 'package:fluent/env/env.dart';
import 'package:fluent/models/token.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 서버와 통신을 관리하는 dio 인스턴스 관리하는 provider
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  final tokenManage = ref.watch(tokenMangeProvider);

  dio.interceptors.add(CustomInterceptor(tokenManage: tokenManage));
  // [로깅 인터셉터] 주석 해제 시, 서버에서 반환하는 데이터 확인 가능
  dio.interceptors.add(LogInterceptor(
    responseBody: true,
    requestBody: true,
    requestHeader: true,
  ));

  return dio;
});

class CustomInterceptor extends Interceptor {
  final TokenManage tokenManage;

  CustomInterceptor({ required this.tokenManage });
  /// 1. 요청을 보낼 때
  /// 요청이 보내질 때마다 요청 Header에 accessToken: true가 존재한다면
  /// secure_storage에서 토큰을 가져와서 authorization: Bearer $token으로 헤더를 변경한다.
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] [${options.uri}]');

    if (options.headers['accessToken'] == 'true') {
      // accessToken: true 헤더 삭제
      options.headers.remove('accessToken');

      // 실제 토큰 추가
      final TokenModel? tokenModel = await tokenManage.loadToken();
      if (tokenModel != null) {
        options.headers
            .addAll({'authorization': 'Bearer ${tokenModel.accessToken}'});
      }
    }

    if (options.headers['refreshToken'] == 'true') {
      // accessToken: true 헤더 삭제
      options.headers.remove('refreshToken');

      // 실제 토큰 추가
      final TokenModel? tokenModel = await tokenManage.loadToken();
      if (tokenModel != null) {
        options.headers
            .addAll({'authorization': 'Bearer ${tokenModel.refreshToken}'});
      }
    }

    // return문 실행 시 handler에 이용하여 요청을 보낼지 에러를 생성할지 결정함
    return super.onRequest(options, handler);
  }

  // 2. 응답을 받을 때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('[RES] [${response.requestOptions.method}] [${response.requestOptions.uri}]');
    return super.onResponse(response, handler);
  }

  // 3. 에러가 발생할 때
  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    // 토큰 문제 발생 시 statusCode 401 에러 발생
    // refresh 토큰 이용하여 재발급 요청 시도하고 새로운 access 토큰을 받아 다시 요청한다.
    print('[ERR] [${err.requestOptions.method}] [${err.requestOptions.uri}]');

    final TokenModel? tokenModel = await tokenManage.loadToken();

    // 캐시에 토큰이 존재하지 않는 경우, 에러를 발생시킴 (handler.reject)
    if (tokenModel == null) {
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    // 토큰을 refresh 하다가 에러가 발생한 경우 -> refresh 토큰에 이상이 있는 것 -> reject
    final isPathRefresh = err.requestOptions.path == '/auth/refresh';

    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        // refresh token 이용한 재발급 요청 경로로 설정하기
        /// [임시] body에 담아서 보내기
        var requestData = {
          'refreshToken': tokenModel.refreshToken,
        };

        final resp = await dio.post('${Env.serverEndpoint}/auth/refresh',
          data: json.encode(requestData),
        );

        /// [정석] header에 담아서 보내기
        // final resp = await dio.post('${Env.serverEndpoint}/auth/refresh',
        //     options: Options(headers: {
        //       'authorization': 'Bearer ${tokenModel.refreshToken}',
        //     }));

        /// 기존 요청 헤더에 새로운 accessToken 변경하여 다시 요청 보내기
        /// 캐시에 새로운 토큰 저장
        final accessToken = resp.data['accessToken'];
        final options = err.requestOptions;
        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });

        tokenManage.saveToken(tokenModel);

        final response = await dio.fetch(options);

        // 새로 보낸 요청을 응답으로 받아, 기존 에러에 대한 처리를 정상적인 응답으로 처리하도록 해줌
        // handler.resolve: 실제 요청한 화면에서는 에러가 발생하지 않은 것처럼 보임
        return handler.resolve(response);
      } on DioError catch (e) {
        // token refresh 과정에서도 에러 발생 시 -> 더 이상 에러 처리 불가
        return handler.reject(e);
      }
    }

    return handler.reject(err);
  }
}
