import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prep4exam/helper/dialogAlert.dart';
import 'package:prep4exam/services/database.dart';
// import 'package:prep4exam/widgets/widgets.dart';

class CurrentlyJoinedStatus extends StatefulWidget {
  final String quizId;
  final List<String> blacklist;
  CurrentlyJoinedStatus(this.quizId, this.blacklist);
  @override
  _CurrentlyJoinedStatusState createState() => _CurrentlyJoinedStatusState();
}

class _CurrentlyJoinedStatusState extends State<CurrentlyJoinedStatus> {
  DatabaseService databaseService = new DatabaseService();
  Stream currentuser;
  List<String> blacklistStudent = [];

  List<Map<String, String>> listOfJoinedUsers;
  String participants = "Participants";

  @override
  void initState() {
    databaseService.getCurrentlyJoinedUser(widget.quizId).then((value) {
      setState(() {
        currentuser = value;
        blacklistStudent = widget.blacklist;
        print("+++++++");
        print(widget.blacklist);
      });
    });

    super.initState();
  }

  watingRoom(String blacklist) {
    switch (blacklist) {
      case 'WaitingRoom':
        setState(() {
          participants = "WaitingRoom";
        });

        break;
      case 'Participants':
        setState(() {
          participants = "Participants";
        });

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
          title: participants == "Participants"?Text('Current User'):Text('Waiting Room'),
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          brightness: Brightness.light,
          actions: [
            PopupMenuButton<String>(
              onSelected: watingRoom,
              itemBuilder: (BuildContext context) {
                return {'WaitingRoom', 'Participants'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ]),
      body: participants == "Participants"
          ? StreamBuilder(
              stream: currentuser,
              builder: (context, snapshot) {
                return snapshot.data == null
                    ? Container(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          try {
                            return joinedUserTile(
                                snapshot.data.documents[index].data["email"]
                                    .toString(),
                                snapshot.data.documents[index].data["score"]
                                    .toString()
                                    .toUpperCase());
                          } catch (e) {
                            return Container();
                          }
                        });
              })
          : blacklistStudent.isEmpty ?  Container(
                    child: Center(
                      child: Container(
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 2.0),
        padding: EdgeInsets.all(2.0),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.shade50,
              offset: const Offset(
                1.0,
                1.0,
              ),
              blurRadius: 0.0,
              spreadRadius: 1.0,
            ), //BoxShadow
            //                     //BoxShadow
          ],
        ),

        child: Container(
          padding: EdgeInsets.all(10.0),
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                   

                    child:Text("None in Black List",style:TextStyle(fontSize: 20.0))
                    ),
                  )))):
                   ListView.builder(
              shrinkWrap: true,
              itemCount: blacklistStudent.length,
              itemBuilder: (context, index) {
                
                  return blackListTile(blacklistStudent[index]);
                
              }),
    );
  }

  Widget blackListTile(String blacklistEmail) {
    return GestureDetector(
        onTap: () {
          removeFromBlackList(context, blacklistEmail);
        },
         child: Container(
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 2.0),
        padding: EdgeInsets.all(2.0),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.shade50,
              offset: const Offset(
                1.0,
                1.0,
              ),
              blurRadius: 0.0,
              spreadRadius: 1.0,
            ), //BoxShadow
            //                     //BoxShadow
          ],
        ),

        child: Container(
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.indigo[300],
                    elevation: 10,
        
          child: ListTile(
            leading: Icon(
              Icons.keyboard_arrow_right_outlined,
              size: 30.0,
              color: Colors.red,
            
            ),
            title: Text(
              blacklistEmail,
              style: TextStyle(fontSize: 20.0),
            ))
        ))));
  }

  removeFromBlackList(BuildContext context, String blacklistEmail) {
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
        setState(() {
          blacklistStudent.remove(blacklistEmail);
        });
        await Firestore.instance
            .collection("Quiz")
            .where('quizId', isEqualTo: widget.quizId)
            .getDocuments()
            .then((value) {
          value.documents.forEach((documentSnapshot) {
            documentSnapshot.reference
                .updateData({"blacklist": blacklistStudent});
          });
          showAlertDialogs.showAlertDialog(context, "Successfully Removed");
        }).catchError((e) {
          showAlertDialogs.showAlertDialog(context, "Slow Internet connection");
        });

        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Would you like to Remove this Participant from BlackList"),
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

  Widget joinedUserTile(String userEmail, String score) {
    return GestureDetector(
        onLongPress: () {
          showAlertDialog(context, userEmail);
        },
       child: Container(
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 2.0),
        padding: EdgeInsets.all(2.0),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.shade50,
              offset: const Offset(
                1.0,
                1.0,
              ),
              blurRadius: 0.0,
              spreadRadius: 1.0,
            ), //BoxShadow
            //                     //BoxShadow
          ],
        ),

        child: Container(
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.indigo[300],
                    elevation: 10,
        child:ListTile(
              leading: Icon(
                Icons.map_rounded,
                color: Colors.orangeAccent,
                size:30.0
              ),
              
              title: Text(
                userEmail,
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              subtitle: RichText(
                  text: TextSpan(
                      style: TextStyle(fontSize: 22),
                      children: <TextSpan>[
                    TextSpan(
                        text: 'Score ',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white)),
                    TextSpan(text: score, style: TextStyle(color: Colors.grey)),
                  ])),
            ))
            ))
           
            );
  }

  ShowAlertDialogs showAlertDialogs = new ShowAlertDialogs();

  showAlertDialog(BuildContext context, String userEmail) {
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
            .collection("JoinQuiz")
            .where('quizId', isEqualTo: widget.quizId)
            .where('email', isEqualTo: userEmail)
            .getDocuments()
            .then((value) {
          value.documents.forEach((documentSnapshot) {
            documentSnapshot.reference.delete();
            setState(() {
              blacklistStudent.add(userEmail);
            });
          });
        }).catchError((e) {
          showAlertDialogs.showAlertDialog(context, "Slow Internet connection");
        });
        await Firestore.instance
            .collection("Quiz")
            .document(widget.quizId)
            .updateData({"blacklist": blacklistStudent})
            .then((value) {})
            .catchError((e) {});

        await showAlertDialogs.showAlertDialog(
            context, "Quiz Successfully Deleted");
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Would you like to Remove this Participant"),
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
}
