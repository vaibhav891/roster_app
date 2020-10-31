import 'package:flutter/material.dart';

class MyAppBar extends AppBar {
  final Text myTitle;
  final bool centerTitle;

  MyAppBar({Key key, @required this.myTitle,this.centerTitle = false})
      : super(
          key: key,
          title: myTitle,
          backgroundColor: Colors.transparent,
          centerTitle: centerTitle,
        );
}
