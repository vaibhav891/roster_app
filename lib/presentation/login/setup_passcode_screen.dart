import 'package:flutter/material.dart';
import 'package:roster_app/common/size_constants.dart';
import 'package:roster_app/common/string_constants.dart';
import 'package:roster_app/common/themes/theme_color.dart';
import 'package:roster_app/presentation/common/custom_input_box.dart';
import 'package:roster_app/presentation/common/my_decoration_box.dart';
import 'package:roster_app/presentation/common/my_raised_button.dart';
import 'package:roster_app/presentation/common/myappbar.dart';
import 'package:roster_app/common/size_extension.dart';

class SetupPasscodeScreen extends StatefulWidget {
  @override
  _SetupPasscodeScreenState createState() => _SetupPasscodeScreenState();
}

class _SetupPasscodeScreenState extends State<SetupPasscodeScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: MyDecorationBox(),
      child: Scaffold(
        appBar: MyAppBar(myTitle: ''),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Sizes.dimen_100.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: Sizes.dimen_24.w),
              child: Text(
                StringConstants.setupPasscodeScreenTitleText,
                style: Theme.of(context).textTheme.headline5.copyWith(
                      color: AppColor.white,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: Sizes.dimen_24.w),
              child: Text(StringConstants.setupPasscodeScreenSubTitleText,
                  style: Theme.of(context).textTheme.subtitle1.copyWith(color: AppColor.white)),
            ),
            SizedBox(
              height: Sizes.dimen_100.h,
            ),
            Flexible(
              child: Form(
                key: _formKey,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(Sizes.dimen_40),
                    ),
                    color: AppColor.white,
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(left: Sizes.dimen_24.w),
                      child: Column(
                        children: [
                          SizedBox(
                            height: Sizes.dimen_48.h,
                          ),
                          CustomInputBox(
                            title: 'Enter new passcode',
                            onChanged: (value) {},
                            hintText: '******',
                            obscureText: true,
                          ),
                          CustomInputBox(
                            title: 'Re-enter Passcode',
                            onChanged: (value) {},
                            hintText: '******',
                            obscureText: true,
                          ),
                          SizedBox(
                            height: Sizes.dimen_100.h,
                          ),
                          MyRaisedButton(
                            buttonTitle: 'Proceed',
                            buttonColor: AppColor.lightBlue,
                            isTrailingPresent: true,
                            padding: EdgeInsets.symmetric(
                              horizontal: Sizes.dimen_20.w,
                              vertical: Sizes.dimen_18.h,
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed('/user-dashboard');
                            },
                          ),
                          SizedBox(
                            height: Sizes.dimen_100.h,
                          ),
                        ],
                      ),
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
