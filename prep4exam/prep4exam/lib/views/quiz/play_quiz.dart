import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prep4exam/helper/dialogAlert.dart';
import 'package:prep4exam/services/auth.dart';
import 'package:prep4exam/widgets/quiz_play_widget.dart';
import 'package:prep4exam/models/questionmodel.dart';
import 'package:prep4exam/services/database.dart';
import 'package:prep4exam/views/quiz/results.dart';
import 'dart:async';

class PlayQuiz extends StatefulWidget {
  final String quizId;
  final int time;
  PlayQuiz({this.quizId, this.time});
  @override
  _PlayQuizState createState() => _PlayQuizState();
}

int total = 0;
int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;
String _candemail = '';

class _PlayQuizState extends State<PlayQuiz> {
  DatabaseService databaseService = new DatabaseService();
  Map<String, dynamic> quizData = {};
  QuerySnapshot questionSnapshot;
  int stopwatchmin = 0;

  QuestionModel getQuestionModelFromDatasnapshot(
      DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = new QuestionModel();

    questionModel.question = questionSnapshot.data["question"];

    List<String> options = [
      questionSnapshot.data["option1"],
      questionSnapshot.data["option2"],
      questionSnapshot.data["option3"],
      questionSnapshot.data["option4"],
    ];

    options.shuffle();
    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];

    questionModel.correctOption = questionSnapshot.data["option1"];
    questionModel.answered = false;
    return questionModel;
  }

  String useremail = "";
  AuthServices authServices = new AuthServices();
  @override
  void initState() {
    authServices.getcurrentuser().then((value) {
      setState(() {
        _candemail = '';
        useremail = value;
        _candemail = value;
      });
    });

    databaseService.getQuizData(widget.quizId).then((value) {
      setState(() {
        questionSnapshot = value;
        _notAttempted = 0;
        _correct = 0;
        _incorrect = 0;
        total = questionSnapshot.documents.length;
      });
    });

    databaseService.getQuizDataById(widget.quizId).then((value) {
      setState(() {
        quizData = Map<String, dynamic>.from(value);
      });
    });
    super.initState();
  }

  ShowAlertDialogs showAlertDialogs = new ShowAlertDialogs();
  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        backgroundColor: Colors.deepPurple[50],
        appBar: AppBar(
          title: Center(
              child: MyTime(widget.time, widget.quizId, quizData["attempt"])),
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.black54),
          actions: <Widget>[],
        ),
        body: Container(
            padding: EdgeInsets.all(4.0),
            child: ListView(
              children: [
                Column(
                  children: [
                    questionSnapshot == null
                        ? Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: questionSnapshot.documents.length,
                            itemBuilder: (context, index) {
                              return QuizPlayTile(
                                questionModel: getQuestionModelFromDatasnapshot(
                                    questionSnapshot.documents[index]),
                                index: index,
                              );
                            },
                          ),
                  ],
                ),
              ],
            )),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.send_rounded),
            onPressed: () async {
              if (quizData["attempt"] == "") {
                await submitQuiz();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Results(
                              correct: _correct,
                              incorrect: _incorrect,
                              total: total,
                              quizId: widget.quizId,
                            )));
              } else {
                await showAlertDialogs.showAlertDialog(
                    context, "you have already submited it ");
              }
            }),
      );
    } catch (e) {
      return Scaffold(
        body: Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
  }

  submitQuiz() async {
    bool success = false;
    await Firestore.instance
        .collection("JoinQuiz")
        .where('quizId', isEqualTo: widget.quizId)
        .where('email', isEqualTo: useremail)
        .getDocuments()
        .then((value) {
      value.documents.forEach((documentSnapshot) {
        documentSnapshot.reference
            .updateData({"score": _correct, "total": total, "attempt": "yes"});
      });
      success = true;
    }).catchError((e) {
      showAlertDialogs.showAlertDialog(context, "Internet connection is slow");
    });
    if (success) {
      
      await showAlertDialogs.showAlertDialog(context, "Successfully submitted");
    }
  }
}

