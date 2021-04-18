
import 'package:flutter/material.dart';
import 'package:prep4exam/services/database.dart';
// import 'package:prep4exam/widgets/widgets.dart';

class ShowResult extends StatefulWidget {
  final String quizId;
  ShowResult(this.quizId);
  @override
  _ShowResultState createState() => _ShowResultState();
}

class _ShowResultState extends State<ShowResult> {
  DatabaseService databaseService = new DatabaseService();
  List<Map<String, String>> listOfColumns;

  @override
  void initState() {
    databaseService.getScore(widget.quizId).then((value) {
      setState(() {
        listOfColumns = List<Map<String, String>>.from(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Quiz Result'),
        backgroundColor: Colors.blueAccent,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: resultTile(),
    );
  }

  Widget resultTile() {
    try {
      return ListView(
        children: [
          DataTable(
            columns: [
              DataColumn(
              
                  label: Text('UserName',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Scores',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
            ],
            rows: listOfColumns.isEmpty
                ? DataRow(cells: <DataCell>[
                    DataCell(Text("")),
                    DataCell(Text("")),
                  ])
                : listOfColumns
                    .map(
                      ((element) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(element["Email"],style: TextStyle(
                          fontSize: 15,))),
                              DataCell(Text(element["Score"],style: TextStyle(
                          fontSize: 15,))),
                            ],
                          )),
                    )
                    .toList(),
          ),
        ],
      );
    } catch (e) {
      return Container(
        child: Center(child:CircularProgressIndicator(
          
        ), ),
      );
    }
  }
}
