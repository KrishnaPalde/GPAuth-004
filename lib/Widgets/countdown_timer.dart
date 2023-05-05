import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomCountDownTimer extends StatefulWidget {
  const CustomCountDownTimer({super.key});

  @override
  State<CustomCountDownTimer> createState() => _CustomCountDownTimerState();
}

class _CustomCountDownTimerState extends State<CustomCountDownTimer> {
  @override
  Widget build(BuildContext context) {
    return CountdownTimer(
      endTime: DateTime.now().millisecondsSinceEpoch + 1000 * 30,
      onEnd: () {
        print("Completed");
        setState(() {});
      },
      widgetBuilder: (_, time) {
        if (time == null) {
          return Container();
        }
        if (time.sec.toString().length == 1) {
          return Text(
            '00:0${time.sec}',
            style: GoogleFonts.nunito(
                fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black),
          );
        }
        return Text(
          '00:${time.sec}',
          style: GoogleFonts.nunito(
              fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black),
        );
      },
    );
  }
}
