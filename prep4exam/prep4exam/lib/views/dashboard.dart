import 'package:flutter/material.dart';
import 'package:prep4exam/helper/functions.dart';
import 'package:prep4exam/views/quiz/join_quiz.dart';
import 'package:prep4exam/views/authentication/signin.dart';
import 'package:prep4exam/widgets/widgets.dart';
import 'package:prep4exam/views/quiz/home.dart';
import 'package:prep4exam/services/auth.dart';
import 'package:prep4exam/views/poll/polldashboard.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  AuthServices authServices = new AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[400],
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.red,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.all(0.0),
              child: Container(
                  // decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                  padding: EdgeInsets.all(10),
                  height: 100.0,
                  color: Colors.indigo[800],
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    children: [
                      Text(
                        "Madan Mohan",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Madan@gmail.com",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )),
            ),
            Divider(
              height: 2.0,
            ),
            ListTile(
              title: Text(
                "Account",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Icon(Icons.settings_applications),
            ),
            ListTile(
              title: Text(
                "Join Quiz",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Icon(Icons.save),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => JoinQuiz()));
              },
            ),

            ListTile(
              title: Text(
                "Show Join",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Icon(Icons.save),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>JoinQuizList()));
              },
            ),

            ListTile(
              title: Text(
                "LogOut",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Icon(Icons.login_sharp),
              onTap: () {
                HelperFunction.saveUserLoggedInDetails(isLoggedin: false);
                authServices.signOut();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Signin()));
              },
            ),
          ],
        ),
      ),


      
      body: Container(
        padding: new EdgeInsets.all(10.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
              child: Container(
                height: 150.00,
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
                          leading: Icon(Icons.album, size: 60),
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
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => PollDashboard()));
              },    
           child: Container(
              height: 150.00,
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
                          leading: Icon(Icons.album, size: 60),
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
            Container(
              height: 150.00,
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
                          leading: Icon(Icons.album, size: 60),
                          title: Text('FeedBack Dash',
                              style: TextStyle(
                                  fontSize: 30.0, color: Colors.white)),
                          subtitle: Text('Create Your Feedback On Tips',
                              style: TextStyle(fontSize: 18.0)),
                        ),
                      ],
                    ),
                  )),
            ),
            Container(
              height: 150.00,
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
                          leading: Icon(Icons.album, size: 60),
                          title: Text('Quiz DashBoard',
                              style: TextStyle(
                                  fontSize: 30.0, color: Colors.white)),
                          subtitle: Text('Create Your Quiz On Tips',
                              style: TextStyle(fontSize: 18.0)),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
