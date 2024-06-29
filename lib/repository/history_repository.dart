import 'package:fluent/common/dio/dio.dart';
import 'package:fluent/env/env.dart';
import 'package:fluent/models/history.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

// retrofit Headers를 사용하는 경우 hide 필요
import 'package:dio/dio.dart' hide Headers;

part 'history_repository.g.dart';

final historyRepositoryProvder = Provider<HistoryRepository>((ref) {
  // watch - 변경 발생 시, provider를 다시 build
  // provider 내부에서 사용 시에 watch 사용하는 것 권장
  final dio = ref.watch(dioProvider);

  final repository = HistoryRepository(dio, baseUrl: '${Env.serverEndpoint}/api/histories');

  return repository;
});

/// 사용자 정보 관련 API 통신 영역
@RestApi()
abstract class HistoryRepository {
  // baseUrl: ${Env.serverEndpoint}/api/histories
  factory HistoryRepository(Dio dio, {String baseUrl}) = _HistoryRepository;

  // 복습하기 목록 조회
  // ${Env.serverEndpoint}/api/histories
  @GET('')
  @Headers({
    'accessToken': 'true',
  })
  Future<List<HistoryModel>> getHistoryPaginate();

  // 복습하기 목록에 추가
  // ${Env.serverEndpoint}/api/histories
  @POST('')
  @Headers({
    'accessToken': 'true',
  })
  Future<HistoryModel> addHistory({
    @Body() required HistoryModel historyModel,
  });

  // 복습하기 목록에서 삭제
  // ${Env.serverEndpoint}/api/histories/:id
  @DELETE('/{id}')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> deleteHistory({
    @Path() required int id,
  });
}
