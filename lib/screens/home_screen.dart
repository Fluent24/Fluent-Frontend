import 'package:fluent/common/utils/promo_validate_util.dart';
import 'package:fluent/models/user.dart';
import 'package:fluent/provider/user_provider.dart';
import 'package:fluent/repository/interest_repository.dart';
import 'package:fluent/repository/user_repository.dart';
import 'package:fluent/widgets/progress_bar.dart';
import 'package:fluent/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../models/interest.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  /// 서버로부터 사용자 정보를 가져오는 함수
  /// 캐시에 사용자 정보가 존재하면 API 통신 X
  /// 사용자 정보가 존재하지 않으면 API 통신
  Future<UserModel> getUserInfo(WidgetRef ref) async {
    // final email =
    //     UserCacheRepository.readUserInfo(type: InfoType.email) as String?;

    // 캐시에 이메일이 존재하지 않는 경우 에러 반환
    // 캐시에서 가져오는 로직 필요하지 않을 수도 있음 -> Provider로 UserModel 설정해두면 어디서든 가져와서 사용 가능
    // if (email == null) {
    //   throw Exception('email not found');
    // }

    // 이 코드를 나중에는 userModelProvider에서 가져오는 방식으로 변경해야 함
    final userModel = ref.watch(userModelProvider);
    if (userModel.isLoading) {
      return ref.watch(userRepositoryProvider).getUserInfo();
    }
    else {
      return userModel;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userModel = ref.watch(userModelProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder<UserModel>(
        future: getUserInfo(ref),
        builder: (_, AsyncSnapshot<UserModel> snapshot) {
          // API 통신 중일 때
          if (snapshot.connectionState == ConnectionState.waiting && userModel.isLoading) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildShimmerTopPanel(context),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      children: [
                        _buildShimmerInterests(),
                        _buildShimmerLearn(),
                        _homeScreenContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 복습하기 라벨
                              SectionText(
                                  text: 'Review',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700),

                              const SizedBox(height: 10),

                              TextButton(
                                onPressed: null, // 로딩 중일 때는 눌러도 반응 없도록 설정
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(
                                      color: Colors.blueAccent,
                                      width: 1,
                                    ),
                                  ),
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width, 0),
                                  foregroundColor: Colors.blueAccent,
                                ),
                                child: SectionText(
                                  text: 'Start',
                                  fontSize: 16,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          // API 통신 혹은 기타 에러 발생 시
          else if (snapshot.hasError) {
            return Center(child: SectionText(text: 'Error: ${snapshot.error}'));
          }
          // API 통신 성공한 경우 또는 캐시로부터 데이터를 가져온 경우
          else if (snapshot.hasData) {
            final mockUserModel = snapshot.data!;
            final progress = PromoManagement.getProgress(
              tier: mockUserModel.tier,
              exp: mockUserModel.exp,
            );
            final isPromoEnabled = PromoManagement.isPromoEnabled(
              tier: mockUserModel.tier,
              exp: mockUserModel.exp,
            );

            return SingleChildScrollView(
              // FutureBuilder 이용해서 사용자 정보 가져오는 코드로 변경하기
              child: Column(
                children: [
                  Stack(
                    children: [
                      // 사용자 프로필 + 오늘 학습량 + 연속 학습 일수 + 랭킹 표시 영역
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 4,
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0)),
                            gradient: LinearGradient(
                              colors: [
                                Colors.blueAccent.withOpacity(0.9),
                                Colors.blueAccent
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueAccent.withOpacity(0.5),
                                offset: const Offset(0, 2),
                                spreadRadius: 1,
                                blurRadius: 1,
                              )
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 승급전까지 진행률 표시 영역
                            SectionText(
                              text: 'Promo Rate',
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                            const SizedBox(height: 24.0),
                            ProgressBar(
                              percent: progress,
                              barColor: const Color(0xFF9DFFCA),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8.0),

                  // 하단 위젯 영역 (관심사, 학습하기, 복습하기 영역)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      children: [
                        // 사용자 관심사 영역
                        _homeScreenContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 관심사 라벨
                              SectionText(
                                text: 'Interests',
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),

                              const SizedBox(height: 16.0),

                              // 관심사 영역
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children:
                                    _printFavorites(mockUserModel.favorites),
                              ),
                            ],
                          ),
                        ),

                        // 학습하기
                        _homeScreenContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 학습하기 라벨
                              SectionText(
                                text:
                                    isPromoEnabled ? 'Promo🔥' : 'Daily Course',
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),

                              const SizedBox(height: 10),

                              TextButton(
                                onPressed: () {
                                  // 학습하기 화면으로 이동
                                  Navigator.pushNamed(context, '/learn');
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width, 0),
                                  foregroundColor: Colors.white,
                                ),
                                child: SectionText(
                                  text: 'Start',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 복습하기
                        _homeScreenContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 복습하기 라벨
                              SectionText(
                                  text: 'Review',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700),

                              const SizedBox(height: 10),

                              TextButton(
                                onPressed: () {
                                  // 학습하기 화면으로 이동
                                  Navigator.pushNamed(context, '/review');
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(
                                      color: Colors.blueAccent,
                                      width: 1,
                                    ),
                                  ),
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width, 0),
                                  foregroundColor: Colors.blueAccent,
                                ),
                                child: SectionText(
                                  text: 'Start',
                                  fontSize: 16,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: SectionText(
                text: 'No Data',
              ),
            );
          }
        },
      ),
    );
  }

  /// 홈 화면에 관심사 목록을 출력하는 함수
  List<Widget> _printFavorites(List<String> favorites) {
    return favorites.map((interest) {
      final Interest currentInterest =
          interests.where((element) => element.label == interest).first;

      return Container(
        margin: const EdgeInsets.only(right: 12.0),
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 3.0),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(width: 1, color: currentInterest.color),
          ),
          color: Colors.white,
        ),
        child: SectionText(
          text: currentInterest.label,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          // fontStyle: FontStyle.italic,
          color: currentInterest.color,
        ),
      );
    }).toList();
  }

  /// 홈 화면 시작하기 컨테이너 위젯
  Container _homeScreenContainer({required Widget child}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset: const Offset(0, 2),
              blurRadius: 1,
              spreadRadius: 0,
            ),
          ]),
      child: child,
    );
  }

  /// API 통신 과정 중일 때 화면에 보여지는 상단 패널 위젯
  Widget _buildShimmerTopPanel(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 4,
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0)),
        color: Colors.blueAccent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionText(
            text: 'Promo Rate',
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
          const SizedBox(height: 50.0),
          Shimmer.fromColors(
            baseColor: const Color(0xFF9DFFCA),
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 32.0,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// API 통신 과정 중일 때 화면에 보여지는 학습하기 위젯
  Widget _buildShimmerLearn() {
    return _homeScreenContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 학습하기 라벨
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 120.0,
              height: 38.0,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 10),

          TextButton(
            onPressed: null,
            style: TextButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              minimumSize: Size(MediaQuery.of(context).size.width, 0),
              foregroundColor: Colors.white,
            ),
            child: SectionText(
              text: 'Start',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// API 통신 과정 중일 때 화면에 보여지는 관심사 위젯
  Widget _buildShimmerInterests() {
    return _homeScreenContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 관심사 라벨
          SectionText(
            text: 'Interests',
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),

          const SizedBox(height: 16.0),

          // 관심사 영역
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                3,
                (index) => Container(
                  margin: const EdgeInsets.only(right: 12.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 3.0),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(width: 1, color: Colors.white),
                    ),
                    color: Colors.white,
                  ),
                  child: Container(
                    width: 40,
                    height: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
