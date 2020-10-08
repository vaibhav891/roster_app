import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:roster_app/common/themes/theme_color.dart';
import 'package:roster_app/domain/auth/user.dart';
import 'package:roster_app/domain/shift_signing_bloc/shift_signing_bloc.dart';
import 'package:roster_app/presentation/User/activity_screen.dart';
import 'package:roster_app/presentation/User/home_screen.dart';
import 'package:roster_app/presentation/User/my_stats_screen.dart';
import 'package:roster_app/presentation/common/my_bottom_nav.dart';

class UserDashboardScreen extends StatefulWidget {
  @override
  _UserDashboardScreenState createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  final bucket = PageStorageBucket();
  StreamSubscription<Position> positionStream;

  List<Widget> tabScreens = [
    HomeScreen(),
    ActivityScreen(),
    MyStatsScreen(),
  ];

  Widget currentScreen = HomeScreen();

  _handleIndexChanged(int index) {
    setState(() {
      currentScreen = tabScreens[index];
    });
  }

  _getPosition() {
    print('inside _getPosition');

    positionStream = getPositionStream(
            //distanceFilter: 10,
            //timeInterval: 1000, //this is in millisecs
            )
        .listen((Position position) {
      print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
      User.instance.lat = position.latitude.toString();
      User.instance.long = position.longitude.toString();
      var bloc = BlocProvider.of<ShiftSigningBloc>(context);
      if (bloc.state.isSignedIn) {
        // BlocProvider.of<ShiftSigningBloc>(context)
        //     .add(ShiftSigningEvent(position.latitude.toString(), position.longitude.toString()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getPosition();
  }

  @override
  void dispose() {
    super.dispose();
    positionStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBody: true,
      backgroundColor: AppColor.white,
      bottomNavigationBar: MyBottomNav(
        currentIndex: tabScreens.indexOf(currentScreen),
        handleIndexChanged: _handleIndexChanged,
      ),
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
    );
  }
}
