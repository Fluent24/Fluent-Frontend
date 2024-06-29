import 'package:fluent/common/dio/dio.dart';
import 'package:fluent/env/env.dart';
import 'package:fluent/models/question.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';
import 'package:dio/dio.dart' hide Headers;

part 'question_repository.g.dart';

// 순서 retrofit abstract class 선언 -> Provider 등록

final questionRepositoryProvider = Provider<QuestionRepository>((ref) {
  final dio = ref.watch(dioProvider);

  final repository = QuestionRepository(dio, baseUrl: '${Env.serverEndpoint}/api/quizzes');

  return repository;
});

@RestApi()
abstract class QuestionRepository {
  // baseUrl: ${Env.serverEndpoint}/api/quizzes
  factory QuestionRepository(Dio dio, {String baseUrl}) = _QuestionRepository;

  /// 학습하기 문제 1개 가져오기
  @GET('')
  @Headers({
    'accessToken': 'true'
  })
  Future<QuestionModel> getQuestion();

  /// 이전에 푼 문제 1개 가져오기
  @GET('/{id}')
  @Headers({
    'accessToken': 'true'
  })
  Future<QuestionModel> getQuestionWithId({
    @Path() required int id,
  });
}