import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:roster_app/common/screenutils/screen_utils.dart';
import 'package:roster_app/common/size_constants.dart';
import 'package:roster_app/common/size_extension.dart';
import 'package:roster_app/common/string_constants.dart';
import 'package:roster_app/common/themes/theme_color.dart';
import 'package:roster_app/di/get_it.dart';
import 'package:roster_app/domain/sign_in_form_bloc/sign_in_form_bloc.dart';
import 'package:roster_app/domain/user_report_bloc/user_report_bloc.dart';
import 'package:roster_app/presentation/common/my_decoration_box.dart';

class MyStatsScreen extends StatefulWidget {
  @override
  _MyStatsScreenState createState() => _MyStatsScreenState();
}

class _MyStatsScreenState extends State<MyStatsScreen> {
  UserReportBloc _userReportBloc = getIt<UserReportBloc>();
  var _weekStart;
  var _weekEnd;
  var _monthStart;
  var _monthEnd;
  var _percentWorkDone = 0.0;
  bool _selected = false;

  _getMonthDates() {
    DateTime now = DateTime.now();
    _monthStart = (DateTime.utc(now.year, now.month).millisecondsSinceEpoch ~/ 1000).toString();
    _monthEnd = (DateTime.utc(now.year, now.month + 1, 0).millisecondsSinceEpoch ~/ 1000).toString();
  }

  @override
  void initState() {
    super.initState();
    var date = DateTime.now();
    print('Start of week: ${getDate(DateTime.now().subtract(Duration(days: date.weekday - 1)))}');
    print('End of week: ${getDate(date.add(Duration(days: DateTime.daysPerWeek - date.weekday)))}');
    _weekStart = (getDate(date.subtract(Duration(days: date.weekday - 1))).millisecondsSinceEpoch ~/ 1000).toString();
    _weekEnd = (getDate(date.add(Duration(days: DateTime.daysPerWeek - date.weekday))).millisecondsSinceEpoch ~/ 1000)
        .toString();
  }

  DateTime getDate(DateTime d) => DateTime.utc(d.year, d.month, d.day);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserReportBloc>(
      create: (context) => _userReportBloc..add(UserReportEvent(endDate: _weekEnd, startDate: _weekStart)),
      child: BlocConsumer<UserReportBloc, UserReportState>(
        listener: (context, state) {
          if (state is UserReportError) {
            FlushbarHelper.createError(message: state.failure.message).show(context);
          }
        },
        builder: (context, state) {
          return Container(
            decoration: MyDecorationBox(),
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                //leading: IconButton(icon: Icon(Icons.dehaze_outlined), onPressed: () {}),
                actions: [
                  FlatButton(
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
                    child: Text(
                      'Logout',
                      style: TextStyle(fontSize: Sizes.dimen_20.sp, color: AppColor.white),
                    ),
                  ),
                  // IconButton(
                  //     icon: Icon(
                  //       Icons.notifications_none_outlined,
                  //     ),
                  //     onPressed: () {})
                ],
                title: Text(''),
                backgroundColor: Colors.transparent,
              ),
              //bottomNavigationBar: MyBottomNav(),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: Sizes.dimen_4.h,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: Sizes.dimen_24.w),
                    child: Text(
                      StringConstants.myStatsScreenTitleText,
                      style: Theme.of(context).textTheme.headline5.copyWith(
                            color: AppColor.white,
                          ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: Sizes.dimen_24.w),
                    child: Text(StringConstants.myStatsScreenSubTitleText,
                        style: Theme.of(context).textTheme.subtitle1.copyWith(color: AppColor.white)),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: Sizes.dimen_4.h,
                    ),
                  ),
                  Expanded(
                    flex: 11,
                    child: Container(
                        width: ScreenUtil().screenWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(Sizes.dimen_40),
                          ),
                          color: AppColor.white,
                        ),
                        child: (state is UserReportLoading)
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Builder(
                                builder: (context) {
                                  if (state is UserReportLoaded) {
                                    _percentWorkDone = state.usersReport.totalWorkTimeInHrs /
                                        (state.usersReport.totalWorkTimeInHrs +
                                            state.usersReport.remainingWorkTimeInHrs);
                                  }

                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: Sizes.dimen_40.h,
                                      ),
                                      ButtonBar(
                                        alignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          FlatButton(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            minWidth: Sizes.dimen_100.w,
                                            child: Text('Weekly'),
                                            color: !_selected ? Colors.blue : AppColor.sandGrey,
                                            onPressed: () {
                                              _selected = false;
                                              BlocProvider.of<UserReportBloc>(context)
                                                  .add(UserReportEvent(endDate: _weekEnd, startDate: _weekStart));
                                            },
                                          ),
                                          FlatButton(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            minWidth: Sizes.dimen_100.w,
                                            child: Text('Monthly'),
                                            color: _selected ? Colors.blue : AppColor.sandGrey,
                                            onPressed: () {
                                              _selected = true;
                                              _getMonthDates();
                                              BlocProvider.of<UserReportBloc>(context)
                                                  .add(UserReportEvent(startDate: _monthStart, endDate: _monthEnd));
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Sizes.dimen_10.h,
                                      ),
                                      CircularPercentIndicator(
                                        percent: _percentWorkDone,
                                        lineWidth: 45.0,
                                        startAngle: 0.0,
                                        radius: 180,
                                        linearGradient: LinearGradient(
                                          colors: [
                                            AppColor.lightBlue,
                                            AppColor.elecViolet,
                                          ],
                                          begin: Alignment.topCenter,
                                        ),
                                        //fillColor: Colors.black,
                                        backgroundColor: Color(0xffd8fcff),
                                        backgroundWidth: 40,
                                        circularStrokeCap: CircularStrokeCap.butt,
                                        //arcType: ArcType.FULL,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Image.asset(
                                                    'assets/icons/Vector1.png',
                                                    scale: 1.5,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: Sizes.dimen_10,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  (state is UserReportLoaded)
                                                      ? Text(
                                                          '${state.usersReport.totalWorkTimeInHrs}',
                                                          style: Theme.of(context).textTheme.headline5,
                                                        )
                                                      : Text(''),
                                                  Text('Hours Worked'),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Image.asset(
                                                    'assets/icons/vector2.png',
                                                    scale: 1.5,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: Sizes.dimen_10,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  (state is UserReportLoaded)
                                                      ? Text(
                                                          '${state.usersReport.remainingWorkTimeInHrs}',
                                                          style: Theme.of(context).textTheme.headline5,
                                                        )
                                                      : Text(''),
                                                  Text('Hours Remaining'),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                          child: SizedBox(
                                        height: Sizes.dimen_10,
                                      )),
                                    ],
                                  );
                                },
                              )),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
