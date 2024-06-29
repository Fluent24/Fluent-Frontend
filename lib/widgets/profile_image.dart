import 'dart:io';

import 'package:fluent/common/utils/image_util.dart';
import 'package:fluent/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// 사진 프로필 - 이미지 url 또는 캐싱으로 받은 이미지 표시
Widget _customProfile({required double size, required File image}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(360),
    child: SizedBox(
      width: size,
      height: size,
      child: Image.file(
        image,
        fit: BoxFit.cover,
      ),
    ),
  );
}

/// 기본 프로필 위젯
Widget _defaultProfile({required double size}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(360),
    child: Stack(
      children: [
        Container(
          width: size,
          height: size,
          color: Colors.blueGrey.withOpacity(0.7),
        ),
        Positioned.fill(
          bottom: -3,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FaIcon(
              FontAwesomeIcons.solidUser,
              size: size * 0.75,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    ),
  );
}

/// 사용자 프로필 이미지 위젯
class ProfileImage extends StatefulWidget {
  final double size;
  final bool canEdit;
  File? image;
  ProfileImage({
    super.key,
    required this.size,
    this.canEdit = false,
    this.image,
  });

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  final ImageManager _imageManager = ImageManager();
  final String profileCacheKey = 'tempImageUrl';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 카메라, 갤러리에서 사용자 프로필 화면으로 설정할 이미지 가져오는 로직
      onTap: () => widget.canEdit ? showBottomSheetAboutImage.call() : null,
      child: Container(
        constraints:
            BoxConstraints(maxHeight: widget.size, maxWidth: widget.size),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(70),
          ),
          color: Colors.white,
          shadows: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.5),
              offset: const Offset(0, 1),
              spreadRadius: 0,
              blurRadius: 5,
            )
          ],
        ),
        child: widget.image != null
            ? _customProfile(size: widget.size, image: widget.image!)
            : _defaultProfile(size: widget.size),
      ),
    );
  }

  /// 프로필 이미지 설정 하단 시트 출력 함수
  void showBottomSheetAboutImage() {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: widget.image == null
                  ? 170
                  : 220, // 기본 이미지인 경우, 기본 이미지 설정 메뉴 필요 없음
              margin: const EdgeInsets.symmetric(horizontal: 32.0),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SectionText(
                      text: '프로필 사진 설정',
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                  const SizedBox(height: 12),

                  // 사진 촬영 버튼
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      onPressed: () async {
                        // 사진 촬영
                        // 기존 팝업(Modal Bottom Sheet) 종료
                        Navigator.pop(context);
                        // 사진 촬영하여 이미지 가져오기
                        File? img = await _imageManager.getCameraImage();
                        setState(() async {
                          widget.image = img;

                          // 이미지가 선택된 경우 이미지 경로 캐시에 저장
                          if (img != null) {
                            ImageManager.setCacheImage(profileCacheKey, img.path);
                          }
                        });
                      },
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.white),
                      child: SectionText(
                        text: '사진 촬영',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  // 앨범에서 사진 선택
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      onPressed: () async {
                        // 앨범에서 사진 선택
                        // 기존 팝업(Modal Bottom Sheet) 종료
                        Navigator.pop(context);
                        // 갤러리에서 이미지 가져오기
                        File? img = await _imageManager.getGalleryImage();
                        setState(() {
                          widget.image = img;
                          // 이미지가 선택된 경우 이미지 경로 캐시에 저장
                          if (img != null) {
                            ImageManager.setCacheImage(profileCacheKey, img.path);
                          }
                        });
                      },
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.white),
                      child: SectionText(
                        text: '앨범에서 사진 선택',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  // 기본 이미지 설정
                  // 기본 이미지인 경우, 기본 이미지 설정 메뉴 필요 없음
                  if (widget.image != null)
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                        onPressed: () {
                          // 기본 이미지로 변경
                          // 기존 팝업(Modal Bottom Sheet) 종료
                          Navigator.pop(context);
                          // 프로필 이미지 삭제
                          setState(() {
                            widget.image = null;
                            // 이미지 경로 캐시에서 삭제
                            ImageManager.deleteCacheImage(profileCacheKey);
                          });
                        },
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.white),
                        child: SectionText(
                          text: '기본 프로필 설정',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        });
  }
}
