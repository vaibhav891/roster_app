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
import 'package:table_calendar/table_calendar.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> with SingleTickerProviderStateMixin {
  DateTime now = DateTime.now();
  String _startDate;
  String _endDate;
  UserReportBloc _userReportBloc;

  List<DateTime> workingDays = List<DateTime>();
  List<DateTime> leaveDays = List<DateTime>();
  List<Map<String, String>> tileData = List<Map<String, String>>();
  String _selectedDate = '';
  Map<String, String> _selectedTile = Map<String, String>();

  //Table Calander Variables
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  _getStartnEndDates(DateTime date) {
    // _startDate = (DateTime(date.year, date.month, 2).toUtc().millisecondsSinceEpoch ~/ 1000).toString();
    _startDate = (DateTime.utc(date.year, date.month, 1).millisecondsSinceEpoch ~/ 1000).toString();
    _endDate = (DateTime.utc(date.year, date.month + 1, 0).millisecondsSinceEpoch ~/ 1000).toString();
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is DateTime) {
        print('inside _onSelectionChanged');
        _selectedDate = DateFormat('dd MMM yyyy').format(args.value);
        //_getStartnEndDates(args.value);
      }
    });
    // _userReportBloc.add(UserReportEvent(
    //   endDate: _endDate,
    //   startDate: _startDate,
    // ));
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    setState(() {
      print('inside _onSelectionChanged');
      _selectedDate = DateFormat('dd MMM yyyy').format(day);
      //_getStartnEndDates(args.value);
    });

