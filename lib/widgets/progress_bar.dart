import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProgressBar extends StatefulWidget {
  double percent;
  Color barColor;

  ProgressBar({super.key, required this.percent, required this.barColor});

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: FractionalOffset(widget.percent, 1 - widget.percent),
          child: FractionallySizedBox(
            child: Image.asset(
              'assets/images/walking.png',
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(height: 2),

        LinearPercentIndicator(
          padding: EdgeInsets.zero,
          percent: widget.percent,
          lineHeight: 18,
          backgroundColor: Colors.white.withOpacity(0.5),
          progressColor: widget.barColor,
          barRadius: const Radius.circular(20),
        ),

        const SizedBox(height: 5),

        Container(
          alignment: FractionalOffset(widget.percent, 1 - widget.percent),
          child: FractionallySizedBox(
            child: Text(
              '${(widget.percent * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
