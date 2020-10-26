import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flushbar/flushbar_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roster_app/common/size_constants.dart';
import 'package:roster_app/common/string_constants.dart';
import 'package:roster_app/common/themes/theme_color.dart';
import 'package:roster_app/di/get_it.dart';
import 'package:roster_app/domain/auth/user.dart';
import 'package:roster_app/domain/sign_in_form_bloc/sign_in_form_bloc.dart';
import 'package:roster_app/presentation/common/custom_input_box.dart';
import 'package:roster_app/presentation/common/my_decoration_box.dart';
import 'package:roster_app/presentation/common/my_raised_button.dart';
import 'package:roster_app/presentation/common/myappbar.dart';
import 'package:roster_app/common/size_extension.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //SignInFormBloc signInFormBloc;
  bool _isObscureText = true;

  String _username = '';
  String _username2 = '';
  String _passcode = '';

  String _validator(String value) {
    if (value.isEmpty) {
      return 'Cannot be empty';
    }
    return null;
  }

  final _formKey = GlobalKey<FormState>();

  _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final _key = GlobalKey<FormState>();
        return BlocConsumer<SignInFormBloc, SignInFormState>(
          listener: (context, state) {
            print('inside dialog listener');
            if (state.isRegister) {
              print('inside if');
              state.authFailureOrSuccessOption.fold(
                () => null,
                (either) => either.fold(
                  (failure) {
                    print('inside failure');
                    return FlushbarHelper.createError(message: failure.message
                            // map(
                            //   cancelledByUser: (_) => 'cancelled ',
                            //   serverError: (_) => 'Server error! Contact support',
                            //   invalidUsernamePasscodeCombination: (_) => 'Invalid Username & passcode combination',
                            //   noInternetConnectivity: (_) => 'No Internet connectivity',
                            // ),
                            )
                        .show(context);
                  },
                  (r) {
                    print('inside success');
                    Navigator.of(context).pop();
                    return FlushbarHelper.createSuccess(message: 'Passcode is reset').show(context);
                  },
                ),
              );
            }
          },
          builder: (context, state) {
            return AlertDialog(
              titlePadding: EdgeInsets.symmetric(
                horizontal: Sizes.dimen_18.w,
                vertical: Sizes.dimen_24.h,
              ),
              title: Text(
                'Please enter a valid username',
                style: Theme.of(context).textTheme.headline6,
              ),
              content: Form(
                key: _key,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  initialValue: _username2,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: AppColor.sandGrey,
                    hintText: 'Type in your username',
                  ),
                  onChanged: (value) => _username2 = value,
                  validator: (value) {
                    if (value.isEmpty) return 'Cannot be empty';
                    return null;
                  },
                  onSaved: (newValue) => _username2 = newValue,
                ),
              ),
              actionsPadding: EdgeInsets.only(
                right: Sizes.dimen_32.w,
                bottom: Sizes.dimen_24.h,
              ),
              actions: [
                MyRaisedButton(
                  buttonTitle: state.isSubmitting ? 'Please wait...' : 'Request Passcode',
                  onPressed: () {
                    if (_key.currentState.validate()) {
                      //_key.currentState.reset();
                      _key.currentState.save();
                      print('im here');
                      //add event for register
                      BlocProvider.of<SignInFormBloc>(context).add(RegisterUser(_username2));
                      //context.bloc<SignInFormBloc>().add(RegisterUser(_username2));
                    }
                  },
                  buttonColor: AppColor.lightBlue,
                  isTrailingPresent: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizes.dimen_20.w,
                    vertical: Sizes.dimen_18.h,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    //signInFormBloc = getIt<SignInFormBloc>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc, SignInFormState>(
      listener: (context, state) {
        print('inside login screen build listener');
        if (!state.isRegister) {
          state.authFailureOrSuccessOption.fold(
            () => null,
            (either) => either.fold(
              (failure) {
                print('inside failure');
                return FlushbarHelper.createError(message: failure.message).show(context);
              },
              (r) {
                print('updatePasscode -> $r');
                if (r == 'YES')
                  Navigator.of(context).pushNamed('setup-passcode-screen', arguments: _passcode);
                else {
                  if (User.instance.userRole == 'Manager') {
                    Navigator.of(context).pushNamedAndRemoveUntil('manager-dashboard', (route) => false);
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil('user-dashboard', (route) => false);
                  }
                }
              },
            ),
          );
        }
      },
      builder: (context, state) {
        return Container(
          decoration: MyDecorationBox(),
          child: Scaffold(
              appBar: MyAppBar(myTitle: Text('Login')),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: Sizes.dimen_100.h,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: Sizes.dimen_24.w),
                    child: Text(
                      StringConstants.loginScreenText1,
                      style: Theme.of(context).textTheme.headline5.copyWith(
                            color: AppColor.white,
                          ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: Sizes.dimen_24.w),
                    child: Text(StringConstants.loginScreenText2,
                        style: Theme.of(context).textTheme.subtitle1.copyWith(color: AppColor.white)),
                  ),
                  SizedBox(
                    height: Sizes.dimen_100.h,
                  ),
                  Expanded(
                    flex: 12,
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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: SizedBox(
                                    height: Sizes.dimen_48.h,
                                  ),
                                ),
                                CustomInputBox(
                                  title: 'Username',
                                  onChanged: (value) => _username = value,
                                  hintText: 'Enter your username',
                                  validator: _validator,
                                ),
                                CustomInputBox(
                                  title: 'Passcode',
                                  onChanged: (value) => _passcode = value,
                                  validator: _validator,
                                  hintText: '******',
                                  obscureText: _isObscureText,
                                  keyboardType: TextInputType.number,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                      color: _isObscureText ? Colors.grey : Colors.blue,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isObscureText = !_isObscureText;
                                      });
                                    },
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: Sizes.dimen_32.w),
                                    child: GestureDetector(
                                      onTap: () {
                                        _username2 = _username;
                                        _showDialog();
                                      },
                                      child: Text(
                                        'Forgot Passcode?',
                                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                                              color: AppColor.lightBlue,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: SizedBox(
                                    height: Sizes.dimen_48.h,
                                  ),
                                ),
                                state.isSubmitting && !state.isRegister
                                    ? CircularProgressIndicator()
                                    : MyRaisedButton(
                                        buttonTitle: 'Login to Account',
                                        buttonColor: AppColor.lightBlue,
                                        isTrailingPresent: true,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: Sizes.dimen_20.w,
                                          vertical: Sizes.dimen_18.h,
                                        ),
                                        onPressed: () {
                                          print('inside onPressed');
                                          if (_formKey.currentState.validate()) {
                                            print('inside validate');
                                            //_formKey.currentState.reset();
                                            User.instance.uid = _username;
                                            context.bloc<SignInFormBloc>().add(SignInUser(_username, _passcode));
                                          }
                                          //Navigator.of(context).pushNamed('setup-passcode-screen');
                                        },
                                      ),
                                SizedBox(
                                  height: Sizes.dimen_10.h,
                                ),
                                // RichText(
                                //   textAlign: TextAlign.center,
                                //   text: TextSpan(
                                //     text: 'Not having code yet?',
                                //     style: Theme.of(context).textTheme.bodyText2.copyWith(
                                //           color: AppColor.paleSky,
                                //         ),
                                //     children: <TextSpan>[
                                //       TextSpan(
                                //         text: ' Request now\n',
                                //         style: TextStyle(
                                //           color: AppColor.lightBlue,
                                //         ),
                                //         recognizer: TapGestureRecognizer()
                                //           ..onTap = () {
                                //             print('tapped');
                                //             _showDialog();
                                //           },
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )),
        );
      },
    );
  }
}
