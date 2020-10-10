import 'package:flutter/material.dart';
import 'package:roster_app/common/size_constants.dart';
import 'package:roster_app/common/size_extension.dart';

class DashboardAppBar extends AppBar {
  final String myTitle;
  //final Function onPressed

  DashboardAppBar({Key key, @required this.myTitle})
      : super(
          key: key,
          leading: IconButton(icon: Icon(Icons.dehaze_outlined), onPressed: () {}),
          actions: [
            FlatButton(
              onPressed: () {},
              child: Text(
                'Logout',
                style: TextStyle(
                  fontSize: Sizes.dimen_20.sp,
                ),
              ),
            ),
            IconButton(
                icon: Icon(
                  Icons.notifications_none_outlined,
                ),
                onPressed: () {})
          ],
          title: Text(myTitle),
          backgroundColor: Colors.transparent,
        );
}
