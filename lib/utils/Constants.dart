import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants{
  static const String USER_LOGGED_IN = "user_logged_in";

  static customSnackBar({String content,BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.black,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            content,
            style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700
            ),
          ),
        ],
      ),
    ));
  }

  static Widget loader(){
    return CircularProgressIndicator(
      strokeWidth: 5,
      backgroundColor: Colors.deepPurple,
    );
  }

}