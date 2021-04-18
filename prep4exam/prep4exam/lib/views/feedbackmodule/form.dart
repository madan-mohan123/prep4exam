// import 'package:flutter/material.dart';
// import 'package:prep4exam/widgets/widgets.dart';

// class MyForm extends StatefulWidget {
//   @override
//   _MyFormState createState() => _MyFormState();
// }



// class _MyFormState extends State<MyForm> {
//   // final _formKey = GlobalKey<FormState>();
//   // TextEditingController _nameController;
//   // static List<String> myformlist = [null];
//   List<Map<String, String>> formfieldlist = [];
// String selectedfield = "textfield";

//   @override
//   void initState() {
//     super.initState();
//     formfieldlist.clear();
//   }

//   // @override
//   // void dispose() {
//   //   _nameController.dispose();
//   //   super.dispose();
//   // }
//   // String selectedfield = "textfield";
//   // List<Map<String, String>> formfieldlist = [];

//   void handleClick(String value) {
//     switch (value) {
//       case 'textfield':
//         setState(() {
//           selectedfield = "textfield";
//         });
//         // mytextfield();
//         break;
//       case 'radiobox':
//         setState(() {
//           selectedfield = "radiobox";
//         });
//         // myradiobox();
//         break;
//       case 'checkbox':
//         setState(() {
//           selectedfield = "checkbox";
//         });
//         // mycheckbox();
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.grey[200],
//         appBar: AppBar(
//           title: appBar(context),
//           backgroundColor: Colors.blueAccent,
//           elevation: 0.0,
//           brightness: Brightness.light,
//           actions: <Widget>[
//             PopupMenuButton<String>(
//               onSelected: handleClick,
//               itemBuilder: (BuildContext context) {
//                 return {'textfield', 'radiobox', 'checkbox'}
//                     .map((String choice) {
//                   return PopupMenuItem<String>(
//                     value: choice,
//                     child: Text(choice),
//                   );
//                 }).toList();
//               },
//             ),
//           ],
//         ),
//         // body: Form(
//         //   key: _formKey,
//         //   child: Padding(
//         //     padding: const EdgeInsets.all(16.0),
//         //     child: Column(
//         //       crossAxisAlignment: CrossAxisAlignment.start,
//         //       children: [
//         //         // name textfield
//         //         Padding(
//         //           padding: const EdgeInsets.only(right: 32.0),
//         //           child: TextFormField(
//         //             controller: _nameController,
//         //             decoration: InputDecoration(hintText: 'Enter your name'),
//         //             validator: (v) {
//         //               if (v.trim().isEmpty) return 'Please enter something';
//         //               return null;
//         //             },
//         //           ),
//         //         ),
//         //         SizedBox(
//         //           height: 20,
//         //         ),
//         //         Text(
//         //           'Add Friends',
//         //           style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
//         //         ),
//         //         ..._getFriends(),
//         //         SizedBox(
//         //           height: 40,
//         //         ),
//         //         FlatButton(
//         //           onPressed: () {
//         //             if (_formKey.currentState.validate()) {
//         //               _formKey.currentState.save();
//         //             }
//         //           },
//         //           child: Text('Submit'),
//         //           color: Colors.green,
//         //         ),
//         //       ],
//         //     ),
//         //   ),
//         // ),
//         body: new Column(
//           children: <Widget>[
//             // new TextField(
//             //   // controller: eCtrl,
//             //   onSubmitted: (text) {
//             //     // litems.add(text);
//             //     // eCtrl.clear();
//             //     setState(() {});
//             //   },
//             // ),
//             new Expanded(
//                 child: new ListView.builder(
//                     itemCount: formfieldlist.length + 1,
//                     itemBuilder: (BuildContext ctxt, int index) {
//                       try {
//                         if (selectedfield == "textfield") {
//                          return mytextfield();
                         
//                         } else if (selectedfield == "radiobox") {
//                           return myradiobox();
//                         } else {
//                           return mycheckbox();
//                         }
//                       } catch (e) {
//                         return Container();
//                       }
//                     }))
//           ],
//         ));
//   }

//   /// get firends text-fields
//   // List<Widget> _getFriends() {
//   //   List<Widget> friendsTextFields = [];
//   //   for (int i = 0; i < myformlist.length; i++) {
//   //     friendsTextFields.add(Padding(
//   //       padding: const EdgeInsets.symmetric(vertical: 16.0),
//   //       child: Row(
//   //         children: [
//   //           Expanded(child: FriendTextFields(i)),
//   //           SizedBox(
//   //             width: 16,
//   //           ),
//   //           // we need add button at last friends row
//   //           _addRemoveButton(i == myformlist.length - 1, i),
//   //         ],
//   //       ),
//   //     ));
//   //   }
//   //   return friendsTextFields;
//   // }

//   /// add / remove button
//   // Widget _addRemoveButton(bool add, int index) {
//   //   return InkWell(
//   //     onTap: () {
//   //       if (add) {
//   //         // add new text-fields at the top of all friends textfields
//   //         myformlist.insert(0, null);
//   //       } else
//   //         myformlist.removeAt(index);
//   //       setState(() {});
//   //     },
//   //     child: Container(
//   //       width: 30,
//   //       height: 30,
//   //       decoration: BoxDecoration(
//   //         color: (add) ? Colors.green : Colors.red,
//   //         borderRadius: BorderRadius.circular(20),
//   //       ),
//   //       child: Icon(
//   //         (add) ? Icons.add : Icons.remove,
//   //         color: Colors.white,
//   //       ),
//   //     ),
//   //   );
//   // }


  
// Widget myradiobox() {
//   return ListTile(
//     title: const Text('name of your field'),
//     leading: Radio(
//       value: "true",
//       groupValue: "ff",
//       onChanged: (String value) {
//         // _site = value;
//       },
//     ),
//   );
// }

