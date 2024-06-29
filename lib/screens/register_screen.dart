/**
    프로필 설정 화면

  */
import 'package:fluent/common/dialog_util.dart';
import 'package:fluent/models/interest.dart';
import 'package:fluent/repository/interest_repository.dart';
import 'package:fluent/widgets/profile_image.dart';
import 'package:fluent/widgets/snack_bar.dart';
import 'package:fluent/widgets/text.dart';
import 'package:fluent/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterScreen extends StatefulWidget {
  /// 사용자 프로필을 새로 생성하는지 여부
  bool isInit;
  String? email;
  RegisterScreen({super.key, this.isInit = false, this.email});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController(); // 컨트롤러
  final List<Interest> _interests = interests;
  final List<Interest> _selectedInterests = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: SectionText(
          text: widget.isInit ? 'Profile Settings' : 'Edit Profile',
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        centerTitle: true,
        leading: widget.isInit
            ? null
            : const BackButton(
                color: Colors.white,
              ),
        automaticallyImplyLeading: widget.isInit ? false : true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6.0),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white.withOpacity(0.3),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 프로필 사진
                // null -> 기본 프로필 / 캐시에 이미지 존재 ? 캐싱 : API url
                Center(child: ProfileImage(size: 100, canEdit: true,)),
                const SizedBox(height: 20.0),

                // 닉네임
                const Text(
                  'Name',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12.0),
                NickNameTextFormField(
                  formKey: _formKey,
                  controller: controller,
                ),

                const SizedBox(height: 20.0),

                // 관심사
                const Text(
                  'Interests',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
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
                                            backgroundColor: Colors.redAccent));
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
                                Text(
                                  interest.label,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black45,
                                  ),
                                )
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
      // 저장하기 버튼
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
        ),
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        height: 50.0,
        child: TextButton(
          onPressed: () async {
            if (_formKey.currentState?.validate() ?? false) {
              if (_selectedInterests.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  CustomSnackBar(
                      text: '관심사를 선택해주세요.', backgroundColor: Colors.redAccent),
                );
              } else {
                // 닉네임 유효하고 관심사를 모두 선택한 경우 처리 로직
                bool? result = await showConfirmDialog(
                  context: context,
                  title:
                      'Would you like to change your profile?',
                  subtitle:
                      'When your interests change, the types of questions asked may change.',
                  route: Routes.profile,
                );

                // result == false --> 취소 버튼 클릭
                if (result!) {
                  // 프로필 수정 화면인 경우
                  if (!widget.isInit) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      CustomSnackBar(
                          text: '프로필이 변경되었습니다.',
                          backgroundColor: Colors.black.withOpacity(0.9)),
                    );

                    if (!mounted) return;

                    Navigator.pop(context);
                  }
                  // 프로필 설정 화면인 경우
                  else {
                    // print(widget.email);
                    // print(controller.text);
                    // print(_selectedInterests.fold("", (prov, next) => prov.toString() + next.label));

                    // 사용자 정보 캐시에 저장
                    // _userInfoRepository.writeUserInfo(type: InfoType.name, data: controller.text);
                    // _userInfoRepository.writeUserInfo(type: InfoType.rank, data: 'bronze');
                    // 프로필 이미지는 profile_image 위젯에서 함 --> 리팩터링..
                    // _userInfoRepository.writeUserInfo(type: InfoType.favorites, data: _selectedInterests.map((e) => e.label).toList());

                    // 사용자 정보 서버에 전송
                  }
                }
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar(
                    text: '프로필 설정을 완료할 수 없습니다.',
                    backgroundColor: Colors.redAccent),
              );
            }
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
          ),
          child: SectionText(
            text: '저장하기',
            color: Colors.blueAccent,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
