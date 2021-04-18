import 'package:flutter/material.dart';
import 'package:prep4exam/views/quiz/quizHome.dart';
import 'package:prep4exam/widgets/widgets.dart';
import 'package:prep4exam/services/database.dart';

class Results extends StatefulWidget {
  final int correct, incorrect, total;
  final String quizId;
  Results(
      {@required this.correct,
      @required this.incorrect,
      @required this.total,
      @required this.quizId});

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  var marks;
  DatabaseService databaseService = new DatabaseService();

  @override
  void initState() {
   var score = databaseService.getquizMarks(widget.quizId);
    print("lllllllll");
    print(score);
    setState(() {
      marks = score;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[400],
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${widget.correct}/${widget.total}",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "You answered ${widget.correct} answered correctly"
              " and ${widget.incorrect} answer incorrectly",
              style: TextStyle(fontSize: 15, color: Colors.blue[50]),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 14,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pop(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home()));
                },
                child: blueButton(
                    context: context,
                    label: "Go To Home",
                    buttonWidth: MediaQuery.of(context).size.width / 2)),
          ],
        )),
      ),
    );
  }
}
