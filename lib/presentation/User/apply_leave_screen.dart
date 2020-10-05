import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:roster_app/common/screenutils/screen_utils.dart';
import 'package:roster_app/common/size_constants.dart';
import 'package:roster_app/common/string_constants.dart';
import 'package:roster_app/common/themes/theme_color.dart';
import 'package:roster_app/presentation/common/custom_form_field.dart';
import 'package:roster_app/presentation/common/custom_input_box.dart';
import 'package:roster_app/presentation/common/my_decoration_box.dart';
import 'package:roster_app/presentation/common/my_raised_button.dart';
import 'package:roster_app/presentation/common/myappbar.dart';
import 'package:roster_app/common/size_extension.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ApplyLeaveScreen extends StatefulWidget {
  @override
  _ApplyLeaveScreenState createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  final _formKey = GlobalKey<FormState>();
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
    return Container(
      decoration: MyDecorationBox(),
      child: Scaffold(
        appBar: MyAppBar(myTitle: 'Leave'),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Sizes.dimen_100.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: Sizes.dimen_24.w),
              child: Text(
                StringConstants.applyLeaveScreenTitleText,
                style: Theme.of(context).textTheme.headline5.copyWith(
                      color: AppColor.white,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: Sizes.dimen_24.w),
              child: Text(StringConstants.applyLeaveScreenSubTitleText,
                  style: Theme.of(context).textTheme.subtitle1.copyWith(color: AppColor.white)),
            ),
            SizedBox(
              height: Sizes.dimen_100.h,
            ),
            Flexible(
              child: Form(
                key: _formKey,
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
                        IconButton(
                          icon: Icon(Icons.calendar_today_rounded),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Pick date'),
                                  content: Container(
                                    width: Sizes.dimen_300.w,
                                    height: Sizes.dimen_350.h,
                                    child: SfDateRangePicker(
                                      selectionMode: DateRangePickerSelectionMode.range,
                                      showNavigationArrow: true,
                                      onSelectionChanged: _onSelectionChanged,
                                    ),
                                  ),
                                  actions: [
                                    FlatButton(
                                      child: Text('Ok'),
                                      onPressed: () {},
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        SizedBox(
                          height: Sizes.dimen_40.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: Sizes.dimen_24.w,
                            //top: Sizes.dimen_24.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [Text('Start Date'), Text(_startDate)],
                              ),
                              Column(
                                children: [Text('End Date'), Text(_endDate)],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Sizes.dimen_40.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: Sizes.dimen_24.w),
                          child: CustomFormField(
                            isRequired: false,
                            title: 'Type of Leave',
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField(
                                value: 'Sick Leave',
                                items: [
                                  DropdownMenuItem<String>(
                                    child: Text('Sick Leave'),
                                    value: 'Sick Leave',
                                  )
                                ],
                                onChanged: (_) {},
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Sizes.dimen_24.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: Sizes.dimen_24.w),
                          child: CustomInputBox(
                            title: 'Reason',
                            onChanged: (_) {},
                            keyboardType: TextInputType.multiline,
                          ),
                        ),
                        SizedBox(
                          height: Sizes.dimen_24.h,
                        ),
                        MyRaisedButton(
                          buttonTitle: 'Apply Now',
                          buttonColor: AppColor.lightBlue,
                          isTrailingPresent: true,
                          padding: EdgeInsets.symmetric(
                            horizontal: Sizes.dimen_20.w,
                            vertical: Sizes.dimen_18.h,
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed('/qr-scan-screen');
                          },
                        ),
                        SizedBox(
                          height: Sizes.dimen_10.h,
                        ),
                      ],
                    ),
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
