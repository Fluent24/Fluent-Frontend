import 'package:flutter/material.dart';

class FeedbackTestScreen extends StatelessWidget {
  const FeedbackTestScreen({super.key});

  final textUpper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  final textLower = 'abcdefghijklmnopqrstuvwxyz';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AlternatingTextWidget(text1: textUpper, text2: textLower),
          ],
        ),
      ),
    );
  }

  Widget AlternatingTextWidget({required String text1, required String text2}) {
    List<Widget> lines = [];

    for (int i = 0; i < text1.length; i++) {
      String char1 = text1[i];
      String char2 = i < text2.length ? text2[i] : '';

      lines.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(char1),
            Text(char2),
          ],
        ),
      );
    }

    return Column(
      children: lines,
    );
  }
}
