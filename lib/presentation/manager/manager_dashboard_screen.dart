import 'package:flutter/material.dart';
import 'package:roster_app/common/screenutils/screen_utils.dart';
import 'package:roster_app/common/themes/theme_color.dart';
import 'package:roster_app/presentation/common/my_decoration_box.dart';
import 'package:table_calendar/table_calendar.dart';

class ManagerDashboardScreen extends StatefulWidget {
  @override
  _ManagerDashboardScreenState createState() => _ManagerDashboardScreenState();
}

class _ManagerDashboardScreenState extends State<ManagerDashboardScreen> {
  final CalendarController _calendarController = CalendarController();

  @override
  void dispose() {
    super.dispose();
    _calendarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: MyDecorationBox(),
      child: Scaffold(
          // appBar: AppBar(
          //   backgroundColor: Colors.transparent,
          //   title: TableCalendar(
          //     calendarController: _calendarController,
          //     //initialCalendarFormat: CalendarFormat.week,
          //   ),
          // ),
          body: SafeArea(
              child: Column(
        children: [
          DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyText2.copyWith(color: AppColor.white),
            child: TableCalendar(
              calendarController: _calendarController,
              initialCalendarFormat: CalendarFormat.week,
              calendarStyle: CalendarStyle(markersColor: AppColor.white),
            ),
          ),
          Expanded(
            child: Container(
              width: ScreenUtil().screenWidth,
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  DropdownButton<String>(
                    items: [
                      DropdownMenuItem(
                        child: Text('VR Mall Bengaluru'),
                        value: 'VR Mall Bengaluru',
                      ),
                      DropdownMenuItem(
                        child: Text('AR Mall Bengaluru'),
                        value: 'AR Mall Bengaluru',
                      ),
                      DropdownMenuItem(
                        child: Text('GR Mall Bengaluru'),
                        value: 'GR Mall Bengaluru',
                      ),
                    ],
                    onChanged: (_) {},
                    value: 'VR Mall Bengaluru',
                  )
                ],
              ),
            ),
          )
        ],
      ))

          // Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     SizedBox(
          //       height: Sizes.dimen_100.h,
          //     ),
          //   ],
          // ),
          ),
    );
  }
}
