import 'dart:io';
import 'dart:math';

import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:roster_app/common/screenutils/screen_utils.dart';
import 'package:roster_app/common/size_constants.dart';
import 'package:roster_app/common/themes/theme_color.dart';
import 'package:roster_app/data/data_sources/remote_data_src.dart';
import 'package:roster_app/di/get_it.dart';
import 'package:roster_app/domain/manager_report_bloc/manager_report_bloc.dart';
import 'package:roster_app/domain/model/user_timing.dart';
import 'package:roster_app/domain/sign_in_form_bloc/sign_in_form_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:roster_app/common/size_extension.dart';

class ManagerDashboardScreen extends StatefulWidget {
  @override
  _ManagerDashboardScreenState createState() => _ManagerDashboardScreenState();
}

class _ManagerDashboardScreenState extends State<ManagerDashboardScreen> {
  final CalendarController _calendarController = CalendarController();
  ManagerReportBloc _managerReportBloc;
  String _stDate = '';
  String _endDate = '';
  String _timeZone = '';
  String _selectedLocation;
  List<String> locations = [];
  List<UserTiming> userTimings = [];
  DateTime dateSelected = DateTime.now();
  final fbm = FirebaseMessaging();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  RemoteDataSrc _remoteDataSrc = getIt<RemoteDataSrc>();