class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;

  QuizPlayTile({this.questionModel, this.index});

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Q${widget.index + 1} ${widget.questionModel.question}",
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            SizedBox(
              height: 12,
            ),
            GestureDetector(
              onTap: () {
                if (!widget.questionModel.answered) {
                  if (widget.questionModel.option1 ==
                      widget.questionModel.correctOption) {
                    optionSelected = widget.questionModel.option1;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted - 1;
                    setState(() {});
                  } else {
                    optionSelected = widget.questionModel.option1;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                    setState(() {});
                  }
                }
              },
              child: OptionTile(
                correctAnswer: widget.questionModel.correctOption,
                description: widget.questionModel.option1,
                option: "A",
                optionSelected: optionSelected,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            GestureDetector(
              onTap: () {
                if (!widget.questionModel.answered) {
                  if (widget.questionModel.option2 ==
                      widget.questionModel.correctOption) {
                    optionSelected = widget.questionModel.option2;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted - 1;
                    setState(() {});
                  } else {
                    optionSelected = widget.questionModel.option2;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                    setState(() {});
                  }
                }
              },
              child: OptionTile(
                correctAnswer: widget.questionModel.correctOption,
                description: widget.questionModel.option2,
                option: "B",
                optionSelected: optionSelected,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            GestureDetector(
              onTap: () {
                if (!widget.questionModel.answered) {
                  if (widget.questionModel.option3 ==
                      widget.questionModel.correctOption) {
                    optionSelected = widget.questionModel.option3;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted - 1;
                    setState(() {});
                  } else {
                    optionSelected = widget.questionModel.option3;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                    setState(() {});
                  }
                }
              },
              child: OptionTile(
                correctAnswer: widget.questionModel.correctOption,
                description: widget.questionModel.option3,
                option: "C",
                optionSelected: optionSelected,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            GestureDetector(
              onTap: () {
                if (!widget.questionModel.answered) {
                  if (widget.questionModel.option4 ==
                      widget.questionModel.correctOption) {
                    optionSelected = widget.questionModel.option4;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted - 1;
                    setState(() {});
                  } else {
                    optionSelected = widget.questionModel.option4;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                    setState(() {});
                  }
                }
              },
              child: OptionTile(
                correctAnswer: widget.questionModel.correctOption,
                description: widget.questionModel.option4,
                option: "D",
                optionSelected: optionSelected,
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class MyTime extends StatefulWidget {
  final int title;
  final String quizId;
  final String attempt;

  MyTime(this.title, this.quizId, this.attempt);
  @override
  _MyTimeState createState() => _MyTimeState();
}

class _MyTimeState extends State<MyTime> {
  int min, sec;
  Timer _timer;

  ShowAlertDialogs showAlertDialogs = new ShowAlertDialogs();

  submitQuiz() async {
    bool success = false;
    await Firestore.instance
        .collection("JoinQuiz")
        .where('quizId', isEqualTo: widget.quizId)
        .where('email', isEqualTo: _candemail)
        .getDocuments()
        .then((value) {
      value.documents.forEach((documentSnapshot) {
        documentSnapshot.reference
            .updateData({"score": _correct, "total": total, "attempt": "yes"});
      });
      success = true;
    }).catchError((e) {
      showAlertDialogs.showAlertDialog(context, "Internet connection is slow");
    });
    if (success) {
      await showAlertDialogs.showAlertDialog(context, "Successfully submitted");
    }
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
              if (widget.attempt != "") {
                submitQuiz();
              } else {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Results(
                              correct: _correct,
                              incorrect: _incorrect,
                              total: total,
                              quizId: widget.quizId,
                            )));
              }
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
  void initState() {
    super.initState();
    setState(() {
      min = widget.title - 1;
      sec = 60;
      startTimer();
    });
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
                          color: Colors.white,
                          fontSize: 20.0)),
                  TextSpan(
                      text: sec.toString().length == 2
                          ? sec.toString()
                          : '0${sec.toString()}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
