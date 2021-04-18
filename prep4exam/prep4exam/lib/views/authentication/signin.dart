import 'package:flutter/material.dart';
import 'package:prep4exam/helper/functions.dart';
import 'package:prep4exam/services/auth.dart';
import 'package:prep4exam/views/dashboard.dart';
import 'package:prep4exam/widgets/widgets.dart';
import 'package:prep4exam/views/authentication/signup.dart';

class Signin extends StatefulWidget {
  @override
  _SiginState createState() => _SiginState();
}

class _SiginState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();
  String email, password;
  AuthServices authServices = new AuthServices();
  HelperFunction helperFunction = new HelperFunction();
  bool _isLoading = false;

  showAlertDialogForEmail(BuildContext context, String msg) {
    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Signup()));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title:
          Text("OOPs ! ", style: TextStyle(fontSize: 20.0, color: Colors.blue)),
      content: Text(msg),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  signin() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authServices.signInEmailAndPass(email, password).then((val) {
        if (val != null) {
          setState(() {
            _isLoading = false;
          });

          HelperFunction.saveUserLoggedInDetails(isLoggedin: true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
        } else {
          showAlertDialogForEmail(context, "Wrong Email or Passord");
        }
      }).catchError((e) {
        showAlertDialogForEmail(context, "Slow Internet Connection");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
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
                            return val.isEmpty
                                ? "Enter correct password"
                                : null;
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
                            signin();
                          },
                          child: blueButton(
                            context: context,
                            label: " Sign in",
                          ),
                        ),

                        SizedBox(
                          height: 18,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Dont have an account ? ",
                              style: TextStyle(fontSize: 15.5),
                            ),
                            GestureDetector(
                              onTap: () {
                                //funtion
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Signup()));
                              },
                              child: Text(
                                "Sign up",
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
    } catch (e) {
      return Scaffold(
          body: Container(
        child: Center(child: CircularProgressIndicator()),
      ));
    }
  }
}