  _convertDate(DateTime date) {
    _stDate = (DateTime.utc(date.year, date.month, date.day).millisecondsSinceEpoch ~/ 1000).toString();
    _endDate =
        ((DateTime.utc(date.year, date.month, date.day).add(Duration(days: 1)).millisecondsSinceEpoch - 1) ~/ 1000)
            .toString();

    print('manager report $_stDate, $_endDate');
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

  @override
  void initState() {
    super.initState();
    _managerReportBloc = getIt<ManagerReportBloc>();
    DateTime now = DateTime.now();
    _convertDate(now);
    _timeZone = now.timeZoneName;

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
    _calendarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: BlocProvider<ManagerReportBloc>(
        create: (context) => _managerReportBloc
          ..add(ManagerReportLoadEvent(
            startDate: _stDate,
            endDate: _stDate,
            //timeZone : _timeZone,
          )),
        child: BlocConsumer<ManagerReportBloc, ManagerReportState>(
          listener: (context, state) {
            if (state is ManagerReportErrorState) {
              FlushbarHelper.createError(message: state.failure.message).show(context);
            }
          },
          builder: (context, state) {
            if (state is ManagerReportLoadedState) {
              locations = state.usersReport.workSummary.map((e) {
                return e.siteName;
              }).toList();
              if (_selectedLocation == null && locations.isNotEmpty) _selectedLocation = locations[0];
              for (var i = 0; i < state.usersReport.workSummary.length; i++) {
                if (state.usersReport.workSummary[i].siteName == _selectedLocation) {
                  var locationDetail = state.usersReport.workSummary[i].dailyReport;

                  userTimings = locationDetail.map((e) {
                    String type = e.lateInMins != 0
                        ? 'Late'
                        : e.leaveType != null
                            ? 'Leave'
                            : 'Working';
                    return UserTiming(
                        e.name, e.signInTimeTs.toString(), e.signOutTimeTs.toString(), type, e.extra, e.lateInMins);
                  }).toList();
                }
              }
            }
            return Container(
              decoration: BoxDecoration(
                color: AppColor.gallery,
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  alignment: Alignment.topCenter,
                ),
              ),
              child: Scaffold(
                  floatingActionButton: FloatingActionButton.extended(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Log Out'),
                            content: Text('Do you really want to logout?'),
                            actions: [
                              FlatButton(onPressed: () => Navigator.of(context).pop(), child: Text('No')),
                              FlatButton(
                                  onPressed: () {
                                    BlocProvider.of<SignInFormBloc>(context).add(SignInFormEvent.signOutUser());
                                    Navigator.of(context).pushNamedAndRemoveUntil('login', (route) => false);
                                  },
                                  child: Text('Yes')),
                            ],
                          );
                        },
                      );
                    },
                    label: Text('Logout'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  body: SafeArea(
                      child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 10, right: 10),
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed('manager-notifications');
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("Alerts",
                                    style: TextStyle(fontSize: 18, color: AppColor.white, fontFamily: "Product Sans")),
                                SizedBox(
                                  width: 3,
                                ),
                                Icon(
                                  Icons.notifications_none,
                                  color: AppColor.white,
                                  size: 24,
                                )
                              ],
                            ),
                          )

//                        IconButton(icon:,onPressed: (){
//                          Navigator.of(context).pushNamed('manager-notifications');
//                        },),
                          ),
                      DefaultTextStyle(
                        style: Theme.of(context).textTheme.bodyText2.copyWith(color: AppColor.white),
                        child: TableCalendar(
                          //endDay: DateTime.now(),
                          availableCalendarFormats: const {CalendarFormat.week: 'Week'},
                          calendarController: _calendarController,
                          initialCalendarFormat: CalendarFormat.week,
                          selectedBoxDecoration:
                              BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.5)),
                          //initialSelectedDay: dateSelected,
                          onVisibleDaysChanged: (first, last, format) {
                            // if (DateTime.now().millisecondsSinceEpoch > first.millisecondsSinceEpoch) {
                            _calendarController.setSelectedDay(first);
                            _convertDate(first);
                            BlocProvider.of<ManagerReportBloc>(context).add(ManagerReportLoadEvent(
                              startDate: _stDate,
                              endDate: _endDate,
                            ));
                            // }
                          },
                          calendarStyle: CalendarStyle(
                            markersColor: AppColor.white,
                            weekendStyle: TextStyle(color: AppColor.white),
                          ),
                          daysOfWeekStyle: DaysOfWeekStyle(
                              weekdayStyle: TextStyle(color: AppColor.white),
                              weekendStyle: TextStyle(color: AppColor.white)),
                          headerStyle: HeaderStyle(
                            centerHeaderTitle: true,
                          ),
                          onDaySelected: (day, events1, events2) {
                            print(day.toString());
                            _convertDate(day);
                            BlocProvider.of<ManagerReportBloc>(context).add(ManagerReportLoadEvent(
                              startDate: _stDate,
                              endDate: _endDate,
                            ));
                          },
                        ),
                      ),
                      Expanded(
                          child: Container(
                        width: ScreenUtil().screenWidth,
                        color: AppColor.gallery,
                        child: (state is ManagerReportLoadedState)
                            ? Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    decoration: BoxDecoration(
                                        color: AppColor.sandGrey, borderRadius: BorderRadius.circular(14)),
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      value: _selectedLocation,
                                      items: locations
                                          .map((e) => DropdownMenuItem(
                                                child: Text(e),
                                                value: e,
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          print('inside setstate');
                                          _selectedLocation = value;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: Sizes.dimen_12.h,
                                  ),
                                  Flexible(
                                    child: ListView.separated(
                                      itemCount: userTimings.length,
                                      itemBuilder: (context, index) {
                                        var inTime = userTimings[index].inTime != '0'
                                            ? //userTimings[index].inTime.toString()
                                            DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(
                                                int.parse(userTimings[index].inTime) * 1000))
                                            : '-';
                                        var outTime = userTimings[index].outTime != '0'
                                            ? //userTimings[index].outTime.toString()
                                            DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(
                                                int.parse(userTimings[index].outTime) * 1000))
                                            : '-';
                                        return ListTile(
                                          tileColor: AppColor.white,
                                          title: Text(userTimings[index].userName),
                                          subtitle: Row(
                                            children: [
                                              Text('In : $inTime  Out : $outTime '),
                                              if (userTimings[index].extra != 0)
                                                Text(' Extra - ${userTimings[index].extra} mins'),
                                              if (userTimings[index].lateInMins != 0)
                                                Text(' Late by ${userTimings[index].lateInMins} mins',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2
                                                        .copyWith(color: Colors.red)),
                                            ],
                                          ),
                                          trailing: Container(
                                            color: userTimings[index].type == 'Late'
                                                ? Colors.amber
                                                : userTimings[index].type == 'Leave'
                                                    ? Colors.red
                                                    : AppColor.mmGreen,
                                            child: Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Icon(
                                                userTimings[index].type == 'Late'
                                                    ? Icons.timer
                                                    : userTimings[index].type == 'Leave'
                                                        ? Icons.cancel_outlined
                                                        : Icons.done,
                                                color: AppColor.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) => SizedBox(
                                        height: 2,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Container(
                                      //padding: EdgeInsets.all(Sizes.dimen_12),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 60,
                                            child: Column(
                                              children: [
                                                Container(
                                                  color: Colors.amber,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Icon(
                                                      Icons.timer,
                                                      size: 20,
                                                      color: AppColor.white,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  'Late',
                                                  //style: Theme.of(context).textTheme.subtitle1,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Container(
                                            width: 60,
                                            child: Column(
                                              children: [
                                                Container(
                                                  color: Colors.red,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Icon(
                                                      Icons.cancel_outlined,
                                                      size: 20,
                                                      color: AppColor.white,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  'Leave',
                                                  //style: Theme.of(context).textTheme.subtitle1,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Container(
                                            width: 60,
                                            child: Column(
                                              children: [
                                                Container(
                                                  color: AppColor.mmGreen,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Icon(
                                                      Icons.done,
                                                      size: 20,
                                                      color: AppColor.white,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  'Working',
                                                  //style: Theme.of(context).textTheme.subtitle1,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                      )),
                    ],
                  ))),
            );
          },
        ),
      ),
    );
  }
}
