import 'package:flutter/material.dart';
import 'package:prep4exam/views/poll/pollcreate.dart';
import 'package:prep4exam/views/quiz/home.dart';
import 'package:prep4exam/widgets/widgets.dart';
import 'package:prep4exam/services/database.dart';
import 'package:prep4exam/services/auth.dart';
import 'package:prep4exam/views/poll/playpoll.dart';

class PollDashboard extends StatefulWidget {
  @override
  _PollDashboardState createState() => _PollDashboardState();
}

class _PollDashboardState extends State<PollDashboard> {
  Stream pollstream;
  String email = "";
  Stream polldata;
  List joinPollIdList;
  DatabaseService databaseService = new DatabaseService();
  AuthServices authServices = new AuthServices();

  @override
  void initState() {
    //set current user email
    authServices.getcurrentuser().then((value) {
      setState(() {
        email = value;
      });
    });

    //return poll that is created
    databaseService.getPollData().then((val) {
      setState(() {
        polldata = val;
      });
    });

    //return list of join pollid
    databaseService.getPollJoinList().then((val) {
      setState(() {
        joinPollIdList = val;
      });
    });

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
       backgroundColor: Colors.red[700],
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: Container(
          color: Colors.redAccent[400],
          child: StreamBuilder(
              stream: polldata,
              builder: (context, snapshot) {
                return snapshot.data == null
                    ? Container()
                    : ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          if (snapshot.data.documents[index].data["email"] ==
                              email) {
                           
                            return PollTile(
                                desc: snapshot
                                    .data.documents[index].data["pollDesc"],
                                admin: "admin",
                                pollId: snapshot
                                    .data.documents[index].data["pollId"],
                                yes: 10,
                                no: 5);
                          } else if (joinPollIdList.contains(
                              snapshot.data.documents[index].data["pollId"])) {
                            return PollTile(
                                desc: snapshot
                                    .data.documents[index].data["pollDesc"],
                                admin: "Join",
                                pollId: snapshot
                                    .data.documents[index].data["pollId"],
                                yes: 10,
                                no: 5);
                          } else {
                            return Random();
                          }
                        });
              })),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PollCreate()));
        },
      ),
    );
  }
}

class PollTile extends StatelessWidget {
  final String desc;
  final String pollId;
  final String admin;
  final int yes;
  final int no;

  PollTile({
    @required this.desc,
    @required this.pollId,
    @required this.admin,
    @required this.yes,
    @required this.no,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Playpoll(pollId)));
      },
      child: Container(
        // color: Colors.lightBlue[200],
        margin: EdgeInsets.all(4.0),
        height: 150,
        child: Stack(
          children: [

            
            
            Container(
              height: 150.00,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.cyan[600],
                  elevation: 10,
                  child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    desc,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    admin,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                   "PollId: $pollId",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                    Container(
                      
padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
               color: Colors.amber[800],
              ),
                      child: Text("Yes : $yes",style:TextStyle(color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400)),
                    ),
                    SizedBox(width: 10.0,),
                    Container(
                      
padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
               color: Colors.blue[400],
              ),
                      child: Text("No : $no",style:TextStyle(color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400)),
                    )
                  ],)
                ],
              ),
            ),
        ),


      ),
          ])
    )
    );
  }
}
