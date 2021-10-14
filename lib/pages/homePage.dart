import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glints_test/firebaseConfig/FirebaseConfig.dart';
import 'package:glints_test/models/postDataModel.dart';
import 'package:glints_test/notifiers/HomePageNotifier.dart';
import 'package:glints_test/notifiers/PostsListNotifier.dart';
import 'package:glints_test/pages/profilePage.dart';
import 'package:glints_test/utils/Constants.dart';
import 'package:glints_test/utils/customTheme.dart';
import 'package:glints_test/widgets/addTweet.dart';
import 'package:glints_test/widgets/postsList.dart';
import 'package:glints_test/widgets/searchBar.dart';
import 'package:glints_test/widgets/singleTweet.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  User user;

  HomePage({this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{

  HomePageNotifier notifier;
  TextEditingController searchBarController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    notifier =  Provider.of<HomePageNotifier>(context);
    if(!notifier.initializationDone){
      notifier.initialize(widget.user);
    }
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Colors.white,

        body:TabBarView(
          children: [
            homePageTab(),
            profilePage()
          ],
        ),
        floatingActionButton: new FloatingActionButton(onPressed: showModalSheet,child: new Icon(FontAwesomeIcons.featherAlt,color: Colors.white,),backgroundColor: Color(0xff2fcdff),),
        bottomNavigationBar: menu(),
      ),
    );
  }

  Widget menu() {
    return Container(
      height: 60,
      color: Colors.white,
      child: TabBar(
        labelColor: Color(0xff2fcdff),
        unselectedLabelColor: Colors.black54,
        indicatorColor: Colors.transparent,
        automaticIndicatorColorAdjustment: true,
        unselectedLabelStyle: GoogleFonts.montserrat(color: Colors.black54,fontSize: 13,fontWeight: FontWeight.w400),
        labelStyle: GoogleFonts.montserrat(fontSize: 15,fontWeight: FontWeight.w700),
        tabs: [
          Tab(
            text: "Tweets",
            icon: Icon(FontAwesomeIcons.twitterSquare),
          ),
          Tab(
            text: "Profile",
            icon: Icon(FontAwesomeIcons.userAlt),
          ),

        ],
      ),
    );
  }

  homePageTab(){
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              height: 75,
              width: MediaQuery.of(context).size.width,
              child: new Row(children: [
                new SizedBox(width: 15,),
                Image.asset(
                  'assets/Twitter-Logo.png',
                  width: 50,
                  height: 50,
                  color: Color(0xff2fcdff),
                  fit: BoxFit.fitWidth,

                ),
                new Expanded(child: new Container()),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      notifier.handle,
                      style: GoogleFonts.montserrat(
                          color: Color(0xff2fcdff),
                          fontSize: 18,
                          fontWeight: FontWeight.w800
                      ),
                    ),
                    Text(
                      '${notifier.currentUser.displayName}',
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                new SizedBox(width: 15,),
                notifier.currentUser.photoURL != null
                    ? CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    widget.user.photoURL,
                  ),

                )
                    : ClipOval(
                  child: Material(
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.person,
                        size: 20,
                        color: CustomTheme.firebaseGrey,
                      ),
                    ),
                  ),
                ),
                new SizedBox(width: 20,)
              ],),
            ),
            new SizedBox(height: 25,),
            SearchBar(controller: searchBarController, focusNode: new FocusNode()),
            new SizedBox(height: 25,),
            new Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseConfig.posts,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                        child: Constants.loader());

                  return  ChangeNotifierProvider<PostsListNotifier>(
                    create: (c)=> PostsListNotifier(),
                    child: PostsList(snapshot.data.docs),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  profilePage(){
    return ProfilePage(user: widget.user,handle: notifier.handle,);
  }
  showModalSheet(){
    return showModalBottomSheet<void>(
        isScrollControlled: true,
      backgroundColor: Colors.transparent,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        builder: (BuildContext context) {
          return AddTweetModalSheet(
            notifier,(){
           setState(() {
             print("CallbackCalled");
           });
          },
          );});
  }



}


