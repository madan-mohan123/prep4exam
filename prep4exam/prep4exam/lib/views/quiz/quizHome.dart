import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prep4exam/services/database.dart';
import 'package:prep4exam/views/quiz/currentJoinedUsers.dart';
import 'package:prep4exam/views/quiz/showresult.dart';
import 'package:prep4exam/widgets/widgets.dart';
import 'package:prep4exam/views/quiz/createquiz.dart';
import 'package:prep4exam/views/quiz/play_quiz.dart';
import 'package:prep4exam/services/auth.dart';
import 'package:prep4exam/helper/dialogAlert.dart';
import 'dart:math';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

String useremail = "";

class _HomeState extends State<Home> {
  //create strem for accessing database
  Stream quizStream;
  List quizJoinId;
  DatabaseService databaseService = new DatabaseService();
  AuthServices authServices = new AuthServices();

  String marks = "";
  @override
  void initState() {
    //set current user email
    authServices.getcurrentuser().then((value) {
      setState(() {
        useremail = value;
      });
    });

    //return quizez that is created
    databaseService.getQuizezDataCreateBy().then((val) {
      setState(() {
        quizStream = val;
      });
    });

    //return list of join quizid
    databaseService.getQuizezData().then((val) {
      setState(() {
        quizJoinId = val;
      });
    });

    super.initState();
  }

  String joinquizId;

  showAlertDialogForInvalidQuizId(BuildContext context, String msg) {
    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Sorry", style: TextStyle(fontSize: 20.0, color: Colors.red)),
      content: Text(msg),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  ShowAlertDialogs showAlertDialogs = new ShowAlertDialogs();
  _showDialogForEnterQuizId() {
    showDialog<String>(
        context: context,
        builder: (context) {
          return new AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: 'Enter quiz Id', hintText: 'eg. xxxxx'),
                    onChanged: (val) {
                      joinquizId = val;
                    },
                  ),
                )
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('Ok'),
                  onPressed: () async {
                    try {
                      var x = await Firestore.instance
                          .collection("Quiz")
                          .document(joinquizId)
                          .get();

                      if (x.exists) {
                        List<String> blackl =
                            List<String>.from(x.data["blacklist"]);
                        if (blackl.contains(useremail)) {
                          showAlertDialogForInvalidQuizId(context,
                              "You are in waiting Room , Told Your Admin");
                        } else {
                          bool alreadyexist = false;
                          await Firestore.instance
                              .collection("JoinQuiz")
                              .where("email", isEqualTo: useremail)
                              .where("quizId", isEqualTo: joinquizId)
                              .getDocuments()
                              .then((value) {
                            value.documents.forEach((documentSnapshot) {
                              if (documentSnapshot.exists) {
                                alreadyexist = true;
                              }
                            });
                          });
                          if (!alreadyexist) {
                            DateTime currentTime = DateTime.now();
                            String cdt = currentTime.day.toString() + " : " +
                                currentTime.month.toString() + " : " +
                                currentTime.year.toString();
                            Map<String, dynamic> data = {
                              "quizId": joinquizId,
                              "email": useremail,
                              "score": 0,
                              "total": 0,
                              "attempt": "",
                              "date": cdt
                            };
                           await databaseService.joinQuiz(data, joinquizId);

                           await showAlertDialogs.showAlertDialog(
                                context, "You Have Successfully Joined");
                            Navigator.pop(context);
                          } else {
                            showAlertDialogForInvalidQuizId(
                                context, "Already Join");
                          }
                        }
                      } else {
                        // print("===================");
                        showAlertDialogForInvalidQuizId(
                            context, "Invalid Quiz Id");
                        //  Navigator.pop(context);

                      }
                    } catch (e) {
                      print(e.toString());
                      showAlertDialogForInvalidQuizId(
                          context, "Slow connection");
                    }
                  })
            ],
          );
        });
  }

  String _selectquizcretedorjoin = "MyQuizez";
  void handleClick(String value) {
    switch (value) {
      case 'Assigned':
        setState(() {
          _selectquizcretedorjoin = "Assigned";
        });

        break;
      case 'MyQuizez':
        setState(() {
          _selectquizcretedorjoin = "MyQuizez";
        });

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: appBar(context),
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          brightness: Brightness.light,
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    _showDialogForEnterQuizId();
                  },
                  child: Icon(Icons.add_box_rounded),
                )),
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'Assigned', 'MyQuizez'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ]),
      body: (_selectquizcretedorjoin == "MyQuizez")
          ? createdQuizlist()
          : assignedQuizlist(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateQuiz()));
        },
      ),
    );
  }

  Widget createdQuizlist() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.0),
      child: StreamBuilder(
        stream: quizStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container(
                  child: Center(child: CircularProgressIndicator()),
                )
              : ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    try {
                      List<String> l = [];
                      l = List<String>.from(
                          snapshot.data.documents[index].data["blacklist"]);

                      if (snapshot.data.documents[index].data["email"] ==
                          useremail) {
                        return QuizTileAdmin(
                            title: snapshot
                                .data.documents[index].data["quizTitle"],
                            desc: snapshot
                                .data.documents[index].data["quizDescription"],
                            quizId:
                                snapshot.data.documents[index].data["quizId"],
                            blacklist: l,
                            date: snapshot.data.documents[index].data["date"],
                            flag: snapshot.data.documents[index].data["flag"]);
                      } else {
                        return Container();
                      }
                    } catch (e) {
                      return Container();
                    }
                  },
                );
        },
      ),
    );
  }

  Widget assignedQuizlist() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.0),
      child: StreamBuilder(
        stream: quizStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container(
                  child: Center(child: CircularProgressIndicator()),
                )
              : ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    try {
                      if (quizJoinId.contains(snapshot
                          .data.documents[index].data["quizId"]
                          .toString())) {
                        return Scores(
                          title:
                              snapshot.data.documents[index].data["quizTitle"],
                          desc: snapshot
                              .data.documents[index].data["quizDescription"],
                          quizId: snapshot.data.documents[index].data["quizId"],
                          flag: snapshot.data.documents[index].data["flag"],
                          date: snapshot.data.documents[index].data["date"],
                        );
                      } else {
                        return Container();
                      }
                    } catch (e) {
                      return Container();
                    }
                  },
                );
        },
      ),
    );
  }
}

