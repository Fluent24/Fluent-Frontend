// // 캐시를 관리하는 모든 provider는 stateProvider를 사용한다.
// // question view model
//
import 'package:dio/dio.dart';
import 'package:fluent/models/question.dart';
import 'package:fluent/repository/question_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final questionModelProvider =
    StateNotifierProvider<QuestionModelNotifier, QuestionModel>((ref) {
  final repository = ref.watch(questionRepositoryProvider);

  final notifier = QuestionModelNotifier(repository: repository);

  return notifier;
});

class QuestionModelNotifier extends StateNotifier<QuestionModel> {
  final QuestionRepository repository;

  QuestionModelNotifier({
    required this.repository,
  }) : super(QuestionModel.empty());

  Future<void> getQuestion() async {
    try {
      final resp = await repository.getQuestion();
      state = resp.copyWith(isError: false, isLoading: false);
    } on DioError catch (e) {
      print('[ERR] Failed to fetch question: ${e.message}');

      if (e.response != null) {
        print('[LOG] Response status: ${e.response?.statusCode}');
        print('[LOG] Response data: ${e.response?.data}');
      }
      state = state.copyWith(isError: true, isLoading: false);
    }
  }

  Future<void> getQuestionWithId(int quizId) async {
    try {
      final resp = await repository.getQuestionWithId(id: quizId);
      print('[LOG] QUIZ RESP CHECK : $resp');
      state = resp.copyWith(isError: false, isLoading: false);
    } on DioError catch (e) {
      print('[ERR] Failed to fetch question with id: ${e.message}');

      if (e.response != null) {
        print('[LOG] Response status: ${e.response?.statusCode}');
        print('[LOG] Response data: ${e.response?.data}');
      }

      state = state.copyWith(isError: true, isLoading: false);
    }
  }

  void reset() {
    state = QuestionModel.empty();
  }
}
