import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:roster_app/common/screenutils/screen_utils.dart';
import 'package:roster_app/common/size_constants.dart';
import 'package:roster_app/common/size_extension.dart';
import 'package:roster_app/common/themes/theme_color.dart';
import 'package:roster_app/presentation/common/dashboard_appbar.dart';
import 'package:roster_app/presentation/common/my_decoration_box.dart';
import 'package:roster_app/presentation/common/my_raised_button.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = 'Chadwick B';

  bool _isSignedIn = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: MyDecorationBox(),
      child: Scaffold(
        appBar: DashboardAppBar(myTitle: ''),
        //bottomNavigationBar: MyBottomNav(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Sizes.dimen_20.h,
            ),
            // FractionallySizedBox(
            //   heightFactor: 0.04,
            // ),
            Padding(
              padding: EdgeInsets.only(left: Sizes.dimen_24.w),
              child: Text(
                'Hi, ' + _userName,
                style: Theme.of(context).textTheme.headline5.copyWith(
                      color: AppColor.white,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: Sizes.dimen_24.w),
              child: Text(DateFormat('EEEE, d MMM y').format(DateTime.now()),
                  style: Theme.of(context).textTheme.subtitle1.copyWith(color: AppColor.white)),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Sizes.dimen_24.w,
                top: Sizes.dimen_24.h,
              ),
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.caption.copyWith(color: AppColor.white),
                child: Row(
                  children: [
                    Column(
                      children: [Text('Start Time'), Text('10:00 AM')],
                    ),
                    SizedBox(
                      width: Sizes.dimen_48.w,
                    ),
                    Column(
                      children: [Text('End Time'), Text('07:00 PM')],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: Sizes.dimen_4.h,
              ),
            ),
            Center(
              child: MyRaisedButton(
                buttonTitle: _isSignedIn ? 'SIGN OUT' : 'SIGN IN',
                onPressed: () {},
                buttonColor: AppColor.eastBay,
                padding: EdgeInsets.symmetric(
                  horizontal: Sizes.dimen_48.w,
                  vertical: Sizes.dimen_14.h,
                ),
                isTrailingPresent: false,
              ),
            ),
            Expanded(
              child: SizedBox(
                height: Sizes.dimen_4.h,
              ),
            ),
            Expanded(
              flex: 24,
              child: Container(
                width: ScreenUtil().screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Sizes.dimen_40),
                  ),
                  color: AppColor.blackHaze,
                ),
                child: _isSignedIn
                    ? Padding(
                        padding: EdgeInsets.only(left: Sizes.dimen_0.w),
                        child: Column(
                          children: [
                            SizedBox(
                              height: Sizes.dimen_48.h,
                            ),
                            Text(
                              'Your working hours.',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(
                              height: Sizes.dimen_10.h,
                            ),
                            Image.asset(
                              'assets/images/Frame.png',
                              height: Sizes.dimen_200,
                            ),
                            SizedBox(height: Sizes.dimen_10.h),
                            MyRaisedButton(
                              buttonTitle: 'Check-in',
                              buttonColor: AppColor.lightBlue,
                              isTrailingPresent: false,
                              padding: EdgeInsets.symmetric(
                                horizontal: Sizes.dimen_20.w,
                                vertical: Sizes.dimen_18.h,
                              ),
                              onPressed: () {
                                Navigator.of(context).pushNamed('/');
                              },
                            ),
                            SizedBox(
                              height: Sizes.dimen_10.h,
                            ),
                            Text('Checkin time : 9:15 am'),
                            SizedBox(
                              height: Sizes.dimen_100.h,
                            )
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: Sizes.dimen_4.h,
                            ),
                          ),
                          Image.asset(
                            'assets/images/Frame.png',
                            height: Sizes.dimen_200.h,
                          ),
                          Expanded(child: SizedBox(height: Sizes.dimen_4.h)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed('/apply-leave-screen');
                                },
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      'assets/images/unwell_bg.png',
                                      height: 138,
                                    ),
                                    Positioned(
                                      left: Sizes.dimen_20,
                                      top: Sizes.dimen_12,
                                      child: Image.asset(
                                        'assets/images/unwell.png',
                                        height: 61,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                  child: Stack(
                                children: [
                                  Image.asset(
                                    'assets/images/late_bg.png',
                                    height: 138,
                                  ),
                                  Positioned(
                                    left: Sizes.dimen_20,
                                    top: Sizes.dimen_12,
                                    child: Image.asset(
                                      'assets/images/running_late.png',
                                      height: 61,
                                    ),
                                  )
                                ],
                              )),
                            ],
                          ),
                          Expanded(
                            child: SizedBox(
                              height: Sizes.dimen_4.h,
                            ),
                          )
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
