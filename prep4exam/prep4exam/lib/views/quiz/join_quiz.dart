
import 'package:flutter/material.dart';
import 'package:prep4exam/services/database.dart';
import 'package:prep4exam/views/quiz/play_quiz.dart';
import 'package:prep4exam/widgets/widgets.dart';
import 'package:prep4exam/helper/functions.dart';
import 'package:prep4exam/services/auth.dart';
import 'package:prep4exam/models/user.dart';

class JoinQuiz extends StatefulWidget {

  
  @override
  _JoinQuizState createState() => _JoinQuizState();
}

class _JoinQuizState extends State<JoinQuiz> {

  final _formKey = GlobalKey<FormState>();
  DatabaseService databaseService = new DatabaseService();
  HelperFunction helperFunction = new HelperFunction();
  AuthServices authServices = new AuthServices();
  User user = new User();
  // bool _isLoading = false;
  String quizId;
  String _userid="";



    @override
  void initState() {
   authServices.getcurrentuser().then((value) {
        setState(() {
          _userid = value;
        });
       
      });
    super.initState();
  }

  

  joinQuizUrl() async {
    if (_formKey.currentState.validate()) {
      Map<String, dynamic> data = {
        "quizId": quizId,
        "email": _userid,
        "score": 0
      };
      await databaseService.joinQuiz(data, quizId).then((val) {
        setState(() {
          // _isLoading = false;
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => PlayQuiz(quizId)));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[300],
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.red,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black87),
        brightness: Brightness.light,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.only(top: 20.0),
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                validator: (val) => val.isEmpty ? "Enter valid QuizId" : null,
                decoration: InputDecoration(
                  hintText: "Quiz Id",
                ),
                onChanged: (val) {
                  quizId = val;
                },
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  joinQuizUrl();
                },
                child: blueButton(
                  context: context,
                  label: " Submit",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
