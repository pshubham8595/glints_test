import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glints_test/notifiers/RegistrationPageNotifier.dart';
import 'package:glints_test/utils/Constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  User user;

  RegistrationPage({this.user});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  RegistrationPageNotifier notifier;
  TextEditingController _handleTextEditingController = new TextEditingController();


  @override
  void dispose() {
    notifier.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    notifier  = Provider.of<RegistrationPageNotifier>(context);
    if(!notifier.isInitialCheckDone){
      notifier.checkIfUserIsRegisteredWithValidHandle(context, widget.user);
    }
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: "twitter_logo",
                          child: Image.asset(
                            'assets/Twitter-Logo.png',
                            width: 75,
                            color: Color(0xff2fcdff),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ],
                    ),
                    new SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: "twitter_text",
                          child: Image.asset(
                            'assets/twitter_text.png',
                            width: 150,
                            // color: CustomTheme.mainBackgroundColor,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(child: new Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new AutoSizeText("Lets make you unique throughout our ecosystem ",textAlign: TextAlign.center,style: GoogleFonts.montserrat(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w400),),
                  ],
                ),
                new SizedBox(height: 20,),
                handleTextField(),
                new SizedBox(height: 10,),
                showCheckButton(),
                new SizedBox(height: 20,),
                proceedButton()
              ],))
            ],
          ),
        ),
      ),
    );
  }

  proceedButton(){
    return notifier.checkingAvailability?Constants.loader():notifier.handleIsAvailable?FloatingActionButton(onPressed: ()async{
      await notifier.completeUserRegistration(_handleTextEditingController.text,widget.user,context);
    },backgroundColor: Color(0xff2fcdff),child: new Icon(FontAwesomeIcons.arrowRight,color: Colors.white,)):new Container();
  }

  showCheckButton(){
    return  ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Colors.redAccent,
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      onPressed: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        if(_handleTextEditingController.text.isEmpty){
          Constants.customSnackBar(content:"Handle is mandatory",context: context);
        }
        else if(_handleTextEditingController.text == "NA"){
          Constants.customSnackBar(content:"Handle not allowed",context: context);
        }
        else{
          await notifier.checkForAvailability(_handleTextEditingController.text,).whenComplete(() {
            Constants.customSnackBar(content: notifier.handleIsAvailable?"This handle is available":"Not available",context: context);
          });
        }
      },
      child: Padding(
        padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
        child: Text(
          'Check availability',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
  handleTextField(){
    return  new Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50,
      decoration: new BoxDecoration(
          color: Color(0xfff1f1f1),
          borderRadius:
          new BorderRadius.all(new Radius.circular(12))),
      child: new TextFormField(
        controller: _handleTextEditingController,
        minLines: 1,
        maxLines: 1,
        cursorColor:Color(0xff2fcdff),
        onChanged: (text)async{

        },
        style: GoogleFonts.montserrat(
            color: Color(0xff2fcdff), fontWeight: FontWeight.w700, fontSize: 21),
        decoration: new InputDecoration(
            prefixIcon: new Icon(FontAwesomeIcons.at,color: Color(0xff2fcdff),),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.only(
                left: 15, bottom: 15, top: 15, right: 15),
            hintText: "Enter your desired handle",
            hintStyle: GoogleFonts.montserrat(
                color: Colors.black54,
                fontWeight: FontWeight.w400,
                fontSize: 21)),
      ),
    );
  }
}
