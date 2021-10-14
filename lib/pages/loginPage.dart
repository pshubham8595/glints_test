
import 'package:flutter/material.dart';
import 'package:glints_test/auth/Authentication.dart';
import 'package:glints_test/utils/customTheme.dart';
import 'package:glints_test/widgets/GoogleSignInButton.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}



class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {

  bool _visible = false;
  AnimationController controller;
  Animation<Offset> offsetText;
  Animation<Offset> offsetLogo;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    offsetText = Tween<Offset>(begin: Offset(0.0,-2.0), end: Offset.zero)
        .animate(controller);
    offsetLogo = Tween<Offset>(begin: Offset(0.0,2.0), end: Offset.zero)
        .animate(controller);

    animate();
    controller.forward().then((value){
    });

  }

  animate()async{
   await Future.delayed(new Duration(milliseconds: 250)).whenComplete((){
      setState(() {
        _visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SlideTransition(
                          position: offsetLogo,
                          child: AnimatedOpacity(
                            // If the widget is visible, animate to 0.0 (invisible).
                            // If the widget is hidden, animate to 1.0 (fully visible).
                            opacity: _visible ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 750),
                            // The green box must be a child of the AnimatedOpacity widget.
                            child:Hero(
                              tag: "twitter_logo",
                              child: Image.asset(
                                'assets/Twitter-Logo.png',
                                width: 150,
                                color: Color(0xff2fcdff),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                        new SizedBox(height: 15,),
                        SlideTransition(
                          position: offsetText,
                          child: AnimatedOpacity(
                            // If the widget is visible, animate to 0.0 (invisible).
                            // If the widget is hidden, animate to 1.0 (fully visible).
                            opacity: _visible ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 750),
                            // The green box must be a child of the AnimatedOpacity widget.
                            child:Hero(
                              tag: "twitter_text",
                              child: Image.asset(
                                'assets/twitter_text.png',
                                width: 300,
                                // color: CustomTheme.mainBackgroundColor,
                                fit: BoxFit.fitWidth,

                              ),
                            ),
                          ),
                        )

                      ],
                    ),
                  ),
                  GoogleSignInButton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
