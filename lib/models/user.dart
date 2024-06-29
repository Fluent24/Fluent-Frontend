import 'package:fluent/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserModel {
  final String email;
  final String nickName;
  String? profilePictureUrl; // 이후 서버로부터 스토리지에 저장된 이미지 파일 경로를 받음
  @JsonKey(fromJson: TierUtil.tierMapping)
  final String tier;
  int exp;
  @JsonKey(fromJson: FavoriteUtils.makeNullList)
  final List<String> favorites;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isLoading;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isError;

  UserModel({
    required this.nickName,
    required this.tier,
    required this.exp,
    required this.email,
    this.profilePictureUrl,
    required this.favorites,
    this.isLoading = false,
    this.isError = false,
  });

  UserModel copyWith({
    String? nickName,
    String? tier,
    String? email,
    int? exp,
    String? profilePictureUrl,
    List<String>? favorites,
    bool? isLoading,
    bool? isError,
  }) {
    return UserModel(
      nickName: nickName ?? this.nickName,
      tier: tier ?? this.tier,
      email: email ?? this.email,
      exp: exp ?? this.exp,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // UserModel 기본값 제공하는 팩토리 메서드
  factory UserModel.empty() {
    return UserModel(
        nickName: '', tier: '', exp: 0, email: '', favorites: [], isLoading: true);
  }
}
