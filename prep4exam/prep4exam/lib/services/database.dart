import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> startQuiz(String quizId) async {
    await Firestore.instance
        .collection("Quiz")
        .document(quizId)
        .updateData({"flag": true}).catchError((e) {
      print(e.toString());
    });
  }

  Future<void> quizMarks(String quizId, String marks) async {
    await Firestore.instance
        .collection("JoinQuiz")
        .document(quizId)
        .updateData({"score": marks}).catchError((e) {
      print(e.toString());
    });
  }

  String useremail;
  String marks;
  Future getquizMarks(String quizId) async {
    try {
      await authServices.getcurrentuser().then((val) {
        useremail = val;
      });

      await Firestore.instance
          .collection("JoinQuiz")
          .where('email', isEqualTo: useremail)
          .where('quizId', isEqualTo: quizId)
          .getDocuments()
          .then((value) {
        value.documents.forEach((documentSnapshot) {
          // print("ooooooooooooooo");
          marks = documentSnapshot["score"].toString();
        });
      });

      if (marks != null) {
        return marks;
      } else {
        return "0";
      }
    } catch (e) {
      return "0";
    }
  }

  AuthServices authServices = new AuthServices();

  // List<Stream> listst;
  Future<List> getQuizezData() async {
    authServices.getcurrentuser().then((val) {
      useremail = val;
    });
    print("kkkkkkkkkk");
    print(useremail);

    QuerySnapshot questionSnapshot =
        await Firestore.instance.collection("JoinQuiz").getDocuments();
    var list = [];

    for (int i = 0; i < questionSnapshot.documents.length; i++) {
      print("kkkkkkkkkk");
      print(useremail);
      if (questionSnapshot.documents[i].data["email"] == useremail) {
        list.add(questionSnapshot.documents[i].data["quizId"].toString());
      }
    }

    return list;
  }

  Future<List> getScore(String quizId) async {
    List<Map<String, String>> listOfColumns = [];

    QuerySnapshot questionSnapshot =
        await Firestore.instance.collection("JoinQuiz").getDocuments();
    for (int i = 0; i < questionSnapshot.documents.length; i++) {
      if (questionSnapshot.documents[i].data["quizId"] == quizId) {
        listOfColumns.add({
          "Email": questionSnapshot.documents[i].data["email"],
          "Score": questionSnapshot.documents[i].data["score"].toString(),
        });
      }
    }

    // print(listOfColumns);
    return listOfColumns;
  }

  getCurrentlyJoinedUser(String quizId) async {
    return Firestore.instance
        .collection("JoinQuiz")
        .where('quizId', isEqualTo: quizId)
        .snapshots();
  }

//quizez created
  getQuizezDataCreateBy() async {
    return Firestore.instance.collection("Quiz").snapshots();
  }

