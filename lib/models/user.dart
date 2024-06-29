class UserModel {
  String userName;
  String rank;
  int grade;
  String? profilePictureUrl;
  List<String> favorites;

  UserModel({
    required this.userName,
    required this.rank,
    required this.grade,
    this.profilePictureUrl,
    required this.favorites,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_name': userName,
      'rank': rank,
      'grade': grade,
      'profile_picture_url': profilePictureUrl,
      'favorites': favorites,
    };
  }

  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
      userName: json['store_name'],
      rank: json['rank'],
      grade: json['grade'],
      profilePictureUrl: json['profile_picture_url'],
      favorites: json['favorites'] as List<String>,
    );
  }
}
