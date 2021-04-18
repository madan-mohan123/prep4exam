import 'package:flutter/material.dart';
import 'package:prep4exam/views/poll/polldashboard.dart';
import 'package:prep4exam/widgets/widgets.dart';
import 'package:random_string/random_string.dart';
import 'package:prep4exam/services/database.dart';
import 'package:prep4exam/services/auth.dart';

class PollCreate extends StatefulWidget {
  @override
  _PollCreateState createState() => _PollCreateState();
}

class _PollCreateState extends State<PollCreate> {
  DatabaseService databaseService = new DatabaseService();
  AuthServices authServices = new AuthServices();
  final _formKey = GlobalKey<FormState>();
  String pollquestion;
  String pollId, pollDesc, _email;

  @override
  void initState() {
    //set current user email
    authServices.getcurrentuser().then((value) {
      setState(() {
        _email = value;
      });
    });

    super.initState();
  }

  _showDialog() async {
    await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: 'Enter Poll Question',
                        hintText: 'eg. xxxxx'),
                    onChanged: (val) {
                      pollquestion = val;
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
                    pollId = randomAlphaNumeric(5);
                    DateTime currentTime = DateTime.now();
          String cdt = currentTime.day.toString() + " : "+
              currentTime.month.toString() + " : " +
              currentTime.year.toString();
                    Map<String, dynamic> pollMap = {
                      "pollId": pollId,
                      "pollDesc": pollquestion,
                      "email": _email,
                      "votes": "0/0",
                      "date":cdt
                    };
                    await databaseService.createPoll(pollMap, pollId);
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         backgroundColor: Colors.white60,
        appBar: AppBar(
         title: appBar(context),
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          brightness: Brightness.light,
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  validator: (val) => val.isEmpty ? "Enter Poll" : null,
                  decoration: InputDecoration(
                    hintText: "Poll",
                  ),
                  onChanged: (val) {
                    //
                    pollquestion = val;
                  },
                ),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    // pollCreate();
                    _showDialog();
                  },
                  child: blueButton(
                    context: context,
                    label: " Create poll",
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  pollCreate() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        // _isLoading = true;
      });

      pollId = randomAlphaNumeric(8);
      Map<String, dynamic> pollMap = {
        "pollId": pollId,
        "pollDesc": pollquestion,
        "email": _email,
        "votes": "0/0"
      };
      await databaseService.createPoll(pollMap, pollId).then((val) {
        setState(() {
          // _isLoading = false;
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => PollDashboard()));
        });
      }).catchError((e) {
        pollCreate();
      });
    }
  }
}
