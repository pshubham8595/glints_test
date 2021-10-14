import 'package:flutter/material.dart';
import 'package:glints_test/firebaseConfig/FirebaseConfig.dart';

class PostsListNotifier extends ChangeNotifier{
  Map<String,dynamic> userDetailMap = {};
  String name = "";
  String handle = "";
  String photoUrl = "";

  init(String email)async{
    await FirebaseConfig.getUserDetails(email).then((detailMap){
      handle = detailMap['handle'];
      name = detailMap['name'];
      photoUrl = detailMap['photoUrl'];
      notifyListeners();
    });
  }
}