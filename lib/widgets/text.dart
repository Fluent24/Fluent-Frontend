import 'package:flutter/material.dart';

class SectionText extends StatelessWidget {
  final String text;
  Color? color;
  double? fontSize;
  FontWeight? fontWeight;

  SectionText({super.key, required this.text, this.color, this.fontSize, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color ?? Colors.black,
        fontFamily: 'Poppins',
        fontSize: fontSize ?? 16,
        fontWeight: fontWeight ?? FontWeight.w500,
      ),
    );
  }
}
