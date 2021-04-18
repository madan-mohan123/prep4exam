import 'package:flutter/material.dart';
import 'package:prep4exam/services/database.dart';

class ResultPoll extends StatefulWidget {
  final String pollId;
  ResultPoll(this.pollId);
  @override
  _ResultPollState createState() => _ResultPollState();
}

class _ResultPollState extends State<ResultPoll> {
  DatabaseService databaseService = new DatabaseService();
  Stream result;
  @override
  void initState() {
    databaseService.getpollResult(widget.pollId).then((val) {
      setState(() {
        result = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
          backgroundColor: Colors.white60,
          appBar: AppBar(
              title: Text('Poll Result'),
              backgroundColor: Colors.blueAccent,
              elevation: 0.0,
              brightness: Brightness.light,
              actions: [
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        // _showDialog();
                      },
                      child: Icon(Icons.add_box_rounded),
                    )),
              ]),
          body: Container(
            child: StreamBuilder(
                stream: result,
                builder: (context, snapshot) {
                  return snapshot.data == null
                      ? Container(
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            try {
                              if (snapshot
                                      .data.documents[index].data["pollId"] ==
                                  widget.pollId) {
                                return ResultTile(
                                    response: snapshot
                                        .data.documents[index].data["voting"],
                                    mailid: snapshot
                                        .data.documents[index].data["email"]);
                              } else {
                                return Container();
                              }
                            } catch (e) {
                              return Container();
                            }
                          });
                }),
          ));
    } catch (e) {
      return Center(child: Container(child: CircularProgressIndicator()));
    }
  }
}

class ResultTile extends StatefulWidget {
  final String response;
  final String mailid;
  ResultTile({@required this.response, @required this.mailid});
  @override
  _ResultTileState createState() => _ResultTileState();
}

class _ResultTileState extends State<ResultTile> {
  DatabaseService databaseService = new DatabaseService();
  String userFirstLetter = "";
  @override
  void initState() {
    databaseService.getProfile().then((value) {
      setState(() {
        userFirstLetter = value["email"].substring(0, 1).toUpperCase();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Container(
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
                  ],
                ),
                child: Container(
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          title: Text("$userFirstLetter : ${widget.mailid}",
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600)),
                          subtitle: Text("Reply: ${widget.response}"),
                        ))))),
      );
    } catch (e) {
      return Container(
          child: Text("No Result Found", style: TextStyle(fontSize: 20.0)));
    }
  }
}
