import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 카메라로 사진 촬영 혹은 갤러리에서 이미지를 가져오는 클래스
class ImageManager {
  Future<File?> getCameraImage() async {
    // 기본 카메라 앱 이용하여 사진 촬영하여 image 변수에 등록

    var image = await ImagePicker().pickImage(source: ImageSource.camera);

    // 사진 촬영을 완료한 경우에만 이미지 반환
    if (image != null) {
      return File(image.path); // 이미지 경로를 File에 감싸준다.
    }
    else {
      return null;
    }
  }

  /// 갤러리에서 이미지 파일을 가져오는 함수
  Future<File?> getGalleryImage() async {
    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      /// 이미지 압축, Max: 100 - 초고화질. 서버에 올리는 용량도 고려해야 함
      imageQuality: 10,
    );
    // 압축률 높을 수록 업로드, 다운로드 속도도 빠름

    if (image != null) {
      return File(image.path); // 이미지 경로를 File에 감싸준다.
    }

    return null;
  }

  /// 캐시에 있는 이미지 경로를 가져오는 함수
  static Future<String?> getCacheImage(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? imagePath = prefs.getString(key);

    return imagePath;
  }

  /// 이미지 경로를 캐시에 저장하는 함수
  static Future<void> setCacheImage(String key, String imagePath) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, imagePath);
  }

  /// 캐시에서 이미지 경로 삭제
  static Future<void> deleteCacheImage(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}