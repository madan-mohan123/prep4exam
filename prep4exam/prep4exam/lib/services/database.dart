import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:prep4exam/services/auth.dart';

class DatabaseService {
  Future<void> addQuizData(Map quizData, String quizId) async {
    await Firestore.instance
        .collection("Quiz")
        .document(quizId)
        .setData(quizData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addQuestionData(Map questionData, String quizId) async {
    await Firestore.instance
        .collection("Quiz")
        .document(quizId)
        .collection("QNA")
        .add(questionData)
        .catchError((e) {
      print(e.toString());
    });
  }

  AuthServices authServices = new AuthServices();
  String useremail;

  // List<Stream> listst;
  Future<List> getQuizezData() async {
    authServices.getcurrentuser().then((val) {
      useremail = val;
    });

    QuerySnapshot questionSnapshot =
        await Firestore.instance.collection("JoinQuiz").getDocuments();
    var list = [];

    for (int i = 0; i < questionSnapshot.documents.length; i++) {
      if (questionSnapshot.documents[i].data["email"] == useremail) {
        list.add(questionSnapshot.documents[i].data["quizId"]);
      }
    }

    return list;
  }

//quizez created
  getQuizezDataCreateBy() async {
    return Firestore.instance.collection("Quiz").snapshots();
  }

//quiz question
  getQuizData(String quizId) async {
    return await Firestore.instance
        .collection("Quiz")
        .document(quizId)
        .collection("QNA")
        .getDocuments();
  }

//join quiz
  Future joinQuiz(Map data, String quizId) async {
    await Firestore.instance
        .collection("JoinQuiz")
        .document(quizId)
        .setData(data)
        .catchError((e) {
      print(e.toString());
    });
  }

//create quiz
  Future createPoll(Map polldata, String pollId) async {
    await Firestore.instance
        .collection("pollcreate")
        .document(pollId)
        .setData(polldata)
        .catchError((e) {
      print(e.toString());
    });
  }

  // get poll data
  getPollData() async {
    return Firestore.instance.collection("pollcreate").snapshots();
  }

  getPollJoinList() async {
    QuerySnapshot questionSnapshot =
        await Firestore.instance.collection("JoinPoll").getDocuments();
    var list = [];

    for (int i = 0; i < questionSnapshot.documents.length; i++) {
      if (questionSnapshot.documents[i].data["email"] == "madan@gmail.com") {
        list.add(questionSnapshot.documents[i].data["pollId"]);
      }
    }

    return list;
  }
}
