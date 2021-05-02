import 'package:flutter/material.dart';
import 'package:prep4exam/helper/dialogAlert.dart';
import 'package:prep4exam/views/feedbackmodule/formdash.dart';
import 'package:prep4exam/widgets/widgets.dart';
import 'package:prep4exam/services/database.dart';
import 'package:prep4exam/services/auth.dart';
import 'package:random_string/random_string.dart';

List<Map<String, dynamic>> formfieldlist = [];
String selectedfield = "textfield";

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  List<bool> chList;
  DatabaseService databaseService = new DatabaseService();
  AuthServices authServices = new AuthServices();
  String useremail;
  String formId;
  String formName = "";
  String formDesc = "";

  @override
  void initState() {
    authServices.getcurrentuser().then((value) {
      setState(() {
        useremail = value;
      });
    });

    super.initState();
  }

  final TextEditingController eCtrl = new TextEditingController();
  void handleClick(String value) {
    switch (value) {
      case 'Textfield':
        setState(() {
          selectedfield = "textfield";
        });

        break;
      case 'Radiobox':
        setState(() {
          selectedfield = "radiobox";
        });

        break;
      case 'Checkbox':
        setState(() {
          selectedfield = "checkbox";
        });

        break;
      case 'Reset':
        setState(() {
          formfieldlist.clear();
        });

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.blueAccent,
        elevation: 0.0,
        brightness: Brightness.light,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Textfield', 'Radiobox', 'Checkbox', 'Reset'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            child: Column(
              children: [
                ListView(
                  shrinkWrap: true,
                  children: [
                    Builder(builder: (context) {
                      if (selectedfield == "textfield") {
                        return mytextfield();
                      } else if (selectedfield == "checkbox") {
                        return Mych();
                      } else {
                        return MyRadiobox();
                      }
                    }),
                  ],
                ),
                Divider(height: 2.0),
                Container(
                    margin: EdgeInsets.fromLTRB(15, 10, 15, 5),
                    child: Text(
                      "FormName: $formName",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w500),
                    )),
                Container(
                    margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                    child: Text(
                      formDesc,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue),
                    )),
                Divider(
                  height: 3.0,
                  color: Colors.grey,
                ),
                new ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: formfieldlist.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      try {
                        if (formfieldlist[index].containsValue("textfield")) {
                          return new Padding(
                            padding: EdgeInsets.all(15),
                            child: TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: formfieldlist[index]
                                      .values
                                      .toList()
                                      .first,
                                  hintText: '',
                                ),
                                onSubmitted: (text) {}),
                          );
                        } else if (formfieldlist[index]
                            .containsValue("radiobox")) {
                          var myradiolist = [];

                          myradiolist = formfieldlist[index].values.toList();

                          return Container(
                              color: Colors.orangeAccent,
                              margin: EdgeInsets.all(15),
                              child: Column(children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                      formfieldlist[index]
                                          .values
                                          .toList()
                                          .first,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15.0)),
                                ),
                                Container(
                                  color: Colors.white,
                                  child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: myradiolist[2].length,
                                      itemBuilder: (BuildContext con, int ind) {
                                        return ListTile(
                                          title: Text(myradiolist[2][ind]),
                                          leading: Radio(
                                            value:
                                                myradiolist[2][ind].toString(),
                                            groupValue: " _site",
                                            onChanged: (String value) {
                                              setState(() {});
                                            },
                                          ),
                                        );
                                      }),
                                ),
                              ]));
                        } else {
                          var mylis = [];

                          mylis = formfieldlist[index].values.toList();
                          // print("=======");
                          // print(mylis[2]);
                          return Container(
                              margin: EdgeInsets.all(15),
                              child: Column(children: [
                                Container(
                                  color: Colors.blue,
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                      formfieldlist[index]
                                          .values
                                          .toList()
                                          .first,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15.0)),
                                ),
                                Container(
                                  color: Colors.white,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: mylis[2].length,
                                      itemBuilder: (BuildContext con, int ind) {
                                        return CheckboxListTile(
                                          title: Text(mylis[2][ind]),
                                          value: false,
                                          onChanged: (bool value) {
                                            setState(() {
                                              //  this.chList[ind]=true;
                                            });
                                          },
                                        );
                                      }),
                                ),
                              ]));
                        }
                      } catch (e) {
                        return Container();
                      }
                    })
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          formId = randomAlphaNumeric(5);
          DateTime currentTime = DateTime.now();
          String cdt = currentTime.day.toString() +
              " : " +
              currentTime.month.toString() +
              " : " +
              currentTime.year.toString();
          Map<String, dynamic> myform = {
            "formId": formId,
            "formName": formName,
            "formDesc": formDesc,
            "formData": formfieldlist,
            "email": useremail,
            "date": cdt
          };
          ShowAlertDialogs showAlertDialogs = new ShowAlertDialogs();

          await databaseService.addForm(myform, formId).then((value) {
            showAlertDialogs.showAlertDialog(
                context, "Form successfully created");
            Navigator.pop(context);
            // Navigator.pushReplacement(
            //     context, MaterialPageRoute(builder: (context) => FormDash()));
            Navigator.pushNamed(context, '/Dash');
          }).catchError((e) {
           
            showAlertDialogs.showAlertDialog(
                context, "Your Internet connection is slow");
          });
          formfieldlist.clear();
        },
        label: const Text('Submit'),
        icon: const Icon(Icons.thumb_up),
        backgroundColor: Colors.pink,
      ),
    );
  }

  //Form Name and Desc===========================
  _showDialog() {
    showDialog<String>(
      context: context,
      builder: (context) {
        return Container(
          child: new AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: new ListView(
              shrinkWrap: true,
              children: [
                Column(
                  children: <Widget>[
                    new TextField(
                      autofocus: true,
                      decoration: new InputDecoration(
                          labelText: 'Enter FormName', hintText: ''),
                      onChanged: (val) {
                        if (val != "") {
                          setState(() {
                            formName = val;
                          });
                        }
                      },
                    ),
                    new TextField(
                      autofocus: true,
                      decoration: new InputDecoration(
                          labelText: 'Enter Form Description', hintText: ''),
                      onChanged: (val) {
                        if (val != "") {
                          setState(() {
                            formDesc = val;
                          });
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
            actions: <Widget>[
              new ElevatedButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new ElevatedButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          ),
        );
      },
    );
  }

  Widget mytextfield() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter field value',
            hintText: '',
          ),
          autofocus: true,
          enableSuggestions: true,
          controller: eCtrl,
          onChanged: (val) {
            if (formDesc == "" || formName == "") {
              _showDialog();
            }
          },
          onSubmitted: (text) {
            if (text != "") {
              formfieldlist.add({"value": text, "type": "textfield"});
              eCtrl.clear();
              setState(() {
                selectedfield = "textfield";
              });
            }
          }),
    );
  }
}

class Mych extends StatefulWidget {
  @override
  _MychState createState() => _MychState();
}

class _MychState extends State<Mych> {
  List<String> checklist = [];
  Map<String, dynamic> checkmap = {};
  bool checking = true;

  final TextEditingController eCtrl = new TextEditingController();
  String cfield = "cfield";
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 250.0,
      color: Colors.white,
      child: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(15),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: ' Enter Title For Multiselect',
              hintText: '',
            ),
            onSubmitted: (text) {
              checkmap.addAll({"heading": text, "type": "checkbox"});
            },
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: checklist.length + 1,
            itemBuilder: (BuildContext ctxt, int index) {
              try {
                if (cfield == "cfield") {
                  return Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter options',
                        hintText: '',
                      ),
                      autofocus: true,
                      onSubmitted: (text) {
                        checklist.add(text);
                        eCtrl.clear();
                        setState(() {
                          cfield = "cfield";
                        });
                      },
                    ),
                  );
                } else {
                  return Container();
                }
              } catch (e) {
                return Container();
              }
            }),
        Container(
          padding: EdgeInsets.all(5),
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
            onPressed: () {
              if (checking) {
                checkmap.addAll({"value": checklist});

                Map<String, dynamic> somevar = checkmap;
                formfieldlist.add(somevar);
                print(formfieldlist);
                setState(() {
                  selectedfield = "textfield";
                  checking = false;
                });
              }
            },
            child: Text("Done"),
          ),
        ),
      ]),
    );
  }
}

