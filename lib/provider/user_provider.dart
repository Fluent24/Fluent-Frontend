// // 캐시를 관리하는 모든 provider는 stateProvider를 사용한다.
// // user view model
//
import 'package:fluent/common/utils/promo_validate_util.dart';
import 'package:fluent/models/user.dart';
import 'package:fluent/repository/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// UserModel 목록을 관리
final userModelProvider = StateNotifierProvider<UserModelStateNotifier, UserModel>((ref) {
  // userRepository 가져오기
  final repository = ref.watch(userRepositoryProvider);

  final notifier = UserModelStateNotifier(repository: repository);

  return notifier;
});

class UserModelStateNotifier extends StateNotifier<UserModel> {
  final UserRepository repository;

  // state 기본값 : 빈 리스트
  UserModelStateNotifier({
    required this.repository,
  }) : super(UserModel.empty()) {
    getUser();
  }

  /// 사용자 목록을 받아서 리스트를 채우는 함수
  /// UserModelStateNotifier 인스턴스 생성되면 바로 실행되어야 함
  Future<void> getUser() async {
    try {
      final resp = await repository.getUserInfo();
      state = resp.copyWith(isError: false, isLoading: false);
    }
    catch (e) {
      print('[ERR] Failed to fetch user info: $e');
      state = state.copyWith(isError: true);
    }
  }

  /// 승급 처리 후 사용자 티어 및 경험치 업데이트 처리 함수
  Future<void> updateUser(double avgScore) async {
    try {
      final Map<String, dynamic> requestData = {
        'averageScore': avgScore,
      };
      final resp = await repository.promoProcess(body: requestData);
      state = resp.copyWith(isError: false, isLoading: false);
    }
    catch (e) {
      print('[ERR] Failed to fetch update user info: $e');
      state = state.copyWith(isError: true);
    }
  }

  bool isPromoEnabled() {
    return PromoManagement.isPromoEnabled(tier: state.tier, exp: state.exp);
  }
}
