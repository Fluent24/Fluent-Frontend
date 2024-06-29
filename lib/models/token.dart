class TokenModel {
  final String accessToken;
  final String refreshToken;
  final int expirationTime;
  final String tokenType;
  final DateTime issuedAt;

  TokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expirationTime,
    required this.tokenType,
    required this.issuedAt
  });

  // 토큰 만료 시간 계산 메소드
  DateTime getExpirationTime() {
    return issuedAt.add(Duration(seconds: expirationTime));
  }

  // 토큰이 만료되었는지 확인하는 메소드
  bool isTokenExpired() {
    DateTime now = DateTime.now();
    return now.isAfter(getExpirationTime());
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expirationTime': expirationTime,
      'tokenType': tokenType,
      'issuedAt': issuedAt.toIso8601String(), // DateTime -> String
    };
  }

  // API 통신으로 받은 json 데이터 -> 클래스 인스턴스로 변경
  factory TokenModel.fromJson(Map<String, dynamic> json) {
    // token 정보가 누락된 경우, 에러 반환
    if (!json.containsKey('accessToken') || !json.containsKey('expirationTime')) {
      throw Exception('필요한 토큰 정보가 비어 있습니다.');
    }

    return TokenModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      expirationTime: json['expirationTime'] as int,
      tokenType: json['tokenType'],
      issuedAt: DateTime.now(), // 서버로부터 생성 시간을 받을 수 있도록 변경해야 함
      // issuedAt: DateTime.parse(json['issuedAt']),
      // String -> DateTime
    );
  }
}
