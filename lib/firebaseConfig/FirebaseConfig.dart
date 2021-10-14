import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:glints_test/models/postDataModel.dart';

class FirebaseConfig{
  static CollectionReference collectionReference = FirebaseFirestore.instance.collection("Posts");
  static Future<bool> registerUserData(User user,String handle) async {
    bool success = false;
    Map<String, dynamic> map =  {};
    map = {
      "email": user.email,
      "name": user.displayName,
      "photoUrl": user.photoURL,
      "handle": handle,
    };

    bool userExistsStatus = await checkUserAlreadyRegistered(user.email);
    print("User Registered");
    if(userExistsStatus){
      print("Old User Updated");
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(map['email']).update(map).then((snapShot) async {
        success = true;
      });
    }
    else{
      print("New User Registered");
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(map['email']).set(map).then((snapShot) async {
        success = true;
      });
    }
    return success;
  }

  static Future<bool> checkUserAlreadyRegistered(String email) async {
    bool userExistsStatus = false;

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(email).get().then((docData) {
      if (docData.exists) {
        print("Exsisting handle${docData["handle"]}");
        userExistsStatus = true;
      }
      else {
        userExistsStatus = false;
      }
    });
    return userExistsStatus;
  }

  static Future<bool> checkForValidHandle(String email) async {
    bool handleIsValid = false;

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(email).get().then((docData) {
      if (docData.exists && docData["handle"]!="NA") {
        handleIsValid = true;
      }
      else {
        handleIsValid = false;
      }
    });
    return handleIsValid;
  }

  static Future<bool> updateHandle(String email,String handle) async {
    bool success = false;
    Map<String, dynamic> map =  {};
    map = {
      "handle": handle,
    };
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(map['email']).update(map).then((snapShot) async {
      success = true;
    });
    return success;
  }

  static Future<bool> checkHandleAvailability(String handleForChecking) async {
    int count = 0;
    await FirebaseFirestore.instance
        .collection("Users").get().then((value) {
      value.docs.forEach((element) {
        print("Checking for ${element.id}");
        if(element['handle'] == handleForChecking){
          count = count +1;
        }
        });
      });
    print("Handle found : $count : ${count==0}");
    return count==0;
  }

  static Future<String> getUserHandle(String email) async {
    String userHandle = "NA";
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(email).get().then((docData) {
      if (docData.exists) {
        userHandle = docData['handle'];
      }
    });
    return userHandle;
  }

  static Future addPost(Map<String,dynamic> dataMap,String email) async {

    await FirebaseFirestore.instance
        .collection("Posts")
        .doc(dataMap['postId']).set(dataMap).then((value){

    });
  }

  static Stream<QuerySnapshot> get posts{
    return  collectionReference.snapshots();
  }

  static Future<Map<String,dynamic>> getUserDetails(String email) async {
    Map<String,dynamic> map = {};
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(email).get().then((docData) {
      if (docData.exists) {
        map = docData.data();
      }
    });
    return map;
  }

  static Future deletePost(String postId) async {
    await FirebaseFirestore.instance
        .collection("Posts")
        .doc(postId).delete();
  }

  static Future updatePost(String postId,String tweet) async {
    await FirebaseFirestore.instance
        .collection("Posts")
        .doc(postId).update({"tweet":tweet});
  }


}