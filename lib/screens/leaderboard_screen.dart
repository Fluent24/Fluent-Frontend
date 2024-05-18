// 리더보드(랭킹) 화면
import 'package:fluent/models/user.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final UserModel testUser =
      UserModel(id: 4, userName: 'sunoogy', rank: 'silver', grade: 4);

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
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            // 상단 랭크 목록 뷰 (가로 스크롤)
            Container(
              decoration: const ShapeDecoration(
                shape: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Colors.grey,
                  ),
                ),
                color: Color(0xFFF7F4E9),
              ),
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
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return rankCard(snapshot.data![index]);
                      },
                      itemCount: snapshot.data!.length,
                    );
                  }
                  else {
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
    return GestureDetector(
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
            side: BorderSide(
              width: _selectedRank == rank ? 2 : 1,
              color: _selectedRank == rank ? Colors.blue : Colors.white,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          color: color,
        ),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(vertical: 10),
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🏆',
              style: TextStyle(
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              rank,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // test용 데이터 생성 함수 --> 삭제 예정
  static List<UserModel> makeTestUser(String rank) {
    List<UserModel> temp = [];
    for (int i = 1; i <= 10; i++) {
      if (rank == 'silver' && i == 4) {
        temp.add(UserModel(id: 4, userName: 'sunoogy', rank: rank, grade: i));
        continue;
      }
      temp.add(UserModel(id: i, userName: '$rank user $i', rank: rank, grade: i));
    }

    return temp;
  }

  // 사용자 랭크 목록 개별 요소
  Widget rankCard(UserModel userModel) {
    return Container(
      margin: const EdgeInsets.all(3),
      padding: const EdgeInsets.all(15),
      color: userModel.userName == testUser.userName ? Colors.yellow.withOpacity(0.5) : Colors.grey.withOpacity(0.2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 20),
            child: Text(
              userModel.grade.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.account_circle, size: 50,),
          ),

          Text(
            userModel.userName,
            style: const TextStyle(
              fontSize: 24,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<List<UserModel>> _makeTestList(String rank) async {
    return _rankData[rank]!.toList();
  }
}
