import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:glints_test/firebaseConfig/FirebaseConfig.dart';
import 'package:glints_test/notifiers/HomePageNotifier.dart';
import 'package:glints_test/notifiers/RegistrationPageNotifier.dart';
import 'package:glints_test/pages/homePage.dart';
import 'package:glints_test/pages/loginPage.dart';
import 'package:glints_test/pages/registartionPage.dart';
import 'package:glints_test/utils/Constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class Authentication {

  static Future<FirebaseApp> initializeFirebase({
     BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User user = FirebaseAuth.instance.currentUser;
    bool isHandleValid = await FirebaseConfig.checkForValidHandle(user.email);
    await Future.delayed(new Duration(seconds: 10)).whenComplete((){
      if (user != null) {
        if(isHandleValid){
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (_) => HomePageNotifier(),
                child: HomePage(user: user,),
              )));
        }

      }
      else{
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            LoginPage()), (Route<dynamic> route) => false);
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => ChangeNotifierProvider(
        //       create: (_) => RegistrationPageNotifier(),
        //       child: RegistrationPage(user: user,),
        //     )));
      }
    });
    return firebaseApp;
  }

  static Future<User> signInWithGoogle({ BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
        await auth.signInWithPopup(authProvider);

        user = userCredential.user;
        await FirebaseConfig.registerUserData(user, "NA");
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount googleSignInAccount =
      await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
          await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            // ...
          } else if (e.code == 'invalid-credential') {
            // ...
          }
        } catch (e) {
          // ...
            Constants.customSnackBar(
              content: 'Error signing out. Try again.',
                context: context
          );
        }
      }
    }

    return user;
  }


  static Future<void> signOut({ BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut().whenComplete(() {
        Constants.customSnackBar(
          content: 'User Signed out',
            context: context
        );
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                LoginPage()), (Route<dynamic> route) => false);
          });
    } catch (e) {
      Constants.customSnackBar(
        content: 'Error signing out. Try again.',
        context: context
      );
    }
  }

}