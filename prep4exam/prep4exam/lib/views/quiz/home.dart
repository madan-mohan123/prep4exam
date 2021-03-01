import 'package:flutter/material.dart';
import 'package:prep4exam/services/database.dart';
import 'package:prep4exam/widgets/widgets.dart';
import 'package:prep4exam/views/quiz/createquiz.dart';
import 'package:prep4exam/views/quiz/play_quiz.dart';
import 'package:prep4exam/services/auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //create strem for accessing database
  Stream quizStream;
  List quizJoinId;

  DatabaseService databaseService = new DatabaseService();

  AuthServices authServices = new AuthServices();
  String useremail = "";

  Widget quizList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: StreamBuilder(
        stream: quizStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Random()
              : ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    if (snapshot.data.documents[index].data["email"] ==
                        useremail) {
                      return QuizTileAdmin(
                        imgUrl:
                            snapshot.data.documents[index].data["quizImgUrl"],
                        title: snapshot.data.documents[index].data["quizTitle"],
                        desc: snapshot
                            .data.documents[index].data["quizDescription"],
                        quizId: snapshot.data.documents[index].data["quizId"],
                      );
                    } else if (quizJoinId.isEmpty) {
                      return Random();
                    } else if (quizJoinId.contains(
                        snapshot.data.documents[index].data["quizId"])) {
                      return QuizTile(
                          imgUrl:
                              snapshot.data.documents[index].data["quizImgUrl"],
                          title:
                              snapshot.data.documents[index].data["quizTitle"],
                          desc: snapshot
                              .data.documents[index].data["quizDescription"],
                          quizId: snapshot.data.documents[index].data["quizId"],
                          admin: "join");
                    } else {
                      return Random();
                    }
                  },
                );
        },
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[400],
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.red[700],
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: quizList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateQuiz()));
        },
      ),
    );
  }
}

class QuizTile extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String desc;
  final String quizId;
  final String admin;

  QuizTile({
    @required this.imgUrl,
    @required this.title,
    @required this.desc,
    @required this.quizId,
    @required this.admin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PlayQuiz(quizId)));
      },
      child: Container(
        margin: EdgeInsets.all(4.0),
        height: 150,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imgUrl,
                width: MediaQuery.of(context).size.width - 20,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black26,
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ID :  " + quizId,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    admin,
                    style: TextStyle(
                        color: Colors.orange[600],
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
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
  }
}

class QuizTileAdmin extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String desc;
  final String quizId;

  QuizTileAdmin({
    @required this.imgUrl,
    @required this.title,
    @required this.desc,
    @required this.quizId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PlayQuiz(quizId)));
      },
      onLongPress: () {
        // ConfirmDismissCallback()
      },
      child: Container(
        margin: EdgeInsets.all(4.0),
        height: 150,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imgUrl,
                width: MediaQuery.of(context).size.width - 20,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black26,
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ID :  " + quizId,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      ButtonBar(
                        children: [
                          GestureDetector(
                            onTap: (){
                              //function
                            },
                          child:Text("Start"),),

                          SizedBox(
                            width: 10.0,
                          ),
                          Text("Result")
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
  }
}

class Random extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

//-------------------------------------------------------------------
class JoinQuizList extends StatefulWidget {
  @override
  _JoinQuizListState createState() => _JoinQuizListState();
}

class _JoinQuizListState extends State<JoinQuizList> {
  Stream joinedQuiz;
  List quizJoinId;
  DatabaseService databaseService = new DatabaseService();
  AuthServices authServices = new AuthServices();
  String useremail = "";

  @override
  void initState() {
    authServices.getcurrentuser().then((value) {
      setState(() {
        useremail = value;
      });
    });

    //return list of join quizid
    databaseService.getQuizezData().then((val) {
      print("==========");
      print(useremail);
      setState(() {
        quizJoinId = val;
      });
    });

    databaseService.getQuizezDataCreateBy().then((val) {
      setState(() {
        joinedQuiz = val;
      });
    });

    //return quizez that is created

    super.initState();
  }

  Widget quizListjoin() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: StreamBuilder(
        stream: joinedQuiz,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Container()
              : ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    if (snapshot.data != null) {
                      if (quizJoinId.contains(
                          snapshot.data.documents[index].data["quizId"])) {
                        return QuizTile(
                            imgUrl: snapshot
                                .data.documents[index].data["quizImgUrl"],
                            title: snapshot
                                .data.documents[index].data["quizTitle"],
                            desc: snapshot
                                .data.documents[index].data["quizDescription"],
                            quizId:
                                snapshot.data.documents[index].data["quizId"],
                            admin: "Join");
                      } else {
                        return Random();
                      }
                    } else {
                      return Random();
                    }
                  },
                );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[400],
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.red[700],
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: quizListjoin(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateQuiz()));
        },
      ),
    );
  }
}
