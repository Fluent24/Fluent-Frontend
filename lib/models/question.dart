import 'package:fluent/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable()
class QuestionModel {
  @JsonKey(includeFromJson: true, includeToJson: false)
  int? quizId;
  final String question;
  final String favorite;
  final String refAudio;
  @JsonKey(fromJson: TierUtil.tierMapping)
  final String tier;
  final int answerVec;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isLoading; // API 통신 중일 때 로딩 중 표시
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isError; // API 통신 중 에러 발생 시 true로 변경

  QuestionModel({
    this.quizId,
    required this.question,
    required this.tier,
    required this.refAudio,
    required this.favorite,
    required this.answerVec,
    this.isLoading = false,
    this.isError = false,
  });

  /// 인스턴스 대체
  QuestionModel copyWith({
    int? quizId,
    String? question,
    String? tier,
    String? refAudio,
    String? favorite,
    int? answerVec,
    bool? isLoading,
    bool? isError,
  }) {
    return QuestionModel(
      quizId: quizId ?? this.quizId,
      question: question ?? this.question,
      tier: tier ?? this.tier,
      refAudio: refAudio ?? this.refAudio,
      favorite: favorite ?? this.favorite,
      answerVec: answerVec ?? this.answerVec,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
    );
  }

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);

  factory QuestionModel.empty() {
    return QuestionModel(
      question: '',
      tier: '',
      refAudio: '',
      favorite: '',
      answerVec: 0,
      isLoading: true,
      isError: false,
    );
  }
}
