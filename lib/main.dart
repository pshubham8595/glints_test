import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:glints_test/notifiers/RegistrationPageNotifier.dart';
import 'package:glints_test/pages/homePage.dart';
import 'package:glints_test/pages/loginPage.dart';
import 'package:glints_test/pages/registartionPage.dart';
import 'package:glints_test/utils/customTheme.dart';
import 'package:glints_test/utils/utils.dart';
import 'package:glints_test/widgets/GoogleSignInButton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'auth/Authentication.dart';
import 'firebaseConfig/FirebaseConfig.dart';
import 'notifiers/HomePageNotifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: ChangeNotifierProvider(
        //   create: (_) => RegistrationPageNotifier(),
        //   child: RegistrationPage(),
        // ),
        home: SplashPage());
  }
}

class SplashPage extends StatefulWidget {
  SplashPage({
    Key key,
  }) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool showSplashImage = true;

  @override
  void initState() {
    super.initState();
    checkIfUserIsLoggedIn();
  }
  checkIfUserIsLoggedIn()async{
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User user = FirebaseAuth.instance.currentUser;
    print("User:$user");


      if (user != null) {
        bool isHandleValid = await FirebaseConfig.checkForValidHandle(user.email);
        await Future.delayed(new Duration(seconds: 10)).whenComplete((){

          if(isHandleValid){
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (_) => HomePageNotifier(),
                child: HomePage(user: user,),
              )));
        }
        });

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.mainBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: 20.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(alignment: Alignment.bottomCenter, children: [
                      new Image.asset(
                        "assets/twitterSplash.gif",
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.contain,
                      ),
                      new Image.network(
                        "https://clipart.info/images/ccovers/1534043159twitter-text-logo-png.png",
                        color: Colors.white,
                        width: 300,
                        fit: BoxFit.fitWidth,
                      ),
                    ]),
                  ],
                ),
              ),
            ),
            new Text(
              "Loading...",
              style: GoogleFonts.montserrat(
                  color: Colors.white, fontSize: 22),
            ),
            new Text(
              "v 1.0.0",
              style: GoogleFonts.montserrat(
                  color: Colors.white, fontSize: 12),
            ),
            new SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CustomTheme.mainBackgroundColor,
//       body: FutureBuilder(
//           future: Authentication.initializeFirebase(context: context),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Text('Error initializing Firebase');
//             } else if (snapshot.connectionState == ConnectionState.done) {
//
//               return new LoginPage();
//             }
//             return Padding(
//               padding: const EdgeInsets.only(
//                 left: 16.0,
//                 right: 16.0,
//                 bottom: 20.0,
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Expanded(
//                     child: Center(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.max,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Stack(alignment: Alignment.bottomCenter, children: [
//                             new Image.asset(
//                               "assets/twitterSplash.gif",
//                               height: 250,
//                               width: MediaQuery.of(context).size.width,
//                               fit: BoxFit.contain,
//                             ),
//                             new Image.network(
//                               "https://clipart.info/images/ccovers/1534043159twitter-text-logo-png.png",
//                               color: Colors.white,
//                               width: 300,
//                               fit: BoxFit.fitWidth,
//                             ),
//                           ]),
//                         ],
//                       ),
//                     ),
//                   ),
//                   new Text(
//                     "Loading...",
//                     style: GoogleFonts.montserrat(
//                         color: Colors.white, fontSize: 22),
//                   ),
//                   new Text(
//                     "v 1.0.0",
//                     style: GoogleFonts.montserrat(
//                         color: Colors.white, fontSize: 12),
//                   ),
//                   new SizedBox(
//                     height: 15,
//                   )
//                 ],
//               ),
//             );
//           }),
//     );
//   }
// }
