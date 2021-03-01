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
  // bool _isLoading = false;

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
        body: Container(
          padding: EdgeInsets.all(10.0),
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
                    pollCreate();
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

      pollId = randomAlphaNumeric(5);
      Map<String, dynamic> pollMap = {
        "pollId": pollId,
        "pollDesc": pollquestion,
        "email": _email,
        "yes":0,
        "No":0
      };
      await databaseService.createPoll(pollMap, pollId).then((val) {
        setState(() {
          // _isLoading = false;
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => PollDashboard()));
        });
      });
    }
  }
}