//    setState(() {
//      _selectedEvents = events;
//    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    _events = {};
    tileData = [];
    now = DateTime(first.year, first.month, 1);
    _getStartnEndDates(first);
    _userReportBloc..add(UserReportEvent(endDate: _endDate, startDate: _startDate));
  }

  @override
  void initState() {
    super.initState();

    _userReportBloc = getIt<UserReportBloc>();
    _getStartnEndDates(now);
    _selectedDate = DateFormat('dd MMM yyyy').format(now);

    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
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
        builder: (context, state) {
          if (state is UserReportLoaded) {
            var workSum = state.usersReport.workSummary;
            _events = {};
            for (var i = 0; i < workSum.length; i++) {
              var dailyRep = workSum[i].dailyReport;

              for (var j = 0; j < dailyRep.length; j++) {
                tileData.add({
                  "date":
                      DateFormat('dd MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(dailyRep[j].dateTs * 1000)),
                  "startTime": dailyRep[j].signInTimeTs != 0
                      ? DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(dailyRep[j].signInTimeTs))
                      : '-',
                  "endTime": dailyRep[j].signOutTimeTs != 0
                      ? DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(dailyRep[j].signOutTimeTs))
                      : '-',
                  "extras": (dailyRep[j].durationInHrs - 9) > 0 ? (dailyRep[j].durationInHrs - 9).toString() : "0",
                  "late": getTimeString(dailyRep[j].lateInMins),
                  "display": dailyRep[j].leaveType == 'sick'
                      ? 'Leave: Sick'
                      : dailyRep[j].leaveType == 'planned'
                          ? 'Leave: planned'
                          : 'Your working hours'
                });

                if (dailyRep[j].durationInHrs == 0)
                  leaveDays.add(DateTime.fromMillisecondsSinceEpoch(dailyRep[j].dateTs * 1000));
                else
                  workingDays.add(DateTime.fromMillisecondsSinceEpoch(dailyRep[j].dateTs * 1000));

                //Adding Events
                _events[DateTime.fromMillisecondsSinceEpoch(dailyRep[j].dateTs * 1000)] = [
                  dailyRep[j].leaveType == 'sick'
                      ? 'Leave: Sick'
                      : dailyRep[j].leaveType == 'planned'
                          ? 'Leave: planned'
                          : 'Your working hours'
                ];
              }
              _selectedTile = Map();

              for (var i = 0; i < tileData.length; i++) {
                if (tileData[i]['date'] == _selectedDate) _selectedTile = tileData[i];
              }

              DateTime next;
              if (now.month == 12) {
                next = DateTime(now.year + 1, 1, 1);
              } else
                next = DateTime(now.year, now.month + 1, 1);

              DateTime n = DateTime(now.year, now.month, 1);

              int days = next.difference(n).inDays;
              print("Difference" + days.toString());

              for (int i = 0; i < days; i++) {
                if (!_events.containsKey(DateTime(now.year, now.month, i + 1))) {
                  _events[DateTime(now.year, now.month, i + 1)] = ["Weekly Off"];
                }
              }
            }
          }
          return Scaffold(
              backgroundColor: AppColor.blackHaze,
              // appBar: MyAppBar(
              //   myTitle: Text(
              //     'My Calendar',
              //     style: TextStyle(color: Colors.black),
              //   ),
              //   centerTitle: true,
              // ),
              body: (state is UserReportLoaded)
                  ? SingleChildScrollView(
                      child: SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          //calendar here
                          children: [
//                        Expanded(
//                          flex: 3,
//                          child: SfDateRangePicker(
//                            headerStyle: DateRangePickerHeaderStyle(textAlign: TextAlign.center),
//                            minDate: DateTime(DateTime.now().year, DateTime.now().month),
//                            maxDate: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
//                            selectionTextStyle: TextStyle(color: AppColor.white),
//                            //showNavigationArrow: true,
//                            onSelectionChanged: _onSelectionChanged,
//                            monthViewSettings: DateRangePickerMonthViewSettings(
//                              //weekendDays: List<int>()..add(6)..add(7),
//                              specialDates: leaveDays,
//
//                              // blackoutDates: List<DateTime>()
//                              //   ..add(
//                              //     DateTime(2020, 10, 7),
//                              //   ),
//                            ),
//                            monthCellStyle: DateRangePickerMonthCellStyle(
//                              // weekendDatesDecoration: BoxDecoration(
//                              //     color: AppColor.saffron,
//                              //     border: Border.all(color: AppColor.saffron, width: 1),
//                              //     shape: BoxShape.circle),
//                              cellDecoration: BoxDecoration(
//                                // image: DecorationImage(
//                                //   image: AssetImage('assets/icons/icon.png'),
//                                // ),
//                                color: AppColor.shamrockGreen,
//                                border: Border.all(color: AppColor.shamrockGreen, width: 1),
//                                shape: BoxShape.circle,
//                              ),
//                              specialDatesDecoration: BoxDecoration(
//                                color: AppColor.saffron,
//                                border: Border.all(color: AppColor.saffron, width: 1),
//                                shape: BoxShape.circle,
//                              ),
//                            ),
//                          ),
//                        ),
                            Flexible(
                              child: Container(
                                color: AppColor.blackHaze,
                                margin: EdgeInsets.only(bottom: 10),
                                child: TableCalendar(
                                  initialSelectedDay: now,
                                  availableGestures: AvailableGestures.none,
                                  calendarController: _calendarController,
                                  initialCalendarFormat: CalendarFormat.month,
                                  daysOfWeekStyle: DaysOfWeekStyle(
                                    weekdayStyle:
                                        TextStyle(color: const Color(0xFF616161), fontWeight: FontWeight.bold),
                                    weekendStyle:
                                        TextStyle(color: const Color(0xFF616161), fontWeight: FontWeight.bold),
                                  ),
                                  events: _events,
                                  startingDayOfWeek: StartingDayOfWeek.sunday,
                                  //endDay: DateTime.now(),
                                  calendarStyle: CalendarStyle(
                                    outsideDaysVisible: false,
                                    markersPositionBottom: 10,
                                    contentPadding: EdgeInsets.only(bottom: 0, left: 8, right: 8),
                                    weekdayStyle: const TextStyle(
                                        color: AppColor.textDark,
                                        fontSize: 13,
                                        fontFamily: 'Product Sans',
                                        fontWeight: FontWeight.w400),
                                    weekendStyle: const TextStyle(
                                        color: AppColor.textDark,
                                        fontSize: 13,
                                        fontFamily: 'Product Sans',
                                        fontWeight: FontWeight.w400),
                                    outsideStyle: const TextStyle(
                                        color: AppColor.textLight,
                                        fontSize: 13,
                                        fontFamily: 'Product Sans',
                                        fontWeight: FontWeight.w400),
                                    selectedStyle: const TextStyle(
                                        color: AppColor.textDark,
                                        fontSize: 15,
                                        fontFamily: 'Product Sans',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  selectedBoxDecoration:
                                      BoxDecoration(shape: BoxShape.rectangle, border: Border.all(color: Colors.black)),
                                  selectionMargin: EdgeInsets.only(right: 15, left: 15, top: 15, bottom: 15),
                                  headerStyle: HeaderStyle(
                                    formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
                                    centerHeaderTitle: true,
                                    formatButtonVisible: false,
                                    titleTextStyle: TextStyle(
                                      color: AppColor.textDark,
                                      fontSize: 16,
                                      fontFamily: 'Product Sans',
                                    ),
                                    headerMargin: EdgeInsets.only(bottom: 15),
                                  ),
                                  onDaySelected: _onDaySelected,
                                  onVisibleDaysChanged: _onVisibleDaysChanged,
                                  builders: CalendarBuilders(singleMarkerBuilder: (context, daytime, event) {
                                    return Container(
                                      height: 2,
                                      width: 32,
                                      color: getColorsFromEvent(event),
                                    );
                                  }),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Container(
                                width: ScreenUtil().screenWidth,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(Sizes.dimen_40),
                                  ),
                                  color: AppColor.white,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: Sizes.dimen_18.h,
                                    ),
//                                Row(
//                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                  children: [
//                                    Row(
//                                      children: [
//                                        Container(
//                                          height: 30,
//                                          width: 30,
//                                          decoration:
//                                              BoxDecoration(shape: BoxShape.circle, color: AppColor.shamrockGreen),
//                                        ),
//                                        SizedBox(
//                                          width: Sizes.dimen_10.w,
//                                        ),
//                                        Text('Working day'),
//                                      ],
//                                    ),
//                                    Row(
//                                      children: [
//                                        Container(
//                                          height: 30,
//                                          width: 30,
//                                          decoration: BoxDecoration(shape: BoxShape.circle, color: AppColor.saffron),
//                                        ),
//                                        SizedBox(
//                                          width: Sizes.dimen_10.w,
//                                        ),
//                                        Text('Off day'),
//                                      ],
//                                    ),
//                                  ],
//                                ),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 25),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                'Weekly off',
                                                style: TextStyle(
                                                    fontSize: 10, fontFamily: "Product Sans", color: AppColor.textDark),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 9),
                                                height: 2,
                                                width: 32,
                                                color: AppColor.salmon,
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'Sick Leave',
                                                style: TextStyle(
                                                    fontSize: 10, fontFamily: "Product Sans", color: AppColor.textDark),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 9),
                                                height: 2,
                                                width: 32,
                                                color: AppColor.saffron,
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'Working Day',
                                                style: TextStyle(
                                                    fontSize: 10, fontFamily: "Product Sans", color: AppColor.textDark),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 9),
                                                height: 2,
                                                width: 32,
                                                color: AppColor.shamrockGreen,
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'Planned Leave',
                                                style: TextStyle(
                                                    fontSize: 10, fontFamily: "Product Sans", color: AppColor.textDark),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 9),
                                                height: 2,
                                                width: 32,
                                                color: AppColor.lightBlue,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: Sizes.dimen_18.h,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          //_selectedTile["date"],
                                          _selectedDate,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.textTitleDark,
                                              fontFamily: 'Product Sans'),
                                        ),
                                        Text(
                                          _selectedTile.containsKey('display')
                                              ? _selectedTile['display']
                                              : 'Weekly off',
                                          style: TextStyle(
                                              fontSize: 20, color: AppColor.textTitleDark, fontFamily: 'Product Sans'),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: Sizes.dimen_14.h,
                                    ),
                                    Container(
                                      color: getColorsFromEvent(_selectedTile.containsKey('display')
                                          ? _selectedTile['display']
                                          : 'Weekly off'),
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
                                                subTitle: _selectedTile.containsKey('startTime')
                                                    ? _selectedTile['startTime']
                                                    : '-',
                                              ),
                                              MyActivityColumn(
                                                title: 'Sign Out',
                                                subTitle: _selectedTile.containsKey('endTime')
                                                    ? _selectedTile['endTime']
                                                    : '-',
                                              ),
                                              MyActivityColumn(
                                                title: 'Extras',
                                                subTitle:
                                                    _selectedTile.containsKey('extras') ? _selectedTile['extras'] : '-',
                                              ),
                                              MyActivityColumn(
                                                title: 'Late',
                                                subTitle:
                                                    _selectedTile.containsKey('late') ? _selectedTile['late'] : '-',
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
                                        Navigator.of(context).pushNamed('apply-leave-screen').then((value) {
                                          _userReportBloc
                                            ..add(UserReportEvent(endDate: _endDate, startDate: _startDate));
                                          //setState(() {});
                                        });
                                      },
                                      buttonColor: AppColor.lightBlue,
                                      isTrailingPresent: false,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: Sizes.dimen_32.w,
                                        vertical: Sizes.dimen_14.h,
                                      ),
                                    ),
                                    SizedBox(
                                      height: Sizes.dimen_14.h,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ));
        },
      ),
    );
  }

  getColorsFromEvent(event) {
    if (event == 'Leave: Sick') {
      return AppColor.saffron;
    } else if (event == 'Your working hours') {
      return AppColor.shamrockGreen;
    } else if (event == 'Leave: planned') {
      return AppColor.lightBlue;
    } else if (event == 'Weekly Off') {
      return AppColor.salmon;
    } else
      return AppColor.salmon;
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