class MyRadiobox extends StatefulWidget {
  @override
  _MyRadioboxState createState() => _MyRadioboxState();
}

class _MyRadioboxState extends State<MyRadiobox> {
  List<String> radiolist = [];
  Map<String, dynamic> radiomap = {};
  bool checking = true;

  final TextEditingController eCtrl = new TextEditingController();
  String radiofield = "radiofield";
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 250.0,
      color: Colors.white,
      child: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(15),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: ' Enter Some Thing',
              hintText: '',
            ),
            onSubmitted: (text) {
              radiomap.addAll({"heading": text, "type": "radiobox"});
            },
          ),
        ),
        // Expanded(
        //     child:
        new ListView.builder(
            shrinkWrap: true,
            itemCount: radiolist.length + 1,
            itemBuilder: (BuildContext ctxt, int index) {
              try {
                if (radiofield == "radiofield") {
                  return Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter options',
                        hintText: '',
                      ),
                      autofocus: true,
                      onSubmitted: (text) {
                        radiolist.add(text);
                        eCtrl.clear();
                        setState(() {
                          radiofield = "radiofield";
                        });
                      },
                    ),
                  );
                } else {
                  return Container();
                }
              } catch (e) {
                return Container();
              }
            }),
        Container(
          padding: EdgeInsets.all(5),
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
            onPressed: () {
              if (checking) {
                radiomap.addAll({"value": radiolist});

                Map<String, dynamic> somevar = radiomap;
                formfieldlist.add(somevar);

                setState(() {
                  selectedfield = "textfield";
                  checking = false;
                });
              }
            },
            child: Text("Done"),
          ),
        ),
      ]),
    );
  }
}