// Widget mycheckbox() {
//   return CheckboxListTile(
//     // secondary: const Icon(Icons.alarm),
//     title: const Text('val'),
//     // subtitle: Text('Ringing after 12 hours'),
//     value: false,
//     onChanged: (bool value) {
//       // this.valuefirst = value;
//     },
//   );
// }

// Widget mytextfield() {
//   final TextEditingController eCtrl = new TextEditingController();
//   return new Padding(
//     padding: EdgeInsets.all(15),
//     child: TextField(
//         decoration: InputDecoration(
//           border: OutlineInputBorder(),
//           labelText: 'Enter field value',
//           hintText: 'It cannot be null',
//         ),
//         onSubmitted: (text) {
//           formfieldlist.add({"value": text, "type": "textfield"});
//           eCtrl.clear();
//           print("lllllllllll");
//           print(formfieldlist.length);
//           selectedfield = "textfield";
//         }),
//   );
// }
// }

// // class FriendTextFields extends StatefulWidget {
// //   final int index;
// //   FriendTextFields(this.index);
// //   @override
// //   _FriendTextFieldsState createState() => _FriendTextFieldsState();
// // }

// // class _FriendTextFieldsState extends State<FriendTextFields> {
// //   TextEditingController _nameController;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _nameController = TextEditingController();
// //   }

// //   @override
// //   void dispose() {
// //     _nameController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
// //       _nameController.text = _MyFormState.myformlist[widget.index] ?? '';
// //     });

// //     return TextFormField(
// //       controller: _nameController,
// //       onChanged: (v) => _MyFormState.myformlist[widget.index] = v,
// //       decoration: InputDecoration(hintText: 'Enter your field\'s name'),
// //       validator: (v) {
// //         if (v.trim().isEmpty) return 'Please enter something';
// //         return null;
// //       },
// //     );
// //   }
// // }

// // class Myradiobutton extends StatefulWidget {
// //   // final int index;
// //   Myradiobutton();
// //   @override
// //   _MyradiobuttonState createState() => _MyradiobuttonState();
// // }

// // class _MyradiobuttonState extends State<Myradiobutton> {
// //   TextEditingController _nameController;
// //   String _site = "koko";

// //   @override
// //   void initState() {
// //     super.initState();
// //     _nameController = TextEditingController();
// //   }

// //   @override
// //   void dispose() {
// //     _nameController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
// //       _nameController.text = _MyFormState.myformlist[widget.index] ?? '';
// //     });

// //     return Radio(
// //         value: "Hello",
// //         groupValue: _site,
// //         onChanged: (String value) {
// //           setState(() {
// //             _site = value;
// //           });
// //         });
// //   }
// // }

// // Widget myradiobox() {
// //   return ListTile(
// //     title: const Text('name of your field'),
// //     leading: Radio(
// //       value: "true",
// //       groupValue: "ff",
// //       onChanged: (String value) {
// //         // _site = value;
// //       },
// //     ),
// //   );
// // }

// // Widget mycheckbox() {
// //   return CheckboxListTile(
// //     // secondary: const Icon(Icons.alarm),
// //     title: const Text('val'),
// //     // subtitle: Text('Ringing after 12 hours'),
// //     value: false,
// //     onChanged: (bool value) {
// //       // this.valuefirst = value;
// //     },
// //   );
// // }

// // class Mytextfield extends StatefulWidget {
// //   @override
// //   _MytextfieldState createState() => _MytextfieldState();
// // }

// // class _MytextfieldState extends State<Mytextfield> {
// //   final TextEditingController eCtrl = new TextEditingController();
// //   @override
// //   Widget build(BuildContext context) {
// //     return new Padding(
// //       padding: EdgeInsets.all(15),
// //       child: TextField(
// //           decoration: InputDecoration(
// //             border: OutlineInputBorder(),
// //             labelText: 'Enter field value',
// //             hintText: 'It cannot be null',
// //           ),
// //           onSubmitted: (text) {
// //             formfieldlist.add({"value": text, "type": "textfield"});
// //             eCtrl.clear();
// //             print("lllllllllll");
// //             print(formfieldlist.length);
// //             setState(() {
// //               selectedfield = "textfield";
// //             });
// //           }),
// //     );
// //   }
// // }

// // Widget mytextfifeld() {
// //   final TextEditingController eCtrl = new TextEditingController();
// //   return new Padding(
// //     padding: EdgeInsets.all(15),
// //     child: TextField(
// //         decoration: InputDecoration(
// //           border: OutlineInputBorder(),
// //           labelText: 'Enter field value',
// //           hintText: 'It cannot be null',
// //         ),
// //         onSubmitted: (text) {
// //           formfieldlist.add({"value": text, "type": "textfield"});
// //           eCtrl.clear();
// //           print("lllllllllll");
// //           print(formfieldlist.length);
// //           selectedfield = "textfield";
// //         }),
// //   );
// // }
