import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:roster_app/common/screenutils/screen_utils.dart';
import 'package:roster_app/common/size_constants.dart';
import 'package:roster_app/common/string_constants.dart';
import 'package:roster_app/common/themes/theme_color.dart';
import 'package:roster_app/di/get_it.dart';
import 'package:roster_app/domain/apply_leave_bloc/apply_leave_bloc.dart';
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
  final _applyLeaveBloc = getIt<ApplyLeaveBloc>();
  final _formKey = GlobalKey<FormState>();
  String _startDate = DateFormat('EEEE dd,MMMM').format(DateTime.now());
  String _endDate = DateFormat('EEEE dd,MMMM').format(DateTime.now());
  String _leaveType;
  String _reason;

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
    return BlocProvider<ApplyLeaveBloc>(
      create: (context) => _applyLeaveBloc,
      child: BlocConsumer<ApplyLeaveBloc, ApplyLeaveState>(
        listener: (context, state) {
          if (state.successOrFailure != null) {
            state.successOrFailure.fold(
              (failure) => FlushbarHelper.createError(
                message: failure.map(
                  cancelledByUser: (_) => 'cancelled ',
                  serverError: (_) => 'Server error! Contact support',
                  invalidUsernamePasscodeCombination: (_) => 'Invalid Username & passcode combination',
                  noInternetConnectivity: (_) => 'No Internet connectivity',
                ),
              ).show(context),
              (r) {
                Navigator.of(context).pop();
                return FlushbarHelper.createSuccess(message: 'Leave request submitted successfully.').show(context);
              },
            );
          }
        },
        builder: (context, state) => Container(
          decoration: MyDecorationBox(),
          child: Scaffold(
            appBar: MyAppBar(myTitle: Text('My Calendar')),
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
                Expanded(
                  child: SizedBox(
                    height: Sizes.dimen_4.h,
                  ),
                ),
                Expanded(
                  flex: 12,
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              flex: 5,
                              child: SizedBox(
                                height: Sizes.dimen_10.h,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColor.anakiwaBlue.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                iconSize: 30,
                                color: AppColor.lightBlue,
                                icon: FaIcon(FontAwesomeIcons.solidCalendarMinus),
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
                            ),
                            Flexible(
                              child: SizedBox(
                                height: Sizes.dimen_8.h,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: Sizes.dimen_24.w,
                                //top: Sizes.dimen_24.h,
                              ),
                              child: DefaultTextStyle.merge(
                                style: TextStyle(color: AppColor.ebonyClay),
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
                            ),
                            Flexible(
                              child: SizedBox(
                                height: Sizes.dimen_24.h,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: Sizes.dimen_24.w),
                              child: CustomFormField(
                                isRequired: false,
                                title: 'Type of Leave',
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(color: AppColor.sandGrey),
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    value: 'Sick Leave',
                                    items: [
                                      DropdownMenuItem<String>(
                                        child: Text('Sick Leave'),
                                        value: 'Sick Leave',
                                      )
                                    ],
                                    onChanged: (value) {
                                      _leaveType = value;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: SizedBox(
                                height: Sizes.dimen_20.h,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: Sizes.dimen_24.w),
                              child: CustomInputBox(
                                title: 'Reason',
                                onChanged: (value) => _reason = value,
                                keyboardType: TextInputType.multiline,
                              ),
                            ),
                            Flexible(
                              child: SizedBox(
                                height: Sizes.dimen_6.h,
                              ),
                            ),
                            MyRaisedButton(
                              buttonTitle: state.isLoading ? 'Please wait...' : 'Apply Now',
                              buttonColor: AppColor.lightBlue,
                              isTrailingPresent: true,
                              padding: EdgeInsets.symmetric(
                                horizontal: Sizes.dimen_20.w,
                                vertical: Sizes.dimen_18.h,
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                }
                                context
                                    .bloc<ApplyLeaveBloc>()
                                    .add(ApplyLeaveEvent(_startDate, _endDate, _leaveType, _reason));
                                // Navigator.of(context).pushNamed('/qr-scan-screen');
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
        ),
      ),
    );
  }
}
