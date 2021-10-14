import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glints_test/firebaseConfig/FirebaseConfig.dart';
import 'package:glints_test/notifiers/HomePageNotifier.dart';
import 'package:glints_test/notifiers/PostsListNotifier.dart';
import 'package:glints_test/utils/Constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

class SingleTweet extends StatefulWidget {
  Map<String,dynamic> map = {};
  PostsListNotifier notifier;
  SingleTweet(this.map,this.notifier);
  @override
  _SingleTweetState createState() => _SingleTweetState();
}

class _SingleTweetState extends State<SingleTweet> {
  String userPhotoUrl = "https://images.unsplash.com/photo-1632686426956-5e5a5d790757?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=464&q=80";
  // String text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries.";
  String text = "";
  String userName = "Barista Dakvao";
  String userHandle = "@barista";
  DateTime timeOfTweet = DateTime.now();
  bool isLoading = true;
  Map<String,dynamic> map = {};

  @override
  void initState() {
   initialize();
   super.initState();
  }
  initialize()async{
    getData();
    widget.notifier.init(widget.map['email']);
    text = widget.map['tweet'];
    timeOfTweet = DateTime.fromMillisecondsSinceEpoch(widget.map['time']);
    setState(() {
      isLoading = false;
    });
  }

  getData()async{
    map = await FirebaseConfig.getUserDetails(widget.map['email']);
  }
  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.all(new Radius.circular(12)),
        boxShadow: [
          BoxShadow(color: Colors.black12,blurRadius: 7,spreadRadius: 2)
        ]
      ),
      width: MediaQuery.of(context).size.width * 0.92,
      height: MediaQuery.of(context).size.width * 0.6,//0.4
      child: isLoading || map['photoUrl'] == null?Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Constants.loader(),
          ),
        ],
      ):new Column(
        children: [
          new SizedBox(height: 15,),
          new Row(
            children: [
              new SizedBox(width: 10,),
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  map['photoUrl'],
                  scale: 1.0
                ),
              ),
              new SizedBox(width: 15,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    new AutoSizeText(map['name'],
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      minFontSize: 18,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),),
                    new AutoSizeText(map['handle'],
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      minFontSize: 15,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                      color: Color(0xff2fcdff),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),),
                  ],
                ),
              ),
              // new SizedBox(width: 25,),
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    new AutoSizeText(timeago.format(timeOfTweet).toString(),
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      minFontSize: 15,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                      color: Colors.black38,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),),
                  ],
                ),
              ),
              new SizedBox(width: 15,),
            ],
          ),
          new SizedBox(height: 5,),
          Row(
            children: [
              new SizedBox(width: 75,),
              Expanded(
                child: new Container(
                  child: new AutoSizeText(text,
                    textAlign: TextAlign.start,
                    maxLines: 8,
                    minFontSize: 18,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.w400,fontSize: 18,color: Colors.black87),),
                ),
              ),
              new SizedBox(width: 15,)
            ],
          ),
          new SizedBox(height: 05,),
        ],
      ),
    );
  }
}