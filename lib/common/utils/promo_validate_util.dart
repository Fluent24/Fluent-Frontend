/// 승급전 임계값, master 이후에는 승급전 없음
final Map<String, int> _promoThreshold = {
  'bronze': 100,
  'silver': 200,
  'gold': 500,
  'diamond': 1000,
};

class PromoManagement {
  /// 승급전 여부를 반환하는 함수
  static bool isPromoEnabled({required String tier, required int exp}) {
    /// 티어별 승급전 임계값을 넘은 경우 승급전 활성화
    if (exp >= _promoThreshold[tier]!) {
      return true;
    }
    /// 티어별 승급전 임계값을 넘지 못한 경우 승급전 비활성화
    else {
      return false;
    }
  }

  /// 승급전 통과 여부를 반환하는 함수
  static bool isPromoPassed({required double avgScore}) {
    /// 3문제 평균 점수 7.0 이상 시 통과
    if (avgScore >= 7.0) {
      return true;
    }
    else {
      return false;
    }
  }

  /// 승급전까지의 진행률을 반환하는 함수
  static double getProgress({required String tier, required int exp}) {
    return (exp / _promoThreshold[tier]!);
  }
}
