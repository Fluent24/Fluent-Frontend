// 복습하기 (문제 리스트) 화면
import 'package:fluent/common/utils/dialog_util.dart';
import 'package:fluent/models/history.dart';
import 'package:fluent/provider/history_provider.dart';
import 'package:fluent/repository/history_repository.dart';
import 'package:fluent/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key});

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  /// 서버로부터 사용자 정보를 가져오는 함수
  /// 캐시에 사용자 정보가 존재하면 API 통신 X
  /// 사용자 정보가 존재하지 않으면 API 통신
  Future<List<HistoryModel>> getHistoryPaginate(WidgetRef ref) async {
    /// 하단 서버 통신 코드로 실행시키려면 위 함수 삭제하고 future:에 아래 명령 삽입하기
    return ref.watch(historyRepositoryProvder).getHistoryPaginate();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(historyModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: SectionText(
          text: 'Review',
          fontWeight: FontWeight.w600,
          fontSize: 18.0,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<List<HistoryModel>>(
          future: getHistoryPaginate(ref),
          builder: (_, AsyncSnapshot<List<HistoryModel>> snapshot) {
            // API 통신 중일 때
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) => _buildShimmerCard(),
                itemCount: 10,
              );
            }
            // API 통신 혹은 기타 에러 발생 시
            else if (snapshot.hasError) {
              return Center(
                  child: SectionText(text: 'Error: ${snapshot.error}'));
            }
            // API 통신 성공한 경우 또는 캐시로부터 데이터를 가져온 경우
            else if (snapshot.hasData) {
              List<HistoryModel> historyData = snapshot.data!;

              return ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      // 학습하기 (복습) 화면으로 이동
                      bool? result = await DialogUtil.showConfirmDialog(
                        context: context,
                        title:
                            'Would you like to start reviewing this sentence?',
                        subtitle: '',
                        route: Routes.review,
                      );

                      if (!mounted) return;

                      // result == false --> 취소 버튼 클릭
                      if (result == true) {
                        final int quizId = historyData[index].quizId;
                        print('[LOG] NAVIGATE TO LEARN SCREEN');
                        Navigator.pushNamed(context, '/learn', arguments: {'quizId': quizId, 'historyId': historyData[index].historyId!});
                      }
                    },
                    child: _historyCard(
                      title: 'Section ${index + 1}',
                      historyModel: historyData[index],
                    ),
                  );
                },
                itemCount: historyData.length,
              );
            } else {
              return Center(
                child: SectionText(
                  text: 'No Data',
                ),
              );
            }
          }),
    );
  }

  /// API 통신 과정 중일 때 화면에 보여지는 학습하기 위젯
  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: _historyCard(),
    );
  }

  Container _historyCard({String? title, HistoryModel? historyModel}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: const Color(0xFF0085FF).withOpacity(0.6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 재생 아이콘
          const Icon(
            Icons.play_circle,
            size: 30,
            color: Colors.white,
          ),

          const SizedBox(width: 12.0),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionText(
                text: title ?? '',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),

              // 이전 풀이 일자
              Row(
                children: [
                  SectionText(
                    text: 'Last: ${historyModel?.solverDate ?? '-'}',
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),

                  const SizedBox(width: 8.0),

                  // 이전 점수
                  SectionText(
                    text: 'score: ${historyModel?.score ?? '-'}',
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
