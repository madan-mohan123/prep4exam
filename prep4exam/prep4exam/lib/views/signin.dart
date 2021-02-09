import 'package:flutter/material.dart';
import 'package:prep4exam/services/auth.dart';
import 'package:prep4exam/widgets/widgets.dart';
import 'package:prep4exam/views/signup.dart';
import 'package:prep4exam/views/home.dart';

class Signin extends StatefulWidget {
  @override
  _SiginState createState() => _SiginState();
}

class _SiginState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();
  String email, password;
  AuthServices authServices = new AuthServices();
  bool _isLoading = false;

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
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: appBar(context),
          backgroundColor: Colors.transparent,
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
                          return val.isEmpty ? "Enter correct password" : null;
                        },
                        decoration: InputDecoration(hintText: "Password"),
                        onChanged: (val) {
                          password = val;
                        },
                      ),

                      SizedBox(
                        height: 150,
                      ),

                      //  for sign in button
                      GestureDetector(
                        onTap: () {
                          signin();
                        },
                        child: Container(
                          alignment: Alignment.center,

                          padding: EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          // fro takin complete width
                          width: MediaQuery.of(context).size.width - 48,
                          child: Text(
                            "Sign in",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
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
                        height: 80,
                      ),
                    ],
                  ),
                ),
              ));
  }
}
