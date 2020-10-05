import 'package:flutter/material.dart';

class DashboardAppBar extends AppBar {
  final String myTitle;

  DashboardAppBar({Key key, @required this.myTitle})
      : super(
          key: key,
          leading: IconButton(icon: Icon(Icons.dehaze_outlined), onPressed: () {}),
          actions: [IconButton(icon: Icon(Icons.notifications_none_outlined), onPressed: () {})],
          title: Text(myTitle),
          backgroundColor: Colors.transparent,
        );
}
