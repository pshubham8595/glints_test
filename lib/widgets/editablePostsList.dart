import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glints_test/models/postDataModel.dart';
import 'package:glints_test/notifiers/EditablePostsListNotifier.dart';
import 'package:glints_test/notifiers/EditablePostsListNotifier.dart';
import 'package:glints_test/notifiers/EditablePostsListNotifier.dart';
import 'package:glints_test/notifiers/EditablePostsListNotifier.dart';
import 'package:glints_test/notifiers/PostsListNotifier.dart';
import 'package:glints_test/widgets/singleTweet.dart';
import 'package:provider/provider.dart';

import 'editableSingleTweet.dart';

class EditablePostsList extends StatefulWidget {
  List<QueryDocumentSnapshot> list;
  String handle;
  EditablePostsList(this.list,this.handle);

  @override
  _EditablePostsListState createState() => _EditablePostsListState();
}

class _EditablePostsListState extends State<EditablePostsList> {
  EditablePostsListNotifier editablePostsListNotifier;
  List<QueryDocumentSnapshot> finalList  = [];


  filterPostList(){
    List<QueryDocumentSnapshot> tempList  = [];

    setState(() {
      widget.list.forEach((element) {
        if(element.id.contains("${widget.handle}")){
          tempList.add(element);
        }
        else{

        }
      });
      reverseList(tempList);
    });
  }

  reverseList(List<QueryDocumentSnapshot> tempList)async{
    print(tempList.length);
    for(int i =tempList.length-1;i>=0;i--){
      setState(() {
        finalList.add(tempList[i]);
      });
    }
  }

  @override
  void initState() {
    filterPostList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    editablePostsListNotifier = Provider.of<EditablePostsListNotifier>(context);

    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics (),
        itemCount: finalList.length,
        itemBuilder: (context, int index) {
          return Padding(
            padding: new EdgeInsets.only(top: 7.5,bottom: 7.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EditableSingleTweet(finalList[index].data(), editablePostsListNotifier),
              ],
            ),
          );
        });
  }

}
