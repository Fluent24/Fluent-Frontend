import 'package:json_annotation/json_annotation.dart';

part 'history.g.dart';

@JsonSerializable()
class HistoryModel {
  /// 서버로부터 history 데이터를 받은 경우에만 id 부여
  /// history 생성 시에는 id 값 존재하지 않음
  @JsonKey(includeToJson: false)
  int? historyId;
  final double score;
  final String solverDate;
  final String memberId; // 이메일임
  final int quizId;

  HistoryModel({
    this.historyId,
    required this.score,
    required this.solverDate,
    required this.memberId,
    required this.quizId,
  });

  HistoryModel copyWith({
    int? historyId,
    double? score,
    String? solverDate,
    String? memberId,
    int? quizId,
  }) {
    return HistoryModel(
      historyId: historyId ?? this.historyId,
      score: score ?? this.score,
      solverDate: solverDate ?? this.solverDate,
      memberId: memberId ?? this.memberId,
      quizId: quizId ?? this.quizId,
    );
  }

  factory HistoryModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryModelToJson(this);
}
