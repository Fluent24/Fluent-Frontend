import 'package:fluent/models/promo.dart';
import 'package:fluent/provider/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final promoModelProvider =
    StateNotifierProvider<PromoModelNotifier, PromoModel>((ref) {
  final userModel = ref.watch(userModelProvider.notifier);
  final notifier = PromoModelNotifier(isPromo: userModel.isPromoEnabled());
  return notifier;
});

class PromoModelNotifier extends StateNotifier<PromoModel> {
  bool isPromo;

  PromoModelNotifier({
    required this.isPromo,
  }) : super(PromoModel(currentStep: 0, scores: []));

  void addScore(double score) {
    state = PromoModel(
      currentStep: state.currentStep + 1,
      scores: [...state.scores, score],
    );
  }

  void reset() {
    state = PromoModel(currentStep: 0, scores: []);
  }
}
