import 'package:flutter/material.dart';

SnackBar CustomSnackBar({ required text, required backgroundColor}) {
  return SnackBar(
    content: Text(
      text,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
      ),
    ),
    backgroundColor: backgroundColor,
    margin: const EdgeInsets.symmetric(
        horizontal: 12.0, vertical: 16.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    elevation: 0,
    behavior: SnackBarBehavior.floating, // 기본 fixed -> margin 속성 줄 수 없음
  );
}
