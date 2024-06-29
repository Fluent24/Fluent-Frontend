import 'package:shared_preferences/shared_preferences.dart';

enum InfoType {
  name,
  profile,
  rank,
  favorites,
  exp,
  email,
}

class UserCacheRepository {
  // shared_preferences에 이미지 url, 닉네임, 관심사 저장

  // 캐시에 사용자 정보 저장 - 덮어쓰기
  Future<void> writeUserInfo({required InfoType type, required dynamic data}) async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    switch (type) {
      case InfoType.name:
        await prefs.setString('userName', data);
        break;
      case InfoType.profile:
        await prefs.setString('profilePictureUrl', data ?? 'null');
        break;
      case InfoType.rank:
        await prefs.setString('rank', data);
        break;
      case InfoType.favorites:
        await prefs.setStringList('favorites', data);
        break;
      case InfoType.email:
        await prefs.setString('email', data);
        break;
      case InfoType.exp:
        await prefs.setString('exp', data);
        break;
      default:
        break;
    }
  }

  Future<dynamic>? readUserInfo({required InfoType type}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic data;

    switch (type) {
      case InfoType.name:
        data = prefs.getString('userName');
        break;
      case InfoType.profile:
        data = prefs.getString('profilePictureUrl');
        break;
      case InfoType.rank:
        data = prefs.getString('rank');
        break;
      case InfoType.favorites:
        data = prefs.getStringList('favorites');
        break;
      case InfoType.email:
        data = prefs.getString('email');
        break;
      case InfoType.exp:
        data = prefs.getString('exp');
        break;
      default:
        break;
    }

    return data;
  }

  // 사용자 정보 캐시에서 삭제
  Future<void> deleteUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('userName');
    await prefs.remove('profilePictureUrl');
    await prefs.remove('rank');
    await prefs.remove('favorites');
    await prefs.remove('email');
  }
}
