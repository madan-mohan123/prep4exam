import 'package:flutter/material.dart';
import 'package:prep4exam/services/database.dart';

class FormResult extends StatefulWidget {
  final String id;

  FormResult(this.id);
  @override
  _FormResultState createState() => _FormResultState();
}

class _FormResultState extends State<FormResult> {
  DatabaseService databaseService = new DatabaseService();
  List<Map<String, dynamic>> formlist = [];
  List<String> headerlist = [];

  @override
  void initState() {
    databaseService.getJoinedForm(widget.id).then((value) {
      setState(() {
        // print("==============");
        formlist = List<Map<String, dynamic>>.from(value);
        // print("==============*********");
        headerlist.add("Email");
        // print("==============*********");/
        List<String> random = [];
        random =formlist[0]["response"].keys.toList();
        for (int i = 0; i < random.length; i++) {
          headerlist.add(random[i].toString());
        }
        // headerlist.add(formlist[0]["response"].keys.toList());
        // print("==============");
        // print(headerlist);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Form Result"),
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          brightness: Brightness.light,
        ),
        body: Container(
            child: ListView(shrinkWrap: true, children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: headerlist
                  .map((key) => DataColumn(label: Text(key)))
                  .toList(),
              rows: formlist.map(
                ((element) {
                  String responseEmail = element["email"].toString();
                  List<dynamic> mylk =
                      List<dynamic>.from(element["response"].values.toList());
                  List<dynamic> k = [];
                  k.add(responseEmail);
                  for (int i = 0; i < mylk.length; i++) {
                    if (mylk[i] is String) {
                      k.add(mylk[i].toString());
                      // print("sds");
                    } else {
                      String s = mylk[i].join("-");
                      k.add(s);
                    }
                  }

                  return DataRow(
                    cells:
                        k.map((key) => DataCell(Text(key.toString()))).toList(),
//
                  );
                }),
              ).toList(),
            ),
          )
        ])),
      );
    } catch (e) {
      print(e.toString());
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Form Result"),
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          brightness: Brightness.light,
        ),
        body: Container(
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }
  }
}
