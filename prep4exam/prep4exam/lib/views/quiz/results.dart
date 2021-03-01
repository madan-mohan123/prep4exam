import 'package:flutter/material.dart';
import 'package:prep4exam/widgets/widgets.dart';

class Results extends StatefulWidget {
  final int correct, incorrect, total;
  Results(
      {@required this.correct, @required this.incorrect, @required this.total});
  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[800],
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
                  Navigator.pop(context);
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
