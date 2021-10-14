import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glints_test/auth/Authentication.dart';
import 'package:glints_test/firebaseConfig/FirebaseConfig.dart';
import 'package:glints_test/notifiers/EditablePostsListNotifier.dart';
import 'package:glints_test/notifiers/PostsListNotifier.dart';
import 'package:glints_test/utils/Constants.dart';
import 'package:glints_test/utils/customTheme.dart';
import 'package:glints_test/widgets/EditTweet.dart';
import 'package:glints_test/widgets/editablePostsList.dart';
import 'package:glints_test/widgets/editableSingleTweet.dart';
import 'package:glints_test/widgets/postsList.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  User user;
  String handle;
  ProfilePage({this.user,this.handle});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User _user;
  bool _isSigningOut = false;
  TextEditingController searchBarController = new TextEditingController();
  FocusNode searchFocusNode = new FocusNode();
  @override
  void initState() {
    _user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              new SizedBox(height: 25,),
              new Row(
                children: [
                  new SizedBox(width: 25,),
                  _user.photoURL != null
                      ? CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      _user.photoURL,
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
                  new SizedBox(width: 15,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          widget.handle,
                          minFontSize: 18,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                              color: Color(0xff2fcdff),
                              fontSize: 25,
                              fontWeight: FontWeight.w800
                          ),
                        ),
                        AutoSizeText(
                          '${_user.displayName}',
                          minFontSize: 18,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: 28,
                          ),
                        ),
                        _isSigningOut
                            ? Constants.loader()
                            : ElevatedButton(
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
                            setState(() {
                              _isSigningOut = true;
                            });
                            await Authentication.signOut(context: context);
                            setState(() {
                              _isSigningOut = false;
                            });
                            // Navigator.of(context)
                            //     .pushReplacement(_routeToSignInScreen());
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                            child: Text(
                              'Sign Out',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  new SizedBox(width: 15,),
                ],
              ),
              new SizedBox(height: 25,),
              new Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseConfig.posts,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                          child: Constants.loader());
                    return  ChangeNotifierProvider<EditablePostsListNotifier>(
                      create: (c)=> EditablePostsListNotifier(),
                      child: EditablePostsList(snapshot.data.docs,widget.handle),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
