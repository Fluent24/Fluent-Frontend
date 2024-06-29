import 'package:fluent/common/services/kakao_login_service.dart';
import 'package:fluent/common/utils/data_utils.dart';
import 'package:fluent/common/utils/dialog_util.dart';
import 'package:fluent/provider/history_provider.dart';
import 'package:fluent/widgets/chart.dart';
import 'package:fluent/widgets/profile_image.dart';
import 'package:fluent/widgets/text.dart';
import 'package:fluent/widgets/waveform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/user_provider.dart';

// 내 프로필 화면
class MyProfileScreen extends ConsumerStatefulWidget {
  const MyProfileScreen({super.key});

  @override
  ConsumerState<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends ConsumerState<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final kakaoLoginService = ref.read(kakaoLoginServiceProvider.notifier);
    final userData = ref.watch(userModelProvider);
    final historyData = ref.watch(historyModelProvider);

    if (userData.isLoading || historyData.isEmpty) {
      return Scaffold(
        body: Center(
          child: waveForm(),
        ),
      );
    } else {
      final weeklyData = ref.read(historyModelProvider.notifier);
      print(weeklyData.getWeeklyAvgScore());
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white24,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 사용자 프로필 영역
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 5.5,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0)),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueAccent,
                        Colors.blueAccent.withOpacity(0.8)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.6),
                        offset: const Offset(0, 1),
                        spreadRadius: 3,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProfileImage(
                        size: 80,
                        canEdit: false,
                      ),

                      // 프로필 닉네임 + 랭크 영역
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionText(
                            text: userData.nickName,
                            fontWeight: FontWeight.w900,
                            fontSize: 32,
                            color: Colors.white,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/tiers/${userData.tier}.png',
                                scale: 50,
                              ),
                              const SizedBox(width: 5),
                              SectionText(
                                text: capitalize(userData.tier),
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(
                        width: 50.0,
                      ),
                    ],
                  ),
                ),

                // 주간 차트 영역
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 32.0),
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.15),
                        offset: const Offset(0, 1),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionText(
                        text: 'Weekly Chart',
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),

                      const SizedBox(height: 16.0),
                      // 그래프 --> 6주치 데이터 받아오기
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white.withOpacity(0.7),
                        ),
                        child: WeeklyLineChart(
                          weeks: getPreviousFiveWeeks(5),
                          scores: ref
                              .read(historyModelProvider.notifier)
                              .getWeeklyAvgScore(),
                        ),
                      ),

                      const SizedBox(height: 12.0),
                    ],
                  ),
                ),

                // 로그아웃
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 1),
                        blurRadius: 1,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: () async {
                      // 카카오 로그아웃 및 토큰 삭제 후 앱 종료
                      bool? result = await DialogUtil.showConfirmDialog(
                        context: context,
                        title: 'Are you sure you want to sign out?',
                        subtitle: '',
                        route: Routes.logout,
                      );

                      print('[LOG] RESULT STATE - $result');
                      if (!mounted) return;

                      // result == false --> 취소 버튼 클릭
                      if (result == false) {
                        // showDialog 함수 내부에서 pop 진행함
                        return;
                      } else {
                        Future.delayed(const Duration(milliseconds: 1500),
                            () async {
                          await kakaoLoginService.kakaoLogout();
                          // 모든 화면 닫고 splash 화면으로 이동
                          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                        });
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    child: SectionText(
                      text: 'Sign Out',
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  /// 히스토리로부터 주간 점수 평균을 구하는 함수
  List<String> getPreviousFiveWeeks(int weeks) {
    // 오늘 날짜
    DateTime today = DateTime.now();

    // 결과 저장 리스트
    List<String> dates = [];
    dates.add(DateTimeUtil.formatDate(today));


    // 1주 전부터 주별로 날짜 계산하여 리스트에 추가
    for (int i = 1; i < weeks; i++) {
      DateTime previousDate = today.subtract(Duration(days: i * 7));
      String formattedDate = DateTimeUtil.formatDate(previousDate);
      dates.add(formattedDate);
    }

    dates = dates.reversed.toList();

    return dates;
  }
}
