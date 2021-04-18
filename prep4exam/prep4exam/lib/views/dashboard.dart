import 'package:flutter/material.dart';
import 'package:prep4exam/helper/functions.dart';
import 'package:prep4exam/services/database.dart';
import 'package:prep4exam/views/Examportal/ExamDash.dart';
import 'package:prep4exam/views/Profile.dart';
import 'package:prep4exam/views/authentication/signin.dart';
import 'package:prep4exam/views/feedbackmodule/formdash.dart';
import 'package:prep4exam/widgets/widgets.dart';
import 'package:prep4exam/views/quiz/quizhome.dart';
import 'package:prep4exam/services/auth.dart';
import 'package:prep4exam/views/poll/polldashboard.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  AuthServices authServices = new AuthServices();
  DatabaseService databaseService = new DatabaseService();
  String useremail = "";
  Map<String, String> profileData = {};
  @override
  void initState() {
    authServices.getcurrentuser().then((value) {
      setState(() {
        useremail = value;
      });
    });

    databaseService.getProfile().then((value) {
      setState(() {
        profileData = value;
       
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
          title: appBar(context),
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          brightness: Brightness.light,
        ),
        drawer: Drawer(
          child:Container(
             color: Colors.blueGrey[800],
          child: ListView(
            children: [
              Container(
                color: Colors.blue[800],
              child:UserAccountsDrawerHeader(
                
                accountName: Text(profileData["name"]),
                accountEmail: Text(profileData["email"]),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.indigo[800],
                  child: Text(
                    useremail.substring(0, 1).toUpperCase(),
                    style: TextStyle(fontSize: 40.0),
                  ),
                ),
              ),
              ),
              Divider(
                height: 2.0,
              ),

              ListTile(
                title: Text(
                  "Exam Portal",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,),
                ),
                leading: Icon(Icons.save,color: Colors.deepOrange),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Examdash()));
                },
              ),
              ListTile(
                title: Text(
                  "Groups",
                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                ),
                leading: Icon(Icons.group_add,color: Colors.green),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  "Profile",
                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                ),
                leading: Icon(Icons.bolt,color: Colors.red),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Profile(userEmail: useremail)));
                },
              ),
              ListTile(
                title: Text(
                  "LogOut",
                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                ),
                leading: Icon(Icons.login_sharp,color: Colors.orangeAccent),
                onTap: () async {
                  HelperFunction.saveUserLoggedInDetails(isLoggedin: false);
                  await authServices.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Signin()));
                },
              ),
            ],
          ),),
        ),
        body: Container(
         
          padding: new EdgeInsets.all(0.0),
          child: ListView(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
                child: Container(
                  height: 170.00,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.cyan[600],
                    elevation: 10,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const ListTile(
                            leading: Icon(Icons.style_sharp,
                                size: 60, color: Colors.orangeAccent),
                            title: Text('Quiz Dash',
                                style: TextStyle(
                                    fontSize: 30.0, color: Colors.white)),
                            subtitle: Text('Create Your Quiz On Tips',
                                style: TextStyle(fontSize: 18.0)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PollDashboard()));
                },
                child: Container(
                  height: 170.00,
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.yellow[800],
                      elevation: 10,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const ListTile(
                              leading: Icon(Icons.school_outlined,
                                  size: 60, color: Colors.green),
                              title: Text('Polls Dash',
                                  style: TextStyle(
                                      fontSize: 30.0, color: Colors.white)),
                              subtitle: Text('Your Voting On Tips',
                                  style: TextStyle(fontSize: 18.0)),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FormDash()));
                },
                child: Container(
                  height: 170.00,
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.deepOrange[700],
                      elevation: 10,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const ListTile(
                              leading: Icon(Icons.stacked_line_chart_sharp,
                                  size: 60, color: Colors.blue),
                              title: Text('Form Dash',
                                  style: TextStyle(
                                      fontSize: 30.0, color: Colors.white)),
                              subtitle: Text('Create Your Feedback On Tips',
                                  style: TextStyle(fontSize: 18.0)),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Examdash()));
                  },
                  child: Container(
                    height: 170.00,
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.blue[700],
                        elevation: 10,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const ListTile(
                                leading: Icon(Icons.eco, size: 60),
                                title: Text('Exam Portal',
                                    style: TextStyle(
                                        fontSize: 30.0, color: Colors.white)),
                                subtitle: Text('Work With Team',
                                    style: TextStyle(fontSize: 18.0)),
                              ),
                            ],
                          ),
                        )),
                  )),
              GestureDetector(
                  onTap: () {
//  Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => Examdash()));
                  },
                  child: Container(
                    height: 170.00,
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.green,
                        elevation: 10,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const ListTile(
                                leading: Icon(Icons.group_add_outlined, size: 60),
                                title: Text('Make Groups',
                                    style: TextStyle(
                                        fontSize: 30.0, color: Colors.white)),
                                subtitle: Text('Work With Colab',
                                    style: TextStyle(fontSize: 18.0)),
                              ),
                            ],
                          ),
                        )),
                  )),
            ],
          ),
        ),
      );
    } catch (e) {
      print(e.toString());
      return Scaffold(
          body: Center(
              child: Container(
        child: CircularProgressIndicator(),
      )));
    }
  }
}
