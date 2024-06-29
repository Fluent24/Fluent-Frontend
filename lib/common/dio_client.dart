import 'package:dio/dio.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:fluent/env/env.dart';
import 'package:fluent/models/token.dart';
import 'package:fluent/common/token_manage_service.dart';

class DioClient {
  final Dio _dio = Dio();
  final TokenManageService _tokenManageService = TokenManageService();

  DioClient() {
    // HTTP 헤더에 JWT 토큰 추가
    // _dio.options.headers['Authorization'] = 'Bearer ${token.accessToken}';
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        TokenModel? token = await _tokenManageService.loadToken();

        if (token != null) {
          // 토큰이 만료되지 않은 경우 헤더에 토큰 담기
          if (!token.isTokenExpired()) {
            options.headers['Authorization'] = 'Bearer ${token.accessToken}';
          }
          // 토큰이 만료된 경우, refreshToken 이용하여 갱신
          else {
            String? newAccessToken = await _refreshAccessToken(token);

            // 새로운 accessToken 갱신된 경우
            if (newAccessToken != null) {
              // 토큰 데이터 갱신 및 다시 저장
              await _tokenManageService.updateAccessToken(
                  newAccessToken, DateTime.now());
              options.headers['Authorization'] = 'Bearer ${newAccessToken}';
            } else {
              return handler.reject(DioException(
                requestOptions: options,
                error: 'JWT 토큰 재발급 실패',
                type: DioExceptionType.unknown,
              ));
            }
          }
        }

        return handler.next(options);
      },
      onResponse: (response, handler) {
        // 응답 데이터 처리
        return handler.next(response);
      },
      onError: (error, handler) async {
        // 401 Unauthorized 에러 처리
        // 토큰 재발급
        if (error.response?.statusCode == 401) {
          TokenModel? token = await _tokenManageService.loadToken();

          if (token != null && !token.isTokenExpired()) {
            String? newAccessToken = await _refreshAccessToken(token);

            if (newAccessToken != null) {
              await _tokenManageService.updateAccessToken(
                  newAccessToken, DateTime.now());

              error.requestOptions.headers['Authorization'] =
                  'Bearer $newAccessToken';

              // 요청 재시도 옵션 설정
              final opts = Options(
                method: error.requestOptions.method,
                headers: error.requestOptions.headers,
              );

              // 재요청 데이터
              final cloneRequest = await _dio.request(
                error.requestOptions.path,
                options: opts,
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
              );

              return handler.resolve(cloneRequest);
            }
          }
        }
        return handler.next(error);
      },
    ));
  }

  Dio get dio => _dio;

  // refreshToken 이용하여 토큰 갱신하는 메소드
  Future<String?> _refreshAccessToken(TokenModel token) async {
    try {
      // 사용자 이메일을 넘겨주어야 함
      // [Refactor] 사용자 정보를 Class 모델에 넣어서 사용하는 방식으로 변경
      User user = await UserApi.instance.me();

      Map<String, dynamic> requestData = {
        'kakaoAccount': user.kakaoAccount?.email,
        'refreshToken': token.refreshToken,
      };

      final response = await dio.post(
          '${Env.serverEndpoint}/api/v1/auth/refresh/token',
          data: requestData);

      if (response.statusCode == 200) {
        return response.data['accessToken'];
      }
    } catch (error) {
      print('토큰 갱신 실패: $error');
    }

    return null;
  }
}
