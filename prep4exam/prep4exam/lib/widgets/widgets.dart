import 'package:flutter/material.dart';

Widget appBar(BuildContext context) {
  return RichText(
      text: TextSpan(style: TextStyle(fontSize: 22), children: <TextSpan>[
    TextSpan(
        text: 'Prep4',
        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54)),
    TextSpan(
        text: 'Exam',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
  ]));
}
