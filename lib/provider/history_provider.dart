// 캐시를 관리하는 모든 provider는 stateProvider를 사용한다.
// history view model

import 'package:fluent/models/history.dart';
import 'package:fluent/repository/history_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// HistoryModel 목록을 관리
final historyModelProvider =
    StateNotifierProvider<HistoryModelStateNotifier, List<HistoryModel>>((ref) {
  // hisotryRepository 가져오기
  final repository = ref.watch(historyRepositoryProvder);

  final notifier = HistoryModelStateNotifier(repository: repository);

  return notifier;
});

class HistoryModelStateNotifier extends StateNotifier<List<HistoryModel>> {
  final HistoryRepository repository;

  // state 기본값 : 빈 리스트
  HistoryModelStateNotifier({
    required this.repository,
  }) : super([]) {
    paginate();
  }

  /// 히스토리 목록을 받아서 리스트를 채우는 함수
  /// HistoryModelStateNotifier 인스턴스 생성되면 바로 실행되어야 함
  Future<void> paginate() async {
    try {
      final resp = await repository.getHistoryPaginate();
      state = resp;
      print('[LOG] Fetch history list');
    } catch (e) {
      print('[ERR] Failed to fetch get history list: $e');
    }
  }

  Future<void> addHistory(HistoryModel historyModel) async {
    try {
      print('[LOG] ADD HISTORY : SCORE - ${historyModel.score} DATE - ${historyModel.solverDate} QUIZ ID - ${historyModel.quizId}');
      final resp = await repository.addHistory(historyModel: historyModel);
      state = [
        ...state,
        resp,
      ];

    } catch (e) {
      print('[ERR] Failed to fetch add history: $e');
    }
  }

  Future<void> deleteHistory(int historyId) async {
    try {
      print('[LOG] DELETE HISTORY : historyId - $historyId');
      await repository.deleteHistory(id: historyId);
      // 현재 historyId인 값을 제외한 history 리스트로 재구성
      state = state.where((element) => element.historyId != historyId).toList();

    } catch (e) {
      print('[ERR] Failed to delete history: $e');
    }
  }

  /// 히스토리 목록을 받아서 주간 평균 점수를 계산하여 반환하는 함수
  /// 총 5주차 반환
  List<double> getWeeklyAvgScore() {
    List<double> weeklyAvgScore = [];
    // state.sort() 사용 시 in-place로 적용되는 것을 방지하기 위해 toList()..sort() 적용
    List<HistoryModel> sortedHistoryList = state.toList()
      ..sort((h1, h2) {
        return DateTime.parse(h1.solverDate)
            .compareTo(DateTime.parse(h2.solverDate));
      });

    DateTime now = DateTime.now();
    DateTime fiveWeeksAgo = now.subtract(const Duration(days: 5 * 7));

    for (int i = 0; i < 5; i++) {
      DateTime startDate = fiveWeeksAgo.add(Duration(days: i * 7));
      DateTime endDate = startDate.add(const Duration(days: 7));

      // 해당 주차 히스토리 필터링 및 해당 주차 점수 리스트
      List<double> scoreInWeek = sortedHistoryList
          .where((history) {
            DateTime historyDate = DateTime.parse(history.solverDate);

            if (historyDate
                    .isAfter(startDate.subtract(const Duration(days: 1))) &&
                historyDate
                    .isBefore(endDate.subtract(const Duration(days: 1)))) {
              return true;
            } else {
              return false;
            }
          })
          .map((history) => history.score)
          .toList();

      double avgScore = scoreInWeek.isNotEmpty
          ? scoreInWeek.reduce((a, b) => a + b) / scoreInWeek.length
          : 0.0;

      weeklyAvgScore.add(avgScore);
    }

    return weeklyAvgScore;
  }
}
