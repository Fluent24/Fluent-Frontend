// 리더보드(랭킹) 화면
import 'package:fluent/models/user.dart';
import 'package:fluent/widgets/profile_image.dart';
import 'package:fluent/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final UserModel testUser =
      UserModel(id: 4, userName: 'sunoogy', rank: 'silver', grade: 4, favorites: []);

  final Map<String, List<UserModel>> _rankData = {
    'bronze': makeTestUser('bronze'),
    'silver': makeTestUser('silver'),
    'gold': makeTestUser('gold'),
    'diamond': makeTestUser('diamond'),
    'master': makeTestUser('master'),
  };

  late Future<List<UserModel>> _lstUser;
  late String _selectedRank;

  @override
  void initState() {
    // _lstUser 변화 -> ListView에 반영되려면 Future<List<UserModel>> 형식으로 줘야 함
    _lstUser = _makeTestList(testUser.rank);
    _selectedRank = testUser.rank;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  colors: [Colors.blueAccent, Colors.blueAccent.withOpacity(0.8)],
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    rankIcon(const Color(0xFFB05656), 'bronze'),
                    rankIcon(const Color(0xFFCBCBCB), 'silver'),
                    rankIcon(const Color(0xFFFFC107), 'gold'),
                    rankIcon(const Color(0xFFE3EDFF), 'diamond'),
                    rankIcon(const Color(0xFFFF63E6), 'master'),
                  ],
                ),
              ),
            ),

            // 하단 리스트 뷰 (세로 스크롤)
            Expanded(
              // _lstUser 변화하면 위젯 리로딩
              child: FutureBuilder<List<UserModel>>(
                future: _lstUser,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0, bottom: 28.0),
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: Colors.white.withOpacity(0.8),
                      ),
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return rankCard(snapshot.data![index]);
                        },
                        itemCount: snapshot.data!.length,
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rankIcon(Color color, String rank) {
    // ignore: avoid_unnecessary_containers
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // 랭크 아이콘 클릭 시, 해당 데이터 가져오기
            setState(() {
              _lstUser = _makeTestList(rank);
              _selectedRank = rank;
            });
          },
          child: Container(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(360.0),
              ),
              color: color.withOpacity(rank == _selectedRank ? 0.8 : 0.4),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            padding: const EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width /
                (rank == _selectedRank ? 5 : 6),
            height: MediaQuery.of(context).size.width /
                (rank == _selectedRank ? 5 : 6),
            child: Image.asset('assets/images/ranks/$rank.png',
                scale: rank == _selectedRank ? 20 : 25),
          ),
        ),
        const SizedBox(height: 3.0),
        SectionText(
          text: rank,
          color: Colors.white,
          fontWeight: rank == _selectedRank ? FontWeight.bold : FontWeight.w500,
          fontSize: 14.0,
        ),
      ],
    );
  }

  // test용 데이터 생성 함수 --> 삭제 예정
  static List<UserModel> makeTestUser(String rank) {
    List<UserModel> temp = [];
    for (int i = 1; i <= 10; i++) {
      if (rank == 'silver' && i == 4) {
        temp.add(UserModel(id: 4, userName: 'sunoogy', rank: rank, grade: i, favorites: []));
        continue;
      }
      temp.add(
          UserModel(id: i, userName: '$rank user $i', rank: rank, grade: i, favorites: []));
    }

    return temp;
  }

  // 사용자 랭크 목록 개별 요소
  Widget rankCard(UserModel userModel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 3.0),
      padding: const EdgeInsets.all(16.0),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: userModel.userName == testUser.userName
            ? Colors.blueAccent.withOpacity(0.8)
            : Colors.white.withOpacity(0.15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 순위
          Container(
            alignment: Alignment.center,
            width: 35.0,
            child: SectionText(
              text: userModel.grade.toString(),
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: userModel.userName == testUser.userName ? Colors.white : Colors.black54,
            ),
          ),
          const SizedBox(width: 8.0),

          ProfileImage(size: 40),

          const SizedBox(width: 16.0),

          SectionText(
            text: userModel.userName,
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            color: userModel.userName == testUser.userName ? Colors.white : Colors.black54,
          ),
        ],
      ),
    );
  }

  Future<List<UserModel>> _makeTestList(String rank) async {
    return _rankData[rank]!.toList();
  }
}
