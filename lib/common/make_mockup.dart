import 'package:fluent/models/history.dart';
import 'package:fluent/models/user.dart';

final Map<String, List<UserModel>> mockupLeaderboard = {
  'bronze': makeTestUser('bronze'),
  'silver': makeTestUser('silver'),
  'gold': makeTestUser('gold'),
  'diamond': makeTestUser('diamond'),
  'master': makeTestUser('master'),
};

List<HistoryModel> mockupHistories = [
  HistoryModel(score: 7.41, solverDate: '2024-05-31', memberId: '', quizId: 1),
  HistoryModel(score: 8.25, solverDate: '2024-05-31', memberId: '', quizId: 2),
  HistoryModel(score: 4.25, solverDate: '2024-06-01', memberId: '', quizId: 3),
  HistoryModel(score: 6.22, solverDate: '2024-06-02', memberId: '', quizId: 4),
  HistoryModel(score: 8.71, solverDate: '2024-06-02', memberId: '', quizId: 5),
  HistoryModel(score: 5.92, solverDate: '2024-06-04', memberId: '', quizId: 6),
];

final UserModel mockupTestUser = UserModel(
  nickName: 'Soonook',
  tier: 'bronze',
  exp: 5,
  favorites: [],
  email: 'test@gmail.com',
);

// test용 데이터 생성 함수 --> 삭제 예정
List<UserModel> makeTestUser(String tier) {
  List<UserModel> temp = [];

  Map<String, List<String>> nick = {
    'bronze': ['Maestro', 'Seuong', 'TaeHyeon', 'S3KK', 'Taller'],
    'silver': ['INHA', 'KAISS', 'Doll', 'python', 'Reason'],
    'gold': ['Jana', 'youtube', 'instss', 'metabus', 'cloudcc'],
    'diamond': ['GPT', 'DALLE', 'GEMINI', 'CLAUDE', 'LLM'],
    'master': ['damdam', 'englisha', 'maner', 'cllle', 'FLower'],
  };

  for (int i = 1; i <= 5; i++) {
// UserModel을 미리 생성한 후 조건 검사
    UserModel user = UserModel(
        nickName: tier == 'bronze' && i == 5 ? 'Soonook' : nick[tier]![i - 1],
        tier: tier,
        exp: i,
        favorites: [],
        email: 'test@gmail.com');

    temp.add(user);
  }

  return temp;
}
