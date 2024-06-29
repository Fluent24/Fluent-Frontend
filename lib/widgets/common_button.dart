import 'package:fluent/widgets/text.dart';
import 'package:flutter/material.dart';

/// 공통 버튼 위젯
class CommonButton extends StatelessWidget {
  double width;
  double height;
  String text;
  Function? onPressed;
  Color color;
  Color backgroundColor;
  bool disabled;

  CommonButton({
    super.key,
    this.width = double.infinity,
    this.height = 50.0,
    this.text = 'red',
    this.onPressed,
    this.color = Colors.blueAccent,
    this.backgroundColor = Colors.white,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: disabled ? Colors.grey : backgroundColor,
      ),
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: TextButton(
        onPressed: () => onPressed != null ? onPressed!.call() : '',
        style: TextButton.styleFrom(
          backgroundColor: disabled ? Colors.grey : backgroundColor,
          foregroundColor: disabled ? Colors.grey : backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: SectionText(
          text: text,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
