import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prep4exam/models/User.dart';

class AuthServices {
  FirebaseUser loginUser;
  //instance
  FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null
        ? User(uid: user.uid, email: user.email, name: user.displayName)
        : null;
  }

  Future signInEmailAndPass(String email, String pass) async {
    try {
      AuthResult authResult =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);

      FirebaseUser firebaseUser = authResult.user;

      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future signUpWithEmailAndPassword(String email, String pass,String userName) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      FirebaseUser firebaseUser = authResult.user;


      //profile
      await Firestore.instance
          .collection("Profile")
          .add({
            "email": firebaseUser.email,
            "name":userName,
            "picUrl":""
            });

      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getcurrentuser() async {
    try {
      final user = await _auth.currentUser();

      if (user != null) {
        loginUser = user;
      }
      return loginUser.email;
    } catch (e) {
      print(e.toString());
    }
  }
}
