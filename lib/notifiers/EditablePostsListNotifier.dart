import 'package:flutter/material.dart';
import 'package:glints_test/firebaseConfig/FirebaseConfig.dart';
import 'package:glints_test/widgets/EditTweet.dart';

class EditablePostsListNotifier extends ChangeNotifier{
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

  deletePost(String postId)async{
    await FirebaseConfig.deletePost(postId);
  }

  updatePost(String postId,String newTweet)async{
    await FirebaseConfig.updatePost(postId,newTweet);
  }


}