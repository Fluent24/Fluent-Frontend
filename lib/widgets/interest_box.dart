import 'package:flutter/material.dart';

class InterestBox extends StatefulWidget {
  String text;
  Color boxColor;
  Function? onPressed;
  bool isPressed = false;

  InterestBox({
    super.key,
    required this.text,
    required this.boxColor,
  });

  @override
  State<InterestBox> createState() => _InterestBoxState();
}

class _InterestBoxState extends State<InterestBox> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onPressed != null) {
          widget.onPressed!.call();
          setState(() {
            widget.isPressed = !(widget.isPressed);
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 3),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(width: 1, color: widget.isPressed ? Colors.transparent : widget.boxColor),
          ),
          color: widget.isPressed ? widget.boxColor : Colors.transparent,
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            // fontStyle: FontStyle.italic,
            color: widget.isPressed ? Colors.white : widget.boxColor,
          ),
        ),
      ),
    );
  }
}