//quiz question
  getQuizData(String quizId) async {
    print(quizId);
    return await Firestore.instance
        .collection("Quiz")
        .document(quizId)
        .collection("QNA")
        .getDocuments();
  }

  Future<Map<String, dynamic>> getQuizDataById(String quizId) async {
    String useremail = "";

    await authServices.getcurrentuser().then((value) {
      useremail = value;
    });

    Map<String, dynamic> quizData = {};

    await Firestore.instance
        .collection("JoinQuiz")
        .where('quizId', isEqualTo: quizId)
        .where('email', isEqualTo: useremail)
        .getDocuments()
        .then((value) {
      value.documents.forEach((documentSnapshot) {
        quizData = Map<String, dynamic>.from(documentSnapshot.data);
      });
    });
    return quizData;
  }

  Future gettime(String quizId) async {
    try {
      int time = 0;
      print(quizId);
      await Firestore.instance
          .collection("Quiz")
          .document(quizId)
          .get()
          .then((value) {
        time = value.data["timer"];
      });
      if (time != 0) {
        return time;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

//join quiz
  Future joinQuiz(Map data, String quizId) async {
    await Firestore.instance.collection("JoinQuiz").add(data).catchError((e) {
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
    authServices.getcurrentuser().then((val) {
      useremail = val;
    });
    QuerySnapshot questionSnapshot =
        await Firestore.instance.collection("JoinPoll").getDocuments();
    var list = [];

    for (int i = 0; i < questionSnapshot.documents.length; i++) {
      if (questionSnapshot.documents[i].data["email"] == useremail) {
        list.add(questionSnapshot.documents[i].data["pollId"]);
      }
    }

    return list;
  }

  Future<List> getpollvoting(String pollId) async {
    List<int> pollvoting = [];
    int total = 0;
    int voting = 0;
    QuerySnapshot questionSnapshot =
        await Firestore.instance.collection("JoinPoll").getDocuments();
    for (int i = 0; i < questionSnapshot.documents.length; i++) {
      if (questionSnapshot.documents[i].data["pollId"] == pollId) {
        total++;
        if (questionSnapshot.documents[i].data["voting"] != "") {
          voting++;
        }
      }
    }
    pollvoting.add(total);
    pollvoting.add(voting);
    // print("rrrrrr");
    // print(pollvoting);

    return pollvoting;
  }

  getpollResult(String pollId) async {
    return Firestore.instance.collection("JoinPoll").snapshots();
  }

  //===================================================

  Future<void> addForm(Map formData, String formId) async {
    await Firestore.instance.collection("Forms").add(formData).catchError((e) {
      print(e.toString());
    });
  }

  getAllForms() async {
    return Firestore.instance.collection("Forms").snapshots();
  }

  Future<List> getFormIds() async {
    await authServices.getcurrentuser().then((val) {
      useremail = val;
    });

    QuerySnapshot questionSnapshot =
        await Firestore.instance.collection("FormJoin").getDocuments();
    List<String> list = [];

    for (int i = 0; i < questionSnapshot.documents.length; i++) {
      if (questionSnapshot.documents[i].data["email"] == useremail) {
        list.add(questionSnapshot.documents[i].data["formId"].toString());
      }
    }
    print(list);
    return list;
  }

  Future getForm(String formId) async {
    QuerySnapshot questionSnapshot =
        await Firestore.instance.collection("Forms").getDocuments();

    for (int i = 0; i < questionSnapshot.documents.length; i++) {
      if (questionSnapshot.documents[i].data["formId"] == formId) {
        return questionSnapshot.documents[i].data["formData"];
        // return questionSnapshot.documents[i];
      }
    }
  }

  Future<void> saveFormResponse(Map formData, String email, String formid,
      String title, String formDesc) async {
    try {
      Map<String, dynamic> list = {};
      list.addAll(Map<String, dynamic>.from(formData));

      print(Map<String, dynamic>.from(formData));
      await Firestore.instance
          .collection("FormJoin")
          .where('email', isEqualTo: email)
          .where('formId', isEqualTo: formid)
          .getDocuments()
          .then((value) {
        value.documents.forEach((documentSnapshot) {
          documentSnapshot.reference.updateData(
              {"response": list, "formName": title, "formDesc": formDesc});
        });
      }).catchError((e) {
        print(e.toString());
      });
    } catch (e) {
      print("llllllllllllll");
      print(e.toString());
    }
  }

  Future<Map<String, dynamic>> getFormWithEmail(
      String formId, String email) async {
    Map<String, dynamic> map;

    QuerySnapshot questionSnapshot =
        await Firestore.instance.collection("FormJoin").getDocuments();

    for (int i = 0; i < questionSnapshot.documents.length; i++) {
      if (questionSnapshot.documents[i].data["formId"] == formId &&
          questionSnapshot.documents[i].data["email"] == email) {
        map.addAll(questionSnapshot.documents[i].data["response"]);
      }
    }
    print(map);
    return map;
  }

  Future<List<Map<String, dynamic>>> getJoinedForm(String formId) async {
    // Map<String, dynamic> map;
    List<Map<String, dynamic>> formlist = [];
    QuerySnapshot questionSnapshot =
        await Firestore.instance.collection("FormJoin").getDocuments();

    for (int i = 0; i < questionSnapshot.documents.length; i++) {
      if (questionSnapshot.documents[i].data["formId"] == formId) {
        formlist
            .add(Map<String, dynamic>.from(questionSnapshot.documents[i].data));
      }
    }

    return formlist;
  }

  //Exam==================================================
  Future<void> addExam(Map<String, dynamic> examData) async {
    await Firestore.instance.collection("Exams").add(examData).catchError((e) {
      print(e.toString());
    });
  }

  Future<void> joinExam(Map<String, dynamic> examData) async {
    await Firestore.instance
        .collection("ExamJoin")
        .add(examData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future showcreatedExam() async {
    return Firestore.instance.collection("Exams").snapshots();
  }

  Future<List> getjoinexamIds() async {
    await authServices.getcurrentuser().then((val) {
      useremail = val;
    });

    QuerySnapshot questionSnapshot =
        await Firestore.instance.collection("ExamJoin").getDocuments();
    List<String> list = [];

    for (int i = 0; i < questionSnapshot.documents.length; i++) {
      if (questionSnapshot.documents[i].data["email"] == useremail) {
        list.add(questionSnapshot.documents[i].data["examId"].toString());
      }
    }
    // print("pppppppppppp");
    // print(list);
    return list;
  }

  Future<Map<String, dynamic>> takeExam(String examId) async {
    Map<String, dynamic> examdata = {};

    await Firestore.instance
        .collection("Exams")
        .where("examid", isEqualTo: examId)
        .getDocuments()
        .then((value) {
      value.documents.forEach((documentSnapshot) {
        examdata = Map<String, dynamic>.from(documentSnapshot.data);
        // examdata.addAll(other)
      });
    });

    return examdata;
  }

  Future<Map<String, dynamic>> copyPickForCheck(
      String examId, String email) async {
    Map<String, dynamic> examdata = {};
    await Firestore.instance
        .collection("ExamJoin")
        .where("examid", isEqualTo: examId)
        .where("email", isEqualTo: email)
        .getDocuments()
        .then((value) {
      value.documents.forEach((documentSnapshot) {
        examdata = Map<String, dynamic>.from(documentSnapshot.data);
      });
    });

    return examdata;
  }

  Future examParticipants(String examId) async {
    return Firestore.instance
        .collection("ExamJoin")
        .where('examId', isEqualTo: examId)
        .snapshots();
  }

  Future<List<Map<String, dynamic>>> copyLis(String examId) async {
    List<Map<String, dynamic>> examdata = [];
    await Firestore.instance
        .collection("ExamJoin")
        .where("examId", isEqualTo: examId)
        .getDocuments()
        .then((value) {
      value.documents.forEach((documentSnapshot) {
        examdata.add(Map<String, dynamic>.from(documentSnapshot.data));
      });
    });

    return examdata;
  }

  Future editExamInfo(String examId, String examName, String examDuration,
      DateTime examDate, DateTime examStartTime) async {
    await Firestore.instance
        .collection("Exams")
        .where("examid", isEqualTo: examId)
        .getDocuments()
        .then((value) {
      value.documents.forEach((documentSnapshot) {
        documentSnapshot.reference.updateData({
          "examname": examName,
          "examDuration": examDuration,
          "examDate": examDate,
          "examstartTime": examStartTime
        });
      });
    });
  }

  ///Profilr=============

  Future updateProfile(String email, String imgUrl, String name) async {
    await Firestore.instance
        .collection("Profile")
        .where("email", isEqualTo: email)
        .getDocuments()
        .then((value) {
      value.documents.forEach((documentSnapshot) {
        documentSnapshot.reference.updateData({"picUrl": imgUrl, "name": name});
      });
    });
  }

  Future<Map<String, String>> getProfile() async {
    String email = "";
    await authServices.getcurrentuser().then((value) {
      email = value;
    });


    Map<String, String> data = {};
    await Firestore.instance
        .collection("Profile")
        .where("email", isEqualTo: email)
        .getDocuments()
        .then((value) {
      value.documents.forEach((documentSnapshot) {
        data = Map<String, String>.from(documentSnapshot.data);
      });
    });

    return data;
  }
}
