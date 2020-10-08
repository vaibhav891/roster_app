import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:roster_app/common/screenutils/screen_utils.dart';
import 'package:roster_app/common/size_constants.dart';
import 'package:roster_app/common/themes/theme_color.dart';
import 'package:roster_app/presentation/common/my_raised_button.dart';
import 'package:roster_app/presentation/common/myappbar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:roster_app/common/size_extension.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String _startDate = DateFormat('EEEE dd,MMMM').format(DateTime.now());
  String _endDate = DateFormat('EEEE dd,MMMM').format(DateTime.now());

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _startDate = DateFormat('EEEE dd,MMMM').format(args.value.startDate).toString();
        _endDate = DateFormat('EEEE dd,MMMM').format(args.value.endDate ?? args.value.startDate).toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              showNavigationArrow: true,
              onSelectionChanged: _onSelectionChanged,
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
              child: Column(
                children: [
                  SizedBox(
                    height: Sizes.dimen_18.h,
                  ),
                  Text(
                    '26 Sept 2020',
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
                              subTitle: '9:00 am',
                            ),
                            MyActivityColumn(
                              title: 'Sign Out',
                              subTitle: '6:00 pm',
                            ),
                            MyActivityColumn(
                              title: 'Extras',
                              subTitle: '0:00 hr',
                            ),
                            MyActivityColumn(
                              title: 'Late',
                              subTitle: '0:00 hr',
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
    );
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
