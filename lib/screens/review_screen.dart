// 복습하기 (문제 리스트) 화면
import 'package:fluent/common/dialog_util.dart';
import 'package:fluent/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  bool canEdit = false;

  // API 통신하여 복습 문제 가져오기 or 캐싱 데이터
  List<Map<String, dynamic>> histories = [
    {
      'historyId': 1,
      'score': 3,
      'solverDate': '2024-05-31',
    },
    {
      'historyId': 2,
      'score': 2,
      'solverDate': '2024-05-31',
    },
    {
      'historyId': 3,
      'score': 4,
      'solverDate': '2024-05-31',
    },
    {
      'historyId': 4,
      'score': 1,
      'solverDate': '2024-06-01',
    },
    {
      'historyId': 5,
      'score': 3,
      'solverDate': '2024-06-01',
    },
    {
      'historyId': 6,
      'score': 2,
      'solverDate': '2024-06-01',
    },
    {
      'historyId': 7,
      'score': 3,
      'solverDate': '2024-06-01',
    },
    {
      'historyId': 8,
      'score': 4,
      'solverDate': '2024-06-02',
    },
    {
      'historyId': 9,
      'score': 2,
      'solverDate': '2024-06-02',
    },
    {
      'historyId': 10,
      'score': 5,
      'solverDate': '2024-06-03',
    },
    {
      'historyId': 11,
      'score': 3,
      'solverDate': '2024-06-03',
    },
    {
      'historyId': 12,
      'score': 5,
      'solverDate': '2024-06-03',
    },
    {
      'historyId': 13,
      'score': 3,
      'solverDate': '2024-06-04',
    },
  ];

  final Set<int> _selectedIndexes = {};

  @override
  Widget build(BuildContext context) {
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
        actions: [
          // 복습하기 문장 편집 버튼
          IconButton(
            padding: const EdgeInsets.all(18.0),
            highlightColor: Colors.transparent,
            onPressed: () {
              setState(() {
                canEdit = !canEdit;

                // 편집 종료 시 선택 항목 초기화
                if (!canEdit) {
                  _selectedIndexes.clear();
                }
              });
            },
            icon: canEdit
                ? const FaIcon(
                    FontAwesomeIcons.check,
                    size: 20.0,
                  )
                : const FaIcon(
                    FontAwesomeIcons.penToSquare,
                    size: 20.0,
                  ),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              if (!canEdit) {
                // 학습하기 (복습) 화면으로 이동
                // arguments로 현재 선택한 문제 id 값 넘겨주기
                bool? result = await showConfirmDialog(
                  context: context,
                  title: 'Would you like to start reviewing this sentence?',
                  subtitle: '',
                  route: Routes.review,
                );

                if (!mounted) return;

                // result == false --> 취소 버튼 클릭
                if (result == null) {
                  Navigator.pushNamed(context, '/learn');
                }
              }
            },
            child: Container(
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
                  // 체크박스 생성 영역
                  if (canEdit)
                    Checkbox(
                      value: _selectedIndexes.contains(index),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedIndexes.add(index);
                          } else {
                            _selectedIndexes.remove(index);
                          }
                        });
                      },
                      side: const BorderSide(
                        color: Colors.white,
                        width: 3.0,
                      ),
                      activeColor: Colors.white,
                      checkColor: Colors.blueAccent,
                      tristate: false,
                    ),

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
                        text: 'Sentence ${index + 1}',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),

                      // 이전 풀이 일자
                      Row(
                        children: [
                          SectionText(
                            text: 'Last: ${histories[index]['solverDate']}',
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),

                          const SizedBox(width: 8.0),

                          // 이전 점수
                          SectionText(
                            text: 'score: ${histories[index]['score']}',
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
            ),
          );
        },
        itemCount: histories.length,
      ),
      floatingActionButton: canEdit
          ? FloatingActionButton(
              // 삭제하기 버튼
              onPressed: () {
                setState(() {
                  // 문장 목록에서 체크한 문장 삭제
                  _selectedIndexes.toList().reversed.forEach((index) {
                    histories.removeAt(index);
                  });

                  // 체크 리스트 초기화
                  _selectedIndexes.clear();
                });
              },
              backgroundColor: Colors.white,
              child: const FaIcon(
                FontAwesomeIcons.trashCan,
                size: 24.0,
                color: Colors.black,
              ),
            )
          : null,
    );
  }
}
