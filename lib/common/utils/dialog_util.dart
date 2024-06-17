import 'package:fluent/widgets/text.dart';
import 'package:flutter/material.dart';

enum Routes {
  main,
  profile,
  review,
  delete,
  logout
}

class DialogUtil {

  /// 확인을 위한 Dialog 창을 띄우는 함수
  /// bool reverse : 확인, 취소 버튼 색상 뒤집기 (false: 취소가 메인)
  /// String route : 확인 버튼 클릭 시 이동하고자 하는 위치
  static Future<bool?> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Routes route,
    Function()? onPopLogic,
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
            padding: const EdgeInsets.all(15.0),
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
          actionsPadding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
          actions: [
            // 확인 버튼
            // Navigator.popUntil(context, (route) => route.settings.name == '/main')
            reverse
                ? _subButton(
              text: 'Confirm',
              onPressed: () async {
                if (!Navigator.canPop(context)) {
                  // Navigator가 lock 상태인 경우 dialog를 열지 않음
                  return;
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (onPopLogic != null) {
                    onPopLogic();
                  }

                  switch (route) {
                    case Routes.main:
                      Navigator.popUntil(
                          context, (route) => route.settings.name == '/main');
                      break;
                    case Routes.profile:
                      Navigator.popUntil(
                          context, (route) => route.settings.name == '/profile');
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
                });
              },
            )
                : _mainButton(
              text: 'Confirm',
              onPressed: () async {
                if (!Navigator.canPop(context)) {
                  // Navigator가 lock 상태인 경우 dialog를 열지 않음
                  return;
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (onPopLogic != null) {
                    onPopLogic();
                  }

                  switch (route) {
                    case Routes.main:
                      Navigator.popUntil(
                          context, (route) => route.settings.name == '/main');
                      break;
                    case Routes.profile:
                      Navigator.popUntil(
                          context, (route) => route.settings.name == '/profile');
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
                });
              },
            ),

            // 취소 버튼
            reverse
                ? _mainButton(
              text: 'Cancel',
              onPressed: () => Navigator.pop(context, false), // 반환값 : false --> 취소 버튼 클릭했음을 알려줌
            )
                : _subButton(
              text: 'Cancel',
              onPressed: () => Navigator.pop(context, false), // 반환값 : false --> 취소 버튼 클릭했음을 알려줌
            ),
          ],
        );
      },
    );
  }

  static TextButton _mainButton({required String text, required Function() onPressed}) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.blueGrey,
        backgroundColor: Colors.blueAccent.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        // 디바이스 크기에 맞게 변경하기
        minimumSize: const Size(120, 40),
      ),
      child: SectionText(
        text: text,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  static TextButton _subButton({required String text, required Function() onPressed}) {
    return TextButton(
      // 확인 버튼 클릭 시 문제 풀기 종료 후 홈 화면으로 이동
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(
            width: 1,
            color: Colors.black.withOpacity(0.2),
          ),
        ),
        minimumSize: const Size(120, 40),
      ),
      child: SectionText(
        text: text,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
      ),
    );
  }
}
