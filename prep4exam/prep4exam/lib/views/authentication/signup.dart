import 'package:flutter/material.dart';
import 'package:prep4exam/views/dashboard.dart';
import 'package:prep4exam/views/authentication/signin.dart';
import 'package:prep4exam/services/auth.dart';
import 'package:prep4exam/widgets/widgets.dart';
// import 'package:prep4exam/views/home.dart';
import 'package:prep4exam/helper/functions.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  String email, password, name;
  bool _isLoading = false;
  AuthServices authServices = new AuthServices();

  signUp() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      authServices.signUpWithEmailAndPassword(email, password,name).then((val) {
        if (val != null) {
          setState(() {
            _isLoading = false;
          });
          HelperFunction.saveUserLoggedInDetails(isLoggedin: true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appBar(context),
           backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          brightness: Brightness.light,
        ),
        body: _isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Spacer(),

                      TextFormField(
                        validator: (val) {
                          return val.isEmpty ? "Enter Name ? " : null;
                        },
                        decoration: InputDecoration(hintText: "Username"),
                        onChanged: (val) {
                          name = val;
                        },
                      ),
                      SizedBox(
                        height: 6,
                      ),

                      TextFormField(
                        validator: (val) {
                          return val.isEmpty ? "Enter correct email" : null;
                        },
                        decoration: InputDecoration(hintText: "Email"),
                        onChanged: (val) {
                          email = val;
                        },
                      ),
                      SizedBox(
                        height: 6,
                      ),

                      TextFormField(
                        obscureText: true,
                        validator: (val) {
                          return val.isEmpty ? "Enter correct password" : null;
                        },
                        decoration: InputDecoration(hintText: "Password"),
                        onChanged: (val) {
                          password = val;
                        },
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      //  for sign in button
                      GestureDetector(
                        onTap: () {
                          //funtion
                          signUp();
                        },
                        child: blueButton(
                          context: context,
                          label: " Sign up",
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account ? ",
                            style: TextStyle(fontSize: 15.5),
                          ),
                          GestureDetector(
                            onTap: () {
                              //funtion
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Signin()));
                            },
                            child: Text(
                              "Sign in",
                              style: TextStyle(
                                  fontSize: 15.5,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ));
  }
}
