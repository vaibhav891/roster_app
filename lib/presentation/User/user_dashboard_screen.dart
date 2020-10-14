import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
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
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  _handleIndexChanged(int index) {
    setState(() {
      currentScreen = tabScreens[index];
    });
  }

  _getPosition() {
    print('inside _getPosition');

    positionStream = getPositionStream(
      timeInterval: 600000, //this is in millisecs
    ).listen((Position position) async {
      print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
      User.instance.lat = position.latitude;
      User.instance.long = position.longitude;
      var bloc = BlocProvider.of<HomeBloc>(context);
      if (bloc.state.isSignedIn) {
        var failureOrSuccess = await _remoteDataSrc.fetchUserSite();
        if (failureOrSuccess.isRight()) {
          failureOrSuccess.fold(
            (l) => null,
            (r) {
              if (r.sites.length > 0) {
                siteLat = r.sites.first.location.latitude;
                siteLong = r.sites.first.location.longitude;
                radiusInMeters = r.sites.first.radiusInMeter;
              }
              return null;
            },
          );
        }

        double distanceInMeters = distanceBetween(siteLat, siteLong, position.latitude, position.longitude);

        if (distanceInMeters > radiusInMeters) {
          bloc.add(SignInSignOutEvent(position.latitude, position.longitude));
        }
      }
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

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  @override
  void initState() {
    super.initState();
    _getPosition();
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();

    fbm.configure(
      onMessage: (message) {
        print('onMessage: $message');
        return null;
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
