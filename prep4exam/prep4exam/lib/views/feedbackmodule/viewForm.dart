// // import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:prep4exam/services/database.dart';
// // import 'package:prep4exam/views/feedbackmodule/formCreate.dart';
// import 'package:prep4exam/widgets/widgets.dart';

// class ViewForms extends StatefulWidget {
//   final String id;
//   final String email;

//   ViewForms(this.id, this.email);
//   @override
//   _ViewFormsState createState() => _ViewFormsState();
// }

// class _ViewFormsState extends State<ViewForms> {
//   DatabaseService databaseService = new DatabaseService();
//   Map<String, dynamic> responseform;

//   @override
//   void initState() {
//     databaseService.getFormWithEmail(widget.id, widget.email).then((value) {
//       setState(() {
//          responseform = value;
//       // print("lllllllllll");
//       // print(responseform);
//       });
     
//     });

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: appBar(context),
//         backgroundColor: Colors.blueAccent,
//         elevation: 0.0,
//         brightness: Brightness.light,
//       ),
//       body: Container(
//         // child: ListView.builder(
//         //     itemCount: responseform.length,
//         //     itemBuilder: (context, index) {
//         //       try {
//         //         if (formfieldlist[index].values.toList()[1] == "textfield") {
//         //           return new Padding(
//         //             padding: EdgeInsets.all(15),
//         //             child: TextField(
//         //               decoration: InputDecoration(
//         //                 border: OutlineInputBorder(),
//         //                 labelText: formfieldlist[index].values.toList().first,
//         //                 hintText: '',
//         //               ),
//         //             ),
//         //           );
//         //         } else if (formfieldlist[index].values.toList()[1] ==
//         //             "checkbox") {
//         //           return MyFormCheckbox(
//         //               index,
//         //               formfieldlist[index].values.toList()[2],
//         //               formfieldlist[index].values.toList()[0]);
//         //         } else {
//         //           return MyFormradio(
//         //               index,
//         //               formfieldlist[index].values.toList()[2],
//         //               formfieldlist[index].values.toList()[0]);
//         //         }
//         //       } catch (e) {
//         //         return Container();
//         //       }
//         //     }),
//       ),
//     );
//   }
// }

// class MyFormCheckbox extends StatefulWidget {
//   final int index;
//   final String title;
//   final List<String> checkboxlist;

//   MyFormCheckbox(this.index, this.checkboxlist, this.title);
//   @override
//   _MyFormCheckboxState createState() => _MyFormCheckboxState();
// }

// class _MyFormCheckboxState extends State<MyFormCheckbox> {
//   List<bool> checkfalse = [];
//   Set<String> selectcheckbox = {};
//   @override
//   void initState() {
//     super.initState();

//     setState(() {
//       checkfalse =
//           new List.filled(widget.checkboxlist.length, false, growable: true);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         color: Colors.blue,
//         margin: EdgeInsets.all(15),
//         child: Column(children: [
//           Container(
//             alignment: Alignment.topLeft,
//             padding: EdgeInsets.all(5),
//             child: Text(widget.title, style: TextStyle(color: Colors.white)),
//           ),
//           Container(
//             height: 150.0,
//             color: Colors.white,
//             child: ListView.builder(
//                 itemCount: widget.checkboxlist.length,
//                 itemBuilder: (BuildContext con, int ind) {
//                   return CheckboxListTile(
//                     title: Text(widget.checkboxlist[ind]),
//                     value: true,
//                     onChanged: (ch) {
//                       setState(() {});
//                     },
//                   );
//                 }),
//           ),
//         ]));
//   }
// }

// class MyFormradio extends StatefulWidget {
//   final int index;
//   final String title;
//   final List<String> radioboxlist;

//   MyFormradio(this.index, this.radioboxlist, this.title);
//   @override
//   _MyFormradioState createState() => _MyFormradioState();
// }

// class _MyFormradioState extends State<MyFormradio> {
//   String radioval = "";
// //    Set<String> selectradiobox={};
//   @override
//   void initState() {
//     super.initState();

//     setState(() {
//       radioval = widget.radioboxlist[0];
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         color: Colors.orangeAccent,
//         margin: EdgeInsets.all(15),
//         child: Column(children: [
//           Container(
//             alignment: Alignment.topLeft,
//             padding: EdgeInsets.all(5),
//             child: Text(widget.title, style: TextStyle(color: Colors.white)),
//           ),
//           Container(
//             height: 150.0,
// //
//             color: Colors.white,
//             child: ListView.builder(
//                 itemCount: widget.radioboxlist.length,
//                 itemBuilder: (BuildContext con, int ind) {
//                   return ListTile(
//                     title: Text(widget.radioboxlist[ind]),
//                     leading: Radio(
//                       value: widget.radioboxlist[ind].toString(),
//                       groupValue: widget.radioboxlist[ind].toString(),
//                       onChanged: (val) {},
//                     ),
//                   );
//                 }),
//           ),
//         ]));
//   }
// }
