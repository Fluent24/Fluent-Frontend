/**
    프로필 설정 화면

  */
import 'dart:io';

import 'package:fluent/common/utils/image_util.dart';
import 'package:fluent/models/interest.dart';
import 'package:fluent/models/user.dart';
import 'package:fluent/repository/interest_repository.dart';
import 'package:fluent/repository/user_repository.dart';
import 'package:fluent/widgets/common_button.dart';
import 'package:fluent/widgets/profile_image.dart';
import 'package:fluent/widgets/snack_bar.dart';
import 'package:fluent/widgets/text.dart';
import 'package:fluent/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  /// 닉네임, 관심사 검증 폼
  final _formKey = GlobalKey<FormState>();

  /// 닉네임 필드 컨트롤러
  final TextEditingController controller = TextEditingController();

  /// 관심사 목록
  final List<Interest> _interests = interests;

  /// 사용자가 선택한 관심사 목록
  final List<Interest> _selectedInterests = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: SectionText(
          text: '프로필 설정',
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6.0),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white.withOpacity(0.35),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 프로필 사진
                Center(
                  child: ProfileImage(
                    size: 100,
                    canEdit: true,
                  ),
                ),
                const SizedBox(height: 6.0),
                Center(
                  child: SectionText(
                    text: '사진 선택',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20.0),

                // 닉네임
                SectionText(
                  text: '이름',
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 12.0),
                NickNameTextFormField(
                  formKey: _formKey,
                  controller: controller,
                ),

                const SizedBox(height: 20.0),

                // 관심사
                SectionText(
                  text: '관심사 선택 (최대 3개)',
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                  color: Colors.white,
                ),

                const SizedBox(height: 12.0),

                Container(
                  height: (_interests.length / 3).ceil() *
                      ((MediaQuery.of(context).size.width - 84.0) / 3),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(18.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: GridView.count(
                      crossAxisCount: 3, // 한 줄에 3개 배치
                      mainAxisSpacing: 5.0,
                      crossAxisSpacing: 5.0,
                      childAspectRatio: 1.0,
                      physics: const NeverScrollableScrollPhysics(),
                      children: _interests.map((interest) {
                        final isSelected =
                            _selectedInterests.contains(interest);
                        return GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                if (isSelected) {
                                  _selectedInterests.remove(interest);
                                } else {
                                  if (_selectedInterests.length < 3) {
                                    _selectedInterests.add(interest);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      CustomSnackBar(
                                        text: '관심사는 최대 3개까지 선택할 수 있습니다.',
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                  }
                                }
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blueAccent
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blueAccent
                                      : Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  interest.icon,
                                  size: 30.0,
                                  color: isSelected
                                      ? Colors.white
                                      : interest.color,
                                ),
                                const SizedBox(height: 8.0),
                                SectionText(
                                  text: interest.label,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black45,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 8.0),
              ],
            ),
          ),
        ),
      ),

      // 저장하기 버튼 - 눌렀을 때 _saveProfile 수행하도록 변경하기 + shimmer 적용하기 (circularIndicator)
      bottomNavigationBar: CommonButton(
        text: '저장하기',
        onPressed: () async {
          await _saveProfile();

          if (!mounted) return;
          Future.delayed(Duration(milliseconds: 1500),
              () => Navigator.pushReplacementNamed(context, '/main'));
        },
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedInterests.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
              text: '관심사를 선택해주세요.', backgroundColor: Colors.redAccent),
        );
      } else {
        // 닉네임 유효하고 관심사를 모두 선택한 경우
        try {
          // 캐시에 사용자 정보 저장
          // tempImageUrl --> 환경변수에 저장하기
          final SharedPreferences prefs = await SharedPreferences.getInstance();

          String? imagePath = await ImageManager.getCacheImage('tempImageUrl');
          String? email = prefs.getString('email');
          File? profileImage;

          if (imagePath != null) {
            profileImage = File(imagePath);
          }

          // 이메일은 카카오 로그인 시 캐시에 자동으로 저장됨
          if (email == null) return;

          final nickName = controller.text;
          final favorites = _selectedInterests.map((e) => e.label).toList();
          // 서버 API에 사용자 정보 전송 후 이미지 url 받아서 캐시에 저장 (S3 경로)

          final UserModel response = await ref.watch(userRepositoryProvider).registerUserInfo(
                email: email,
                name: nickName,
                favorites: favorites,
                profileImage: profileImage,
              );

          // 응답이 잘못된 경우 체크하는 로직

          // 캐시에 저장하기 - 닉네임, 관심사, 프로필 이미지
          prefs.setString('name', nickName);
          prefs.setStringList('favorites', favorites);
          // 서버에 이미지 파일을 업로드한 후 해당 경로를 캐시에 저장
          prefs.setString('profilePictureUrl', response.profilePictureUrl ?? 'null');

        } catch (error) {
          print(error);
          return;
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          text: '프로필 설정을 완료할 수 없습니다.',
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
