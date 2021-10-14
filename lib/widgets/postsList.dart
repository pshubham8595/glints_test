import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glints_test/models/postDataModel.dart';
import 'package:glints_test/notifiers/PostsListNotifier.dart';
import 'package:glints_test/widgets/singleTweet.dart';
import 'package:provider/provider.dart';

class PostsList extends StatefulWidget {
  List<QueryDocumentSnapshot> list;

  PostsList(this.list);

  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  PostsListNotifier postsListNotifier;
  List<QueryDocumentSnapshot> finalList = [];

  @override
  void initState() {
    reverseList();
    super.initState();
  }

  reverseList()async{
    print(widget.list.length);
    for(int i =widget.list.length-1;i>=0;i--){
      setState(() {
        finalList.add(widget.list[i]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    postsListNotifier = Provider.of<PostsListNotifier>(context);
    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics (),
        itemCount: widget.list.length,
        reverse: false,
        shrinkWrap: true,
        itemBuilder: (context, int index) {
          return Padding(
            padding: new EdgeInsets.only(top: 7.5,bottom: 7.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SingleTweet(finalList[index].data(), postsListNotifier),
              ],
            ),
          );
        });
  }
}
