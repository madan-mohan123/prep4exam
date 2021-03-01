import 'package:flutter/material.dart';
import 'package:prep4exam/helper/functions.dart';
import 'package:prep4exam/views/dashboard.dart';
import 'package:prep4exam/views/authentication/signin.dart';
// import 'package:prep4exam/views/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    checkUserLoggedInstatus();
    super.initState();
  }

  checkUserLoggedInstatus() async {
    HelperFunction.getUserLoggedInDetails().then((value) {
      setState(() {
        _isLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: (_isLoggedIn ?? false) ? Dashboard() : Signin(),
    );
  }
}
