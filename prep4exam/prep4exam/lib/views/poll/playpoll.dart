import 'package:flutter/material.dart';
import 'package:prep4exam/views/poll/polldashboard.dart';
import 'package:prep4exam/widgets/widgets.dart';

class Playpoll extends StatefulWidget {
  final String pollId;
  Playpoll(this.pollId);
  @override
  _PlaypollState createState() => _PlaypollState();
}

class _PlaypollState extends State<Playpoll> {
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
        child: PlayPollTile(),
      ),
    );
  }
}

class PlayPollTile extends StatefulWidget {
  // final QuestionModel questionModel;
  final int index;

  PlayPollTile({this.index});

  @override
  _PlayPollTileState createState() => _PlayPollTileState();
}

class _PlayPollTileState extends State<PlayPollTile> {
  String optionSelected = "";
  String answeres;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Q${widget.index + 1} {widget.questionModel.question}",
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            SizedBox(
              height: 12,
            ),
            GestureDetector(
                onTap: () {
                  answeres = "false";
                },
                child: Text("False")),
            SizedBox(
              height: 4,
            ),
            GestureDetector(onTap: () {
              answeres = "True";
            }, child: Text("True")),
            SizedBox(
              height: 4,
            ),
          ],
        ),
      ),
    );
  }
}
