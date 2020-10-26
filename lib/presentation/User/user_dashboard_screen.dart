import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info/package_info.dart';
import 'package:roster_app/common/themes/theme_color.dart';
import 'package:roster_app/data/data_sources/remote_data_src.dart';
import 'package:roster_app/di/get_it.dart';
import 'package:roster_app/domain/auth/user.dart';
import 'package:roster_app/domain/home_bloc/home_bloc.dart';
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
  final fbm = FirebaseMessaging();

  StreamSubscription<Position> positionStream;
  RemoteDataSrc _remoteDataSrc = getIt<RemoteDataSrc>();
  double siteLat;
  double siteLong;
  num radiusInMeters;

  List<Widget> tabScreens = [
    HomeScreen(),
    ActivityScreen(),
    MyStatsScreen(),
  ];

  Widget currentScreen = HomeScreen();
  int currentIndex = 0;
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  _handleIndexChanged(int index) {
    setState(() {
      currentScreen = tabScreens[index];
      currentIndex = index;
    });
  }

  _getPosition() async {
    print('inside _getPosition');

    try {
      LocationPermission permission = await GeolocatorPlatform.instance.checkPermission();
      if (permission == LocationPermission.denied) {
        LocationPermission perm = await GeolocatorPlatform.instance.requestPermission();
        if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content:
                    Text('Location is required for user to signin into site. You can turn it on again from Settings.'),
                actions: [
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Ok'),
                  )
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      print(e.toString());
    }

    positionStream = getPositionStream(
      timeInterval: 600000, //this is in millisecs
    ).listen((Position position) async {
      print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
      User.instance.lat = position.latitude;
      User.instance.long = position.longitude;
      var bloc = BlocProvider.of<HomeBloc>(context);
      // if (bloc.state.isSignedIn) {
      //   var failureOrSuccess = await _remoteDataSrc.fetchUserSite();
      //   if (failureOrSuccess.isRight()) {
      //     failureOrSuccess.fold(
      //       (l) => null,
      //       (r) {
      //         if (r.sites.length > 0) {
      //           siteLat = r.sites.first.location.latitude;
      //           siteLong = r.sites.first.location.longitude;
      //           radiusInMeters = r.sites.first.radiusInMeter;
      //         }
      //         return null;
      //       },
      //     );
      //   }

      // double distanceInMeters = distanceBetween(siteLat, siteLong, position.latitude, position.longitude);

      // if (distanceInMeters > radiusInMeters) {
      //   bloc.add(SignInSignOutEvent(position.latitude, position.longitude));
      // }
      // }
    });
  }

  _getDeviceInfo() async {
    Map<String, dynamic> deviceData;

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{'Error:': 'Failed to get platform version.'};
    }

    if (!mounted) return;
    _deviceData = deviceData;

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _deviceData['appVersion'] = packageInfo.version;
    var pushToken = await fbm.getToken();
    _deviceData['pushToken'] = pushToken;

    var successOrFailure = await _remoteDataSrc.updateDeviceInfo(deviceInfo: _deviceData);
    successOrFailure.fold((l) => FlushbarHelper.createError(message: l.message).show(context), (r) => null);
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'osVersion': build.version.release,
      'deviceName': build.device,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'platform': 'android',
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'deviceName': data.name,
      'osVersion': data.systemVersion,
      'model': data.model,
      'manufacturer': 'Apple',
      'platform': 'ios',
    };
  }

  Future<bool> _onBackPressed() {
    print('inside onWillPop');
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Exit?",
          ),
          content: Text('Do you really want to exit?'),
          actions: [
            FlatButton(onPressed: () => Navigator.of(context).pop(false), child: Text('No')),
            FlatButton(onPressed: () => Navigator.of(context).pop(true), child: Text('Yes')),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getPosition();
    fbm.requestNotificationPermissions();

    fbm.configure(
      onMessage: (message) {
        print('onMessage: $message');
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(message['notification']['title']),
            content: Text(message['notification']['body']),
            actions: [
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      },
      onResume: (message) {
        print('onResume: $message');
        return null;
      },
      onLaunch: (message) {
        print('onLaunch: $message');
        return null;
      },
    );

    _getDeviceInfo();
  }

  @override
  void dispose() {
    super.dispose();
    positionStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        //extendBody: true,
        backgroundColor: AppColor.white,
        bottomNavigationBar: MyBottomNav(
          currentIndex: currentIndex, //tabScreens.indexOf(currentScreen),
          handleIndexChanged: _handleIndexChanged,
        ),
        body: PageStorage(
          bucket: bucket,
          child: currentScreen,
        ),
      ),
    );
  }
}
