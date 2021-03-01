import 'package:flutter/material.dart';
import 'package:prep4exam/widgets/widgets.dart';

class Feedback extends StatefulWidget {
  @override
  _FeedbackState createState() => _FeedbackState();
}

class _FeedbackState extends State<Feedback> {
  var formlist = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appBar(context),
          backgroundColor: Colors.red[700],
          elevation: 0.0,
          brightness: Brightness.light,
          // leading: Icon(
          //   Icons.more_vert,
          //   color: Colors.white,
          // ),
          leading: IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              dynamicFormTextField();
            },
          ),
        ),
        body: Container(
          child: Form(
            child: ListView(
              children: [
                IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              dynamicFormTextField();
            },
          ),
              ],
            ),
          ),
        ));
  }

  Widget dynamicFormTextField() {
    return Container(
      child: TextFormField(
        validator: (val) => val.isEmpty ? "Enter Question" : null,
        decoration: InputDecoration(
          hintText: "Enter Question",
        ),
        onChanged: (val) {
          //
          formlist.add(val);
        },
      ),
    );
  }
}
