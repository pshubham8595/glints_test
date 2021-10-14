import 'package:flutter/material.dart';

class PageAppBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 70,
      width: MediaQuery.of(context).size.width,
      color: Colors.amber,
    );
  }
}

