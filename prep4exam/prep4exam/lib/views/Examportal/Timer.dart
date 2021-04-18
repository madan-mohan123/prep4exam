import 'package:flutter/material.dart';
import 'package:prep4exam/views/Examportal/ExamDash.dart';
import 'dart:async';

class MyTimeForExam extends StatefulWidget {
  final int timeInMinutes;
  final String examId;

  MyTimeForExam(this.timeInMinutes, this.examId);
  @override
  _MyTimeForExamState createState() => _MyTimeForExamState();
}

class _MyTimeForExamState extends State<MyTimeForExam> {
  int min, sec;
  Timer _timer;

   @override
  void initState() {
    super.initState();
    setState(() {
      min = widget.timeInMinutes - 1;
      sec = 60;
      startTimer();
    });
  }

  void startTimer() async {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (sec == 0) {
          setState(() {
            sec--;
            if (min >= 1) {
              min = min - 1;
              sec = 60;
            } else {
              min = 0;
              sec = 0;
              timer.cancel();

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Examdash()));
            }
          });
        } else {
          setState(() {
            sec--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

 

  @override
  Widget build(BuildContext context) {
    try {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.alarm_on,
              color: Colors.white,
              size: 30.0,
            ),
            SizedBox(
              width: 5.0,
            ),
            RichText(
                text: TextSpan(
                    style: TextStyle(fontSize: 22),
                    children: <TextSpan>[
                  TextSpan(
                      text: min.toString().length == 2
                          ? '${min.toString()} : '
                          : '0${min.toString()} : ',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          fontSize: 20.0)),
                  TextSpan(
                      text: sec.toString().length == 2
                          ? sec.toString()
                          : '0${sec.toString()}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 20.0)),
                ])),
          ],
        ),
      );
    } catch (e) {
      return Container();
    }
  }
}