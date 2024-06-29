import 'package:json_annotation/json_annotation.dart';

part 'token.g.dart';

@JsonSerializable()
class TokenModel {
  final DateTime refreshTokenExpiration;
  final DateTime accessTokenExpiration;
  final DateTime issuedAt;
  final String accessToken;
  final String email;
  final String refreshToken;

  TokenModel({
    required this.refreshTokenExpiration,
    required this.accessTokenExpiration,
    required this.issuedAt,
    required this.accessToken,
    required this.email,
    required this.refreshToken,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json)
  => _$TokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenModelToJson(this);
}
