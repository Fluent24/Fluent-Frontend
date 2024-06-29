class PromoModel {
  final int currentStep; // 현재 문제를 푼 개수
  final List<double> scores; // 점수 기록

  PromoModel({
    required this.currentStep,
    required this.scores,
  });

  double get averageScore => scores.isEmpty ? 0.0 : scores.reduce((a, b) => a + b) / scores.length;

  PromoModel copyWith({
    int? currentStep,
    List<double>? scores,
  }) {
    return PromoModel(
      currentStep: currentStep ?? this.currentStep,
      scores: scores ?? this.scores,
    );
  }
}
