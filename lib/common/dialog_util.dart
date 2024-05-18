import 'package:flutter/material.dart';

Future<void> showConfirmDialog({required BuildContext context, required bool canSave}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        content: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: ListBody(
            children: [
              const Text(
                'Do you really want to stop learning?',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                canSave ? 'you can check your feedback at Review Page' : 'You won\'t be able to get feedback on this sentence.',
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actionsPadding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
        actions: [
          // 확인 버튼
          TextButton(
            // 확인 버튼 클릭 시 문제 풀기 종료 후 홈 화면으로 이동
            onPressed: () => Navigator.popUntil(context, (route) => route.settings.name == '/main'),
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
            child: const Text(
              'Confirm',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),

          // 취소 버튼
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.blueGrey,
              backgroundColor: Colors.blueAccent.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              // 디바이스 크기에 맞게 변경하기
              minimumSize: const Size(130, 40),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    },
  );
}