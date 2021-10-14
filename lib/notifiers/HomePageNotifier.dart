import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:glints_test/firebaseConfig/FirebaseConfig.dart';

class HomePageNotifier extends ChangeNotifier{
  String handle = "NA";
  String userEmail = "none";
  bool initializationDone = false;
  Timer _timer;
  User currentUser;


  initialize(User user){
    currentUser = user;
    getUserHandle(user.email);
  }


  getUserHandle(String email)async{
    await FirebaseConfig.getUserHandle(email).then((userHandle){
      handle = userHandle;
      userEmail = email;
      notifyListeners();
    });
  }

  addTweet(String tweet)async{
    Map<String,dynamic> map = {
      "postId": "${DateTime.now().millisecondsSinceEpoch}$handle",
      "tweet":tweet,
      "time":DateTime.now().millisecondsSinceEpoch,
      "email":userEmail
    };
    await FirebaseConfig.addPost(map,userEmail);
  }

}