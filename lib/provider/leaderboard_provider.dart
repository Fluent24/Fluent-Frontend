// // 캐시를 관리하는 모든 provider는 stateProvider를 사용한다.
// // leaderboard view model

import 'package:fluent/models/user.dart';
import 'package:fluent/provider/user_provider.dart';
import 'package:fluent/repository/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final leaderboardTierProvider = Provider.family<List<UserModel>, String>((ref, tier) {
  final state = ref.watch(leaderboardProvider);

  if (state.isEmpty) {
    return [];
  }

  return state.where((element) => element.tier == tier).toList();
});

/// UserModel 목록을 관리
final leaderboardProvider =
    StateNotifierProvider<LeaderboardStateNotifier, List<UserModel>>((ref) {
  // userRepository 가져오기
  final repository = ref.watch(userRepositoryProvider);
  final userModel = ref.watch(userModelProvider);

  final notifier = LeaderboardStateNotifier(
      repository: repository, initialTier: userModel.tier);

  return notifier;
});

class LeaderboardStateNotifier extends StateNotifier<List<UserModel>> {
  final UserRepository repository;
  String? _tier;

  // state 기본값 : 빈 리스트
  LeaderboardStateNotifier({
    required this.repository,
    required String initialTier,
  }) : super([]) {
    _tier = initialTier;
    getLeaderBoardData();
  }

  /// 사용자 목록을 받아서 리스트를 채우는 함수
  /// UserModelStateNotifier 인스턴스 생성되면 바로 실행되어야 함
  Future<void> getLeaderBoardData() async {
    if (_tier != null) {
      try {
        final List<UserModel> resp = await repository.getUserPaginate();
        state = resp;
      } catch (e) {
        print('[ERR] Failed to fetch leaderboard list: $e');
      }
    }
  }

  List<UserModel> paginate() {
    if (_tier != null) {
      return state.where((element) => element.tier == _tier).toList();
    }
    else {
      return [];
    }
  }

  // 선택된 tier를 변경하여 결과 사용자 목록을 다시 불러옴
  void setTier(String tier) {
    _tier = tier;
    paginate();
  }
}