class Scores extends StatefulWidget {
  // final String imgUrl;
  final String title;
  final String desc;
  final String quizId;
  final bool flag;
  final String date;

  Scores(
      {@required this.title,
      @required this.desc,
      @required this.quizId,
      @required this.flag,
      this.date});

  @override
  _ScoresState createState() => _ScoresState();
}

class _ScoresState extends State<Scores> {
  String scores = "0";
  DatabaseService databaseService = new DatabaseService();
  int stopwatchmin = 0;
  @override
  void initState() {
    databaseService.getquizMarks(widget.quizId).then((value) {
      setState(() {
        scores = value;
      });
    });

    databaseService.gettime(widget.quizId).then((value) {
      setState(() {
        stopwatchmin = int.parse(value.toString());
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return QuizTileJoin(
        title: widget.title,
        desc: widget.desc,
        quizId: widget.quizId,
        flag: widget.flag,
        score: scores,
        time: stopwatchmin,
        date: widget.date);
  }
}

class QuizTileJoin extends StatefulWidget {
  final String title;
  final String desc;
  final String quizId;
  final String score;
  final bool flag;
  final int time;
  final String date;

  QuizTileJoin(
      {@required this.title,
      @required this.desc,
      @required this.quizId,
      @required this.score,
      @required this.flag,
      @required this.time,
      this.date});
  @override
  _QuizTileJoinState createState() => _QuizTileJoinState();
}

class _QuizTileJoinState extends State<QuizTileJoin> {
  DatabaseService databaseService = new DatabaseService();

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(""),
      content: Text("Quiz is not start yet by admin"),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    try {
      return GestureDetector(
        onTap: () {
          if (widget.flag) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PlayQuiz(quizId: widget.quizId, time: widget.time)));
          } else {
            showAlertDialog(context);
          }
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(6.0),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyan,
                      offset: const Offset(
                        0.0,
                        0.0,
                      ),
                      spreadRadius: 1.0,
                    ), //BoxShadow
                  ],
                ),
                child: Container(
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.amber[600],
                      elevation: 10,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(8),
                              child: Text(
                                "ID :  " + widget.quizId,
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(8),
                              child: Text(
                                widget.title,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(8),
                              child: Text(
                                widget.desc,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(8, 8, 4, 8)  ,
                              child: Text(
                                "Score: " + widget.score + "  Date: ${widget.date}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              )
            ],
          ),
        ),
      );
    } catch (e) {
      return Container(child: CircularProgressIndicator());
    }
  }
}

class QuizTileAdmin extends StatefulWidget {
  // final String imgUrl;
  final String title;
  final String desc;
  final String quizId;
  final List<String> blacklist;
  final String date;
  final bool flag;

  QuizTileAdmin(
      {@required this.title,
      @required this.desc,
      @required this.quizId,
      @required this.blacklist,
      this.date,
      this.flag});
  @override
  _QuizTileAdminState createState() => _QuizTileAdminState();
}

class _QuizTileAdminState extends State<QuizTileAdmin> {
  ShowAlertDialogs showAlertDialogs = new ShowAlertDialogs();

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed: () async {
        await Firestore.instance
            .collection("Quiz")
            .document(widget.quizId)
            .delete();

        await showAlertDialogs.showAlertDialog(
            context, "Quiz Successfully Deleted");
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Would you like to Delete this quiz"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Color color;
  static final _rng = Random();
  @override
  void initState() {
    setState(() {
      color = Color.fromARGB(
        _rng.nextInt(200),
        _rng.nextInt(200),
        _rng.nextInt(200),
        _rng.nextInt(200),
      );

      _isswitched = widget.flag;
    });
    super.initState();
  }

  bool _isswitched = false;
  @override
  Widget build(BuildContext context) {
    try {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CurrentlyJoinedStatus(widget.quizId, widget.blacklist)));
        },
        onLongPress: () {
          showAlertDialog(context);
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
          // height: 150,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(6.0),
                decoration: new BoxDecoration(
                  color: Colors.orange[600],
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amberAccent,
                      offset: const Offset(
                        0.0,
                        0.0,
                      ),
                      blurRadius: 0.0,
                      spreadRadius: 1.0,
                    ), //BoxShadow
                    //                     //BoxShadow
                  ],
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ID :  " + widget.quizId,
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      widget.title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        ButtonBar(
                          children: [
                            Switch(
                              value: _isswitched,
                              activeColor: Colors.blue,
                              onChanged: (value) async {
                                setState(() {
                                  _isswitched = value;
                                });
                                await Firestore.instance
                                    .collection("Quiz")
                                    .document(widget.quizId)
                                    .updateData(
                                        {"flag": _isswitched}).catchError((e) {
                                  print(e.toString());
                                });
                              },
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              child: OutlineButton(
                                color: Colors.redAccent,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ShowResult(widget.quizId)));
                                },
                                child: Text(
                                  "Result",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Text(widget.date,
                                style: TextStyle(color: Colors.white)),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    } catch (e) {
      return Container(
        child: Center(
          child: Text("No"),
        ),
      );
    }
  }
}
