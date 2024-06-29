import 'package:flutter/material.dart';

class SectionText extends StatelessWidget {
  final String text;
  Color? color;
  double? fontSize;
  FontWeight? fontWeight;
  FontStyle? fontStyle;

  SectionText({super.key, required this.text, this.color, this.fontSize, this.fontWeight, this.fontStyle});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color ?? Colors.black,
        fontFamily: 'Poppins',
        fontSize: fontSize ?? 16,
        fontWeight: fontWeight ?? FontWeight.w500,
        fontStyle: fontStyle ?? FontStyle.normal,
      ),
    );
  }
}
