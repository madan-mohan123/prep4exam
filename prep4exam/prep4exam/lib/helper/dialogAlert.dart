import 'package:flutter/material.dart';

class ShowAlertDialogs {


   showAlertDialog(BuildContext context, String msg) async{
  
    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert", style: TextStyle(fontSize: 20.0, color: Colors.red)),
      content: Text(msg),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
   await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


}