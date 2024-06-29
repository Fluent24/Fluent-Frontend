import 'package:json_annotation/json_annotation.dart';

part 'pagination.g.dart';

/// Pagination에 사용되는 데이터 불러오기
/// 리더보드 UserModel 목록 / 복습하기 HistoryModel 목록 해당
/// T에 받고자 하는 타입 지정
@JsonSerializable(
  // T generic 사용할 때 지정해주어야 하는 옵션
  genericArgumentFactories: true,
)
class PaginationModel<T> {
  final List<T> data;

  PaginationModel({ required this.data });

  /// T fromJsonT: json으로부터 받은 값을 T type으로 변환하는 함수
  factory PaginationModel.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT)
  => _$PaginationModelFromJson(json, fromJsonT);
}