import 'package:flutter/material.dart';

class MyAppBar extends AppBar {
  final String myTitle;

  MyAppBar({Key key, @required this.myTitle})
      : super(
          key: key,
          title: Text(myTitle),
          backgroundColor: Colors.transparent,
        );
}
