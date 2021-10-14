import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glints_test/notifiers/EditablePostsListNotifier.dart';
import 'package:glints_test/notifiers/HomePageNotifier.dart';
import 'package:glints_test/utils/Constants.dart';
import 'package:google_fonts/google_fonts.dart';

class EditTweetModalSheet extends StatefulWidget {
  String postId = "";
  String tweet = "";
  EditablePostsListNotifier editablePostsListNotifier;
  EditTweetModalSheet(this.postId,this.tweet,this.editablePostsListNotifier);
  @override
  _EditTweetModalSheetState createState() => _EditTweetModalSheetState();
}

class _EditTweetModalSheetState extends State<EditTweetModalSheet> {

  TextEditingController _tweetTextEditingController = new TextEditingController();
  int tweetCharacters = 0;
  bool showErrorMessage = false;
  String error = "Reached Maximum count";
  @override
  void initState() {
    _tweetTextEditingController = new TextEditingController(text:  widget.tweet);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: new BoxDecoration(color: Colors.white,
              borderRadius: new BorderRadius.only(topRight: new Radius.circular(30),topLeft: new Radius.circular(30))),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new AutoSizeText("Post Tweet",style: GoogleFonts.montserrat(color: Color(0xff2fcdff),fontSize: 22,fontWeight: FontWeight.w700),),
                  ],
                ),
                new SizedBox(height: 10,),
                Row(
                  children: [
                    new SizedBox(width: 20,),
                    new AutoSizeText("Write below",style: GoogleFonts.montserrat(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w400),),
                  ],
                ),
                new SizedBox(height: 10,),
                new Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: new BoxDecoration(
                      color: Color(0xfff1f1f1),
                      borderRadius:
                      new BorderRadius.all(new Radius.circular(12))),
                  padding: new EdgeInsets.only(top: 12,bottom: 12),
                  child: new TextFormField(
                    controller: _tweetTextEditingController,
                    minLines: 1,
                    maxLines: 20,
                    cursorColor: Colors.black,
                    onChanged: (text)async{
                      setState(() {
                        tweetCharacters = text.length;
                      });
                      if(text.length>=280){
                        print(tweetCharacters);
                        if(!showErrorMessage){
                          setState(() {
                            showErrorMessage = true;
                          });
                        }
                      }
                      else{
                        setState(() {
                          showErrorMessage = false;
                        });
                      }
                    },
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(280),
                    ],
                    style: GoogleFonts.montserrat(
                        color: Colors.black, fontWeight: FontWeight.w400, fontSize: 21),
                    decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 0, top: 0, right: 15),
                        hintText: "Let your thoughts reach to infinity...",
                        hintStyle: GoogleFonts.montserrat(
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                            fontSize: 21)),
                  ),
                ),
                new SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    showErrorMessage?Expanded(child: Text('$error',textAlign: TextAlign.center,style: GoogleFonts.montserrat(color: Colors.red,fontWeight: FontWeight.w700,fontSize: 15),)):new Container(),
                    new SizedBox(width: 15,),
                    Text('${tweetCharacters.toString()}/280',style: GoogleFonts.montserrat(color: Colors.black38,fontWeight: FontWeight.w400,fontSize: 12),),
                    new SizedBox(width: 15,)
                  ],
                ),
                new SizedBox(height: 15,),
                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      color: Color(0xff2fcdff),
                      borderRadius: new BorderRadius.all(new Radius.circular(8)),
                      child: InkWell(
                        splashColor: Colors.black12,
                        onTap: ()async{
                          if(_tweetTextEditingController.text.isEmpty){
                            setState(() {
                              error = "Tweet can't be empty!";
                              showErrorMessage = true;
                            });
                            await Future.delayed(new Duration(seconds: 3)).whenComplete(()async{
                              setState(() {
                                showErrorMessage = false;
                              });
                            });
                          }
                          else{
                            // await widget.homePageNotifier.addTweet(_tweetTextEditingController.text);
                            await widget.editablePostsListNotifier.updatePost(widget.postId,_tweetTextEditingController.text);
                            _tweetTextEditingController.clear();
                            FocusScope.of(context).unfocus();
                            Navigator.pop(context);
                            Constants.customSnackBar(context: context,content: "Tweet Updated");
                          }
                        },
                        borderRadius: new BorderRadius.all(new Radius.circular(8)),
                        child: Ink(
                          decoration: new BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: new BorderRadius.all(new Radius.circular(8)),
                          ),
                          child: new Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 45,
                            decoration: new BoxDecoration(
                                boxShadow: [
                                  new BoxShadow(
                                      color: Colors.black12,
                                      spreadRadius: 3,
                                      blurRadius:6
                                  )
                                ],
                                borderRadius: new BorderRadius.all(new Radius.circular(8))
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                new Text("Update Tweet",style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.w700,color: Colors.white),),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
