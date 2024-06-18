// 리더보드(랭킹) 화면
import 'package:fluent/models/user.dart';
import 'package:fluent/provider/leaderboard_provider.dart';
import 'package:fluent/provider/user_provider.dart';
import 'package:fluent/widgets/profile_image.dart';
import 'package:fluent/widgets/text.dart';
import 'package:fluent/widgets/waveform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  List<UserModel> _pickedData = [];
  String _selectedTier = '';

  @override
  Widget build(BuildContext context) {
    // 리더보드 데이터 가져오기
    final userData = ref.read(userModelProvider);
    final data = ref.watch(leaderboardTierProvider(userData.tier));

    if (data.isEmpty) {
      return Scaffold(
        body: Center(
          child: waveForm(),
        ),
      );
    } else {
      if (_selectedTier == '') {
        setState(() {
          _selectedTier = userData.tier;
        });

        if (_pickedData.isEmpty) {
          setState(() {
            _pickedData = data..sort((a, b) => b.exp - a.exp);
          });
        }
      }


      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.blueAccent.withOpacity(0.5),
          body: Column(
            children: [
              // 상단 랭크 목록 뷰 (가로 스크롤)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueAccent,
                      Colors.blueAccent.withOpacity(0.8)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.blueAccent,
                      offset: Offset(0, 1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 12.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      tierIcon(const Color(0xFFB05656), 'bronze'),
                      tierIcon(const Color(0xFFCBCBCB), 'silver'),
                      tierIcon(const Color(0xFFFFC107), 'gold'),
                      tierIcon(const Color(0xFFE3EDFF), 'diamond'),
                      tierIcon(const Color(0xFFFF63E6), 'master'),
                    ],
                  ),
                ),
              ),

              // 하단 리스트 뷰 (세로 스크롤)
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 12.0, bottom: 28.0),
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: Colors.white.withOpacity(0.8),
                  ),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return tierCard(_pickedData[index], index + 1);
                    },
                    itemCount: _pickedData.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget tierIcon(Color color, String tier) {
    // ignore: avoid_unnecessary_containers
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // 랭크 아이콘 클릭 시, 해당 데이터 가져오기
            setState(() {
              _selectedTier = tier;
              _pickedData = ref.read(leaderboardTierProvider(tier));
            });
          },
          child: Container(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(360.0),
              ),
              color: color.withOpacity(tier == _selectedTier ? 0.8 : 0.4),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            padding: const EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width /
                (tier == _selectedTier ? 5 : 6),
            height: MediaQuery.of(context).size.width /
                (tier == _selectedTier ? 5 : 6),
            child: Image.asset('assets/images/tiers/$tier.png',
                scale: tier == _selectedTier ? 20 : 25),
          ),
        ),
        const SizedBox(height: 3.0),
        SectionText(
          text: tier,
          color: Colors.white,
          fontWeight: tier == _selectedTier ? FontWeight.bold : FontWeight.w500,
          fontSize: 14.0,
        ),
      ],
    );
  }

  // Widget _buildshimmerCard() {
  //   return Shimmer.fromColors(
  //     baseColor: Colors.grey[300]!,
  //     highlightColor: Colors.grey[100]!,
  //     child: ListView.builder(
  //       physics: const NeverScrollableScrollPhysics(),
  //       itemBuilder: (context, index) {
  //         return tierCard(UserModel.empty());
  //       },
  //       itemCount: 10,
  //     ),
  //   );
  // }

  // 사용자 랭크 목록 개별 요소
  Widget tierCard(UserModel userModel, int rank) {
    final userData = ref.read(userModelProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 3.0),
      padding: const EdgeInsets.all(16.0),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: userModel.nickName == userData.nickName
            ? Colors.blueAccent.withOpacity(0.8)
            : Colors.white.withOpacity(0.15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // 순위
              Container(
                alignment: Alignment.center,
                width: 35.0,
                child: SectionText(
                  text: rank.toString(),
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: userModel.nickName == userData.nickName
                      ? Colors.white
                      : Colors.black54,
                ),
              ),
              const SizedBox(width: 8.0),

              ProfileImage(size: 40),

              const SizedBox(width: 16.0),

              SectionText(
                text: userModel.nickName,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: userModel.nickName == userData.nickName
                    ? Colors.white
                    : Colors.black54,
              ),
            ],
          ),
          SectionText(
            text: '${userModel.exp.toString()} XP',
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: userModel.nickName == userData.nickName
                ? Colors.white
                : Colors.black54,
          ),
        ],
      ),
    );
  }
}
