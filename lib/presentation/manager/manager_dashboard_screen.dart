import 'dart:math';

import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:roster_app/common/screenutils/screen_utils.dart';
import 'package:roster_app/common/size_constants.dart';
import 'package:roster_app/common/themes/theme_color.dart';
import 'package:roster_app/di/get_it.dart';
import 'package:roster_app/domain/manager_report_bloc/manager_report_bloc.dart';
import 'package:roster_app/domain/model/user_timing.dart';
import 'package:roster_app/presentation/common/my_decoration_box.dart';
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
  String _selectedLocation;
  List<String> locations = [];
  List<UserTiming> userTimings = [];

  _convertDate(DateTime date) {
    _stDate = (DateTime(date.year, date.month, date.day).millisecondsSinceEpoch / 1000).toString();
    _endDate =
        (DateTime(date.year, date.month, date.day).add(Duration(days: 1)).millisecondsSinceEpoch / 1000).toString();

    print('$_stDate, $_endDate');
  }

  @override
  void initState() {
    super.initState();
    _managerReportBloc = getIt<ManagerReportBloc>();
    DateTime now = DateTime.now();
    _convertDate(now);
  }

  @override
  void dispose() {
    super.dispose();
    _calendarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ManagerReportBloc>(
      create: (context) => _managerReportBloc
        ..add(ManagerReportLoadEvent(
          startDate: _stDate,
          endDate: _stDate,
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
            for (var i = 0; i < state.usersReport.workSummary.length; i++) {
              if (state.usersReport.workSummary[i].siteName == _selectedLocation) {
                var locationDetail = state.usersReport.workSummary[i].dailyReport;

                userTimings = locationDetail.map((e) {
                  String type = e.lateInMins != 0
                      ? 'Late'
                      : e.signInTimeTs == 0
                          ? 'Leave'
                          : 'Working';
                  return UserTiming(e.name, e.signInTimeTs.toString(), e.signOutTimeTs.toString(), type);
                }).toList();
              }
            }
          }
          return Container(
            decoration: MyDecorationBox(),
            child: Scaffold(
                body: SafeArea(
                    child: Column(
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyText2.copyWith(color: AppColor.white),
                  child: TableCalendar(
                    calendarController: _calendarController,
                    initialCalendarFormat: CalendarFormat.week,
                    calendarStyle: CalendarStyle(markersColor: AppColor.white),
                    onDaySelected: (day, events) {
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
                              decoration:
                                  BoxDecoration(color: AppColor.sandGrey, borderRadius: BorderRadius.circular(14)),
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
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
                                      ? DateFormat.jm().format(
                                          DateTime.fromMillisecondsSinceEpoch(int.parse(userTimings[index].inTime)))
                                      : '0';
                                  var outTime = userTimings[index].outTime != '0'
                                      ? DateFormat.jm().format(
                                          DateTime.fromMillisecondsSinceEpoch(int.parse(userTimings[index].outTime)))
                                      : '0';
                                  return ListTile(
                                    tileColor: AppColor.white,
                                    title: Text(userTimings[index].userName),
                                    subtitle: Text('In : $inTime  Out : $outTime '),
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
    );
  }
}
