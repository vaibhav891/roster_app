import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:roster_app/common/screenutils/screen_utils.dart';
import 'package:roster_app/common/size_constants.dart';
import 'package:roster_app/common/size_extension.dart';
import 'package:roster_app/common/string_constants.dart';
import 'package:roster_app/common/themes/theme_color.dart';
import 'package:roster_app/presentation/common/dashboard_appbar.dart';
import 'package:roster_app/presentation/common/my_decoration_box.dart';
import 'package:roster_app/presentation/common/my_raised_button.dart';

class MyStatsScreen extends StatefulWidget {
  @override
  _MyStatsScreenState createState() => _MyStatsScreenState();
}

class _MyStatsScreenState extends State<MyStatsScreen> {
  //String _userName = 'Chadwick B';

  //bool _isSignedIn = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: MyDecorationBox(),
      child: Scaffold(
        appBar: DashboardAppBar(myTitle: 'Work Plan'),
        //bottomNavigationBar: MyBottomNav(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Sizes.dimen_100.h,
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
            SizedBox(
              height: Sizes.dimen_100.h,
            ),
            Flexible(
              child: Container(
                width: ScreenUtil().screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Sizes.dimen_40),
                  ),
                  color: AppColor.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: Sizes.dimen_48.h,
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceAround,
                        children: [
                          FlatButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            minWidth: Sizes.dimen_100.w,
                            child: Text('Weekly'),
                            color: Colors.blue,
                            onPressed: () {/** */},
                          ),
                          FlatButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            minWidth: Sizes.dimen_100.w,
                            child: Text('Monthly'),
                            color: AppColor.sandGrey,
                            onPressed: () {
                              Navigator.of(context).pushNamed('/manager-dashboard');
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Sizes.dimen_10.h,
                      ),
                      CircularPercentIndicator(
                        percent: 0.32,
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
                          Image.asset('assets/images/Group95303.png', width: Sizes.dimen_140.w),
                          Image.asset('assets/images/Group95304.png', width: Sizes.dimen_140.w),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
