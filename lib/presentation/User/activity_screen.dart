import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:roster_app/common/screenutils/screen_utils.dart';
import 'package:roster_app/common/size_constants.dart';
import 'package:roster_app/common/themes/theme_color.dart';
import 'package:roster_app/di/get_it.dart';
import 'package:roster_app/domain/user_report_bloc/user_report_bloc.dart';
import 'package:roster_app/presentation/common/my_raised_button.dart';
import 'package:roster_app/presentation/common/myappbar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:roster_app/common/size_extension.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  DateTime now = DateTime.now();
  String _startDate;
  String _endDate;
  UserReportBloc _userReportBloc;

  _getStartnEndDates(DateTime date) {
    _startDate = (DateTime(date.year, date.month, date.day).toUtc().millisecondsSinceEpoch ~/ 1000).toString();
    _endDate = (DateTime(date.year, date.month, date.day).add(Duration(days: 1)).toUtc().millisecondsSinceEpoch ~/ 1000)
        .toString();
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is DateTime) {
        print('inside _onSelectingChanged');
        _getStartnEndDates(args.value);
      }
    });
    _userReportBloc.add(UserReportEvent(
      endDate: _endDate,
      startDate: _startDate,
    ));
  }

  @override
  void initState() {
    super.initState();
    _userReportBloc = getIt<UserReportBloc>();
    _getStartnEndDates(now);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserReportBloc>(
      create: (context) => _userReportBloc..add(UserReportEvent(endDate: _endDate, startDate: _startDate)),
      child: BlocConsumer<UserReportBloc, UserReportState>(
        listener: (context, state) {
          if (state is UserReportError) {
            FlushbarHelper.createError(message: state.failure.message).show(context);
          }
        },
        builder: (context, state) => Scaffold(
          backgroundColor: AppColor.blackHaze,
          appBar: MyAppBar(
            myTitle: Text(
              'My Calendar',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            //calendar here
            children: [
              Expanded(
                flex: 3,
                child: SfDateRangePicker(
                  selectionTextStyle: TextStyle(color: AppColor.white),
                  showNavigationArrow: true,
                  onSelectionChanged: _onSelectionChanged,
                  monthViewSettings: DateRangePickerMonthViewSettings(
                    weekendDays: List<int>()..add(6)..add(7),
                    specialDates: List<DateTime>()
                      ..add(
                        DateTime(2020, 10, 27),
                      ),
                    blackoutDates: List<DateTime>()
                      ..add(
                        DateTime(2020, 10, 7),
                      ),
                  ),
                  monthCellStyle: DateRangePickerMonthCellStyle(
                    weekendDatesDecoration: BoxDecoration(
                        color: AppColor.saffron,
                        border: Border.all(color: AppColor.saffron, width: 1),
                        shape: BoxShape.circle),
                    cellDecoration: BoxDecoration(
                      color: AppColor.shamrockGreen,
                      border: Border.all(color: AppColor.shamrockGreen, width: 1),
                      shape: BoxShape.circle,
                    ),
                    blackoutDatesDecoration: BoxDecoration(
                      color: AppColor.salmon,
                      border: Border.all(color: AppColor.salmon, width: 1),
                      shape: BoxShape.circle,
                    ),
                    specialDatesDecoration: BoxDecoration(
                      color: AppColor.lightBlue,
                      border: Border.all(color: AppColor.lightBlue, width: 1),
                      shape: BoxShape.circle,
                    ),
                    blackoutDateTextStyle: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: ScreenUtil().screenWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(Sizes.dimen_40),
                    ),
                    color: AppColor.white,
                  ),
                  child: (state is UserReportLoading)
                      ? Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            SizedBox(
                              height: Sizes.dimen_18.h,
                            ),
                            Text(
                              (state is UserReportLoaded)
                                  ? DateFormat('dd MMM yyyy')
                                      .format(DateTime.fromMillisecondsSinceEpoch(int.parse(_startDate) * 1000))
                                  : '',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            Text('Your working hours'),
                            SizedBox(
                              height: Sizes.dimen_14.h,
                            ),
                            Container(
                              color: AppColor.shamrockGreen,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: Sizes.dimen_18.h,
                                ),
                                child: DefaultTextStyle(
                                  style: Theme.of(context).textTheme.bodyText2.copyWith(color: AppColor.white),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      MyActivityColumn(
                                        title: 'Sign In',
                                        subTitle: (state is UserReportLoaded &&
                                                state.usersReport.workSummary.first.dailyReport.length > 0)
                                            ? DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(
                                                state.usersReport.workSummary.first.dailyReport.first.signInTimeTs))
                                            : 'NA',
                                      ),
                                      MyActivityColumn(
                                        title: 'Sign Out',
                                        subTitle: (state is UserReportLoaded &&
                                                state.usersReport.workSummary.first.dailyReport.length > 0)
                                            ? DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(
                                                state.usersReport.workSummary.first.dailyReport.first.signOutTimeTs))
                                            : 'NA',
                                      ),
                                      MyActivityColumn(
                                        title: 'Extras',
                                        subTitle: (state is UserReportLoaded &&
                                                state.usersReport.workSummary.first.dailyReport.length > 0)
                                            ? (state.usersReport.workSummary.first.dailyReport.first.durationInHrs - 9)
                                                .toString()
                                            : 'NA',
                                      ),
                                      MyActivityColumn(
                                        title: 'Late',
                                        subTitle: (state is UserReportLoaded &&
                                                state.usersReport.workSummary.first.dailyReport.length > 0)
                                            ? getTimeString(
                                                state.usersReport.workSummary.first.dailyReport.first.lateInMins)
                                            : 'NA',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Sizes.dimen_14.h,
                            ),
                            MyRaisedButton(
                              buttonTitle: 'Apply for Leaves',
                              onPressed: () {
                                Navigator.of(context).pushNamed('/apply-leave-screen');
                              },
                              buttonColor: AppColor.lightBlue,
                              isTrailingPresent: false,
                              padding: EdgeInsets.symmetric(
                                horizontal: Sizes.dimen_32.w,
                                vertical: Sizes.dimen_14.h,
                              ),
                            ),
                          ],
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String getTimeString(int value) {
    final int hour = value ~/ 60;
    final int minutes = value % 60;
    return '${hour.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")} hr';
  }
}

class MyActivityColumn extends StatelessWidget {
  const MyActivityColumn({
    Key key,
    @required this.title,
    @required this.subTitle,
  }) : super(key: key);

  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text(title), Text(subTitle)],
    );
  }
}
