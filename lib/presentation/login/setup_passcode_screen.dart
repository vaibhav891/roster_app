import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roster_app/common/size_constants.dart';
import 'package:roster_app/common/string_constants.dart';
import 'package:roster_app/common/themes/theme_color.dart';
import 'package:roster_app/di/get_it.dart';
import 'package:roster_app/domain/auth/user.dart';
import 'package:roster_app/domain/update_passcode_bloc/update_passcode_bloc.dart';
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
  String _passcode;
  String _rePasscode;
  String _oldPasscode;

  UpdatePasscodeBloc _updatePasscodeBloc;
  @override
  void initState() {
    super.initState();
    _updatePasscodeBloc = getIt<UpdatePasscodeBloc>();
  }

  @override
  void dispose() {
    super.dispose();
    _updatePasscodeBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    _oldPasscode = ModalRoute.of(context).settings.arguments;
    return BlocProvider<UpdatePasscodeBloc>(
        create: (context) => _updatePasscodeBloc,
        child: BlocConsumer<UpdatePasscodeBloc, UpdatePasscodeState>(
          listener: (context, state) {
            if (state is UpdatePasscodeDoneState)
              state.updateFailureOrSuccessOption.fold(
                () => null,
                (either) => either.fold(
                  (failure) {
                    print('inside failure');
                    return FlushbarHelper.createError(
                      message: failure.map(
                        cancelledByUser: (_) => 'cancelled ',
                        serverError: (_) => 'Server error! Contact support',
                        invalidUsernamePasscodeCombination: (_) => 'Invalid Username & passcode combination',
                        noInternetConnectivity: (_) => 'No Internet connectivity',
                      ),
                    ).show(context);
                  },
                  (r) {
                    Navigator.of(context).pushNamed('/user-dashboard');
                  },
                ),
              );
          },
          builder: (context, state) {
            return Container(
              decoration: MyDecorationBox(),
              child: Scaffold(
                appBar: MyAppBar(myTitle: Text('')),
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                    onChanged: (value) => _passcode = value,
                                    hintText: '******',
                                    obscureText: true,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value.isEmpty) return 'Cannot be empty';
                                      return null;
                                    },
                                  ),
                                  CustomInputBox(
                                    title: 'Re-enter Passcode',
                                    onChanged: (value) => _rePasscode = value,
                                    hintText: '******',
                                    obscureText: true,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return 'Cannot be empty';
                                      else if (value != _passcode) return 'Passcodes must be same';
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: Sizes.dimen_100.h,
                                  ),
                                  state is UpdatePasscodeDoneState && state.isSubmitting
                                      ? CircularProgressIndicator()
                                      : MyRaisedButton(
                                          buttonTitle: 'Proceed',
                                          buttonColor: AppColor.lightBlue,
                                          isTrailingPresent: true,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: Sizes.dimen_20.w,
                                            vertical: Sizes.dimen_18.h,
                                          ),
                                          onPressed: () {
                                            if (_formKey.currentState.validate()) {
                                              _formKey.currentState.reset();

                                              BlocProvider.of<UpdatePasscodeBloc>(context).add(
                                                  UpdatePasscodePressedEvent(
                                                      User.instance.userId, _oldPasscode, _passcode));
                                            }
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
          },
        ));
  }
}
