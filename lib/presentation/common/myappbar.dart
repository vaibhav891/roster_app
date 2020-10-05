import 'package:flutter/material.dart';

class MyAppBar extends AppBar {
  final Text myTitle;

  MyAppBar({Key key, @required this.myTitle})
      : super(
          key: key,
          title: myTitle,
          backgroundColor: Colors.transparent,
        );
}
