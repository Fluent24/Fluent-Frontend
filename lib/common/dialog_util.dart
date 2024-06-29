import 'package:fluent/widgets/text.dart';
import 'package:flutter/material.dart';

enum Routes {
  main,
  profile,
  review,
  delete,
}

/// 확인을 위한 Dialog 창을 띄우는 함수
/// bool reverse : 확인, 취소 버튼 색상 뒤집기 (false: 취소가 메인)
/// String route : 확인 버튼 클릭 시 이동하고자 하는 위치
Future<bool?> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String subtitle,
  required Routes route,
  bool reverse = false,
}) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        content: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: ListBody(
            children: [
              SectionText(
                text: title,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 10),
              SectionText(
                text: subtitle,
                fontSize: 12,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actionsPadding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
        actions: [
          // 확인 버튼
          // Navigator.popUntil(context, (route) => route.settings.name == '/main')
          reverse
              ? subButton(
                  text: 'Confirm',
                  onPressed: () {
                    switch (route) {
                      case Routes.main:
                        Navigator.popUntil(
                            context, (route) => route.settings.name == '/main');
                        break;
                      case Routes.profile:
                        Navigator.popUntil(context,
                            (route) => route.settings.name == '/profile');
                        break;
                      case Routes.review:
                        Navigator.popAndPushNamed(context, '/learn');
                        break;
                      case Routes.delete:
                        Navigator.pop(context);
                        break;
                      default:
                        Navigator.pop(context);
                        break;
                    }
                  },
                )
              : mainButton(
                  text: 'Confirm',
                  onPressed: () {
                    switch (route) {
                      case Routes.main:
                        Navigator.popUntil(
                            context, (route) => route.settings.name == '/main');
                        break;
                      case Routes.profile:
                        Navigator.pop(context, true);
                        break;
                      case Routes.review:
                        Navigator.popAndPushNamed(context, '/learn');
                        break;
                      case Routes.delete:
                        Navigator.pop(context, true);
                        break;
                      default:
                        Navigator.pop(context, true);
                        break;
                    }
                  },
                ),

          // 취소 버튼
          reverse
              ? mainButton(
                  text: 'Cancel',
                  onPressed: () => Navigator.pop(context, false), // 반환값 : false --> 취소 버튼 클릭했음을 알려줌
                )
              : subButton(
                  text: 'Cancel',
                  onPressed: () => Navigator.pop(context, false), // 반환값 : false --> 취소 버튼 클릭했음을 알려줌
                ),
        ],
      );
    },
  );
}

TextButton mainButton({required String text, required Function onPressed}) {
  return TextButton(
    onPressed: () => onPressed.call(),
    style: TextButton.styleFrom(
      foregroundColor: Colors.blueGrey,
      backgroundColor: Colors.blueAccent.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      // 디바이스 크기에 맞게 변경하기
      minimumSize: const Size(130, 40),
    ),
    child: SectionText(
      text: text,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  );
}

TextButton subButton({required String text, required Function onPressed}) {
  return TextButton(
    // 확인 버튼 클릭 시 문제 풀기 종료 후 홈 화면으로 이동
    onPressed: () => onPressed.call(),
    style: TextButton.styleFrom(
      foregroundColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(
          width: 1,
          color: Colors.black.withOpacity(0.2),
        ),
      ),
      minimumSize: const Size(130, 40),
    ),
    child: SectionText(
      text: text,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Colors.grey,
    ),
  );
}
