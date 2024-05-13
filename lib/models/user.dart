class UserModel {
  int id;
  String userName;
  String rank;
  int grade;

  UserModel({
    required this.id,
    required this.userName,
    required this.rank,
    required this.grade,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_name': userName,
      'rank': rank,
      'grade': grade,
    };
  }

  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
      id: json['id'],
      userName: json['store_name'],
      rank: json['rank'],
      grade: json['grade'],
    );
  }
}
