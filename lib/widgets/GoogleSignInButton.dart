
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glints_test/auth/Authentication.dart';
import 'package:glints_test/notifiers/RegistrationPageNotifier.dart';
import 'package:glints_test/pages/homePage.dart';
import 'package:glints_test/pages/registartionPage.dart';
import 'package:glints_test/utils/Constants.dart';
import 'package:glints_test/utils/customTheme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: _isSigningIn
          ? Constants.loader()
          : Container(
            // height: 60,
            // width: 225,
            child: ElevatedButton.icon(
                key:  Key('loginForm_googleLogin_raisedButton'),
                label:  Text(
                  'Sign in with Google',
                  style: GoogleFonts.roboto(color:CustomTheme.mainBackgroundColor,fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  padding: new EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: CustomTheme.mainBackgroundColor.withOpacity(0.5))
                  ),
                  primary: Colors.white,
                ),
                icon: Icon(FontAwesomeIcons.google, color: CustomTheme.mainBackgroundColor,size: 25,),
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });

                User user = await Authentication.signInWithGoogle(context: context);

                setState(() {
                  _isSigningIn = false;
                });

                if (user != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (_) => RegistrationPageNotifier(),
                        child: RegistrationPage(user: user,),
                      )));
                }
              },
            ),
          ),
    );
  }
}
