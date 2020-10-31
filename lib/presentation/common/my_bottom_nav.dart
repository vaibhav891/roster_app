import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roster_app/common/size_constants.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:roster_app/common/size_extension.dart';

class MyBottomNav extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> handleIndexChanged;

  const MyBottomNav({Key key, @required this.handleIndexChanged, @required this.currentIndex}) : super(key: key);
  @override
  _MyBottomNavState createState() => _MyBottomNavState();
}

class _MyBottomNavState extends State<MyBottomNav> {
  @override
  Widget build(BuildContext context) {
    return SalomonBottomBar(
      margin: EdgeInsets.fromLTRB(
        Sizes.dimen_18.w,
        Sizes.dimen_12.h,
        Sizes.dimen_18.w,
        Sizes.dimen_24.h,
      ),
      currentIndex: widget.currentIndex,
      onTap: widget.handleIndexChanged,
      items: [
        SalomonBottomBarItem(icon: Icon(Icons.home_outlined), title: Text('Home')),
        SalomonBottomBarItem(icon: Icon(Icons.calendar_today_outlined), title: Text('Activity')),
        SalomonBottomBarItem(
            icon: SvgPicture.asset(
              'assets/icons/calendar.svg',
              color: Colors.black,
              height: Sizes.dimen_24,
            ),
            title: Text('My stats')),
      ],
    );
  }
}
