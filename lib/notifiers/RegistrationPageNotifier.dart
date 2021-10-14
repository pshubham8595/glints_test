import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glints_test/firebaseConfig/FirebaseConfig.dart';
import 'package:glints_test/pages/homePage.dart';
import 'package:glints_test/utils/Constants.dart';
import 'package:provider/provider.dart';

import 'HomePageNotifier.dart';

class RegistrationPageNotifier extends ChangeNotifier{
  bool handleIsAvailable = false;
  bool checkingAvailability = false;
  bool checkingForPreviousRegistration = false;
  bool isPreviousRegistred = false;
  bool isInitialCheckDone = false;


  Future checkForAvailability(String handle)async{
  checkingAvailability = true;
  notifyListeners();
   await FirebaseConfig.checkHandleAvailability(handle).then((isAvailable){
     handleIsAvailable = isAvailable;
     notifyListeners();
   });
  checkingAvailability = false;
  notifyListeners();

  }

  Future completeUserRegistration(String handle,User user,BuildContext context)async{
    checkingAvailability = true;
    notifyListeners();
     try{
       await FirebaseConfig.registerUserData(user, handle);
     }
     catch(e){
        print("Exception while registering user : $e");
       Constants.customSnackBar(content:"Something went wrong!",context: context);
     }
    checkingAvailability = false;
    notifyListeners();

  }

  Future checkIfUserIsRegisteredWithValidHandle(BuildContext context,User user)async{
    // checkingForPreviousRegistration = true;
    // isInitialCheckDone = true;
    // notifyListeners();
    await FirebaseConfig.checkForValidHandle(user.email).then((isHandleValid){
      if(isHandleValid){
        // Constants.customSnackBar(context: context,content: "Welcome user");
        this.dispose();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (_) => HomePageNotifier(),
              child: HomePage(user: user,),
            )));
      }
      else{
      }
      // notifyListeners();
    });
    // checkingForPreviousRegistration = false;
    // notifyListeners();

  }


}