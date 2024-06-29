import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NickNameTextFormField extends StatefulWidget {
  String? userNickName; // 사용자가 설정한 닉네임 - String? : 존재하지 않을 수 있음
  final GlobalKey<FormState>? formKey; // TextFormField 상태 관리 키
  final TextEditingController controller; // 컨트롤러
  NickNameTextFormField({super.key, this.userNickName, required this.formKey, required this.controller});

  @override
  State<NickNameTextFormField> createState() => _NickNameTextFormFieldState();
}

class _NickNameTextFormFieldState extends State<NickNameTextFormField> {
  late TextEditingController _controller;
  late bool canEdit; // 닉네임 수정 가능 여부

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;

    if (widget.userNickName != null) {
      _controller.text = widget.userNickName!;
      canEdit = false;
    }
    else {
      canEdit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus(); // TextField 외 영역 클릭 시 키보드 내림
      },
      child: Form(
        key: widget.formKey, // Form key 설정
        child: TextFormField(
          controller: _controller,
          maxLength: 9, // 최대 글자수
          maxLengthEnforcement: MaxLengthEnforcement.enforced, // 입력 글자수 강제
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'\s')), // 띄어쓰기 필터링
          ],
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
            letterSpacing: 1,
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            counterText: '', // 하단 카운터 표시 제거
            filled: true,
            fillColor: Colors.white.withOpacity(0.7),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            errorStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 11.0,
            ),
            errorMaxLines: 1,
          ),
          onTap: () {
            setState(() {
              canEdit = true;
            });
          },
          validator: (value) {
            if (value == null || value.length < 2 || value.length > 9) {
              return '2~9 글자로 닉네임을 설정해주세요.';
            }

            // 자음 또는 모음만 반화
            if (RegExp(r'[ㄱ-ㅎㅏ-ㅣ]').hasMatch(value)) {
              return '닉네임으로 설정할 수 없습니다.';
            }

            return null;
          },
          onFieldSubmitted: (value) {
            // 입력이 유효한 경우에만 TextFormField 비활성화 및 키보드 내림
            if (widget.formKey?.currentState?.validate() ?? false) {
              setState(() {
                canEdit = false;
                FocusScope.of(context).unfocus();
              });
            }
          },
          autovalidateMode: AutovalidateMode.onUserInteraction, // 사용자 입력 시 유효성 검사
        ),
      ),
    );
  }
}
