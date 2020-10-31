import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:roster_app/common/screenutils/screen_utils.dart';
import 'package:roster_app/common/size_constants.dart';
import 'package:roster_app/common/size_extension.dart';
import 'package:roster_app/common/themes/theme_color.dart';
import 'package:roster_app/data/data_sources/remote_data_src.dart';
import 'package:roster_app/di/get_it.dart';
import 'package:roster_app/domain/auth/auth_failure.dart';
import 'package:roster_app/domain/auth/user.dart';
import 'package:roster_app/domain/home_bloc/home_bloc.dart';
import 'package:roster_app/domain/sign_in_form_bloc/sign_in_form_bloc.dart';
import 'package:roster_app/presentation/common/my_decoration_box.dart';
import 'package:roster_app/presentation/common/my_raised_button.dart';
import 'package:roster_app/presentation/common/show_duration_picker.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //bool _isSignedIn = false;
  Position position;
  Duration _duration = Duration(hours: 0, minutes: 0);
  bool rosterPresent = true;

  RemoteDataSrc _remoteDataSrc = getIt<RemoteDataSrc>();
  double siteLat;
  double siteLong;
  num radiusInMeters;

  _showMoveCloser(bldContext) {
    showDialog(
      context: bldContext,
      builder: (context) {
        return AlertDialog(
          title: Text('Move closer'),
          content: Text('You seem to be at a distance from the site. Please move closer and try again'),
          actions: [
            FlatButton(onPressed: () => Navigator.of(context).pop(), child: Text('Ok')),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(HomeInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    // int endTime = User.instance.endTime != null && User.instance.endTime != 0 ? User.instance.endTime : 0;
    // int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 60;
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.failure != AuthFailure(""))
          return FlushbarHelper.createError(message: state.failure.message).show(context);
      },
      builder: (context, state) {
        rosterPresent = User.instance.startTime != null && User.instance.startTime != 0;
        return Container(
          decoration: MyDecorationBox(),
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              //leading: IconButton(icon: Icon(Icons.dehaze_outlined), onPressed: () {}),
              actions: [
                FlatButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Log Out'),
                          content: Text('Do you really want to logout?'),
                          actions: [
                            FlatButton(onPressed: () => Navigator.of(context).pop(), child: Text('No')),
                            FlatButton(
                                onPressed: () {
                                  BlocProvider.of<SignInFormBloc>(context).add(SignInFormEvent.signOutUser());
                                  Navigator.of(context).pushNamedAndRemoveUntil('login', (route) => false);
                                },
                                child: Text('Yes')),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(fontSize: Sizes.dimen_20.sp, color: AppColor.white),
                  ),
                ),
                // IconButton(
                //     icon: Icon(
                //       Icons.notifications_none_outlined,
                //     ),
                //     onPressed: () {})
              ],
              title: Text(''),
              backgroundColor: Colors.transparent,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Sizes.dimen_20.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: Sizes.dimen_24.w),
                  child: Text(
                    'Hi, ' + User.instance.userId ?? 'There',
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
                    style: Theme.of(context).textTheme.bodyText2.copyWith(color: AppColor.white),
                    child: rosterPresent && !User.instance.isOnLeave
                        ? Row(
                            children: [
                              Column(
                                children: [
                                  Text('Start Time'),
                                  Text(User.instance.startTime == 0 || User.instance.startTime == null
                                      ? '-'
                                      : DateFormat.Hm().format(
                                          DateTime.fromMillisecondsSinceEpoch(User.instance.startTime),
                                        ))
                                ],
                              ),
                              SizedBox(
                                width: Sizes.dimen_48.w,
                              ),
                              Column(
                                children: [
                                  Text('End Time'),
                                  Text(User.instance.endTime == 0 || User.instance.endTime == null
                                      ? '-'
                                      : DateFormat.Hm().format(
                                          DateTime.fromMillisecondsSinceEpoch(User.instance.endTime),
                                        ))
                                ],
                              )
                            ],
                          )
                        : Text('No roster for today'),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: Sizes.dimen_4.h,
                  ),
                ),
                Center(
                  child: !User.instance.isOnLeave && rosterPresent
                      ? MyRaisedButton(
                          buttonTitle: state.isSignInLoading
                              ? 'Please wait...'
                              : state.isSignedIn
                                  ? 'SIGN OUT'
                                  : 'SIGN IN',
                          onPressed: () async {
                            print('tapped');
                            try {
                              position = await getCurrentPosition();
                              if (!state.isSignedIn) {
                                var failureOrSuccess = await _remoteDataSrc.fetchUserSite();
                                if (failureOrSuccess.isRight()) {
                                  failureOrSuccess.fold(
                                    (l) => print('error getting user site'),
                                    (r) {
                                      if (r.sites.length > 0) {
                                        siteLat = r.sites.first.location.latitude;
                                        siteLong = r.sites.first.location.longitude;
                                        radiusInMeters = r.sites.first.radiusInMeter;
                                      }
                                      return null;
                                    },
                                  );
                                }
                                double distanceInMeters =
                                    distanceBetween(siteLat, siteLong, position.latitude, position.longitude);
                                print('Distance b/w sites -> $distanceInMeters');

                                if (distanceInMeters > radiusInMeters) {
                                  return _showMoveCloser(context);
                                }
                              }
                            } on PermissionDeniedException {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Access required'),
                                    content: Text(
                                        'Location is required for user to signin into site. You can turn it on again from Settings.'),
                                    actions: [
                                      FlatButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: Text('Ok'),
                                      )
                                    ],
                                  );
                                },
                              );
                            } catch (ex) {
                              print("Error details: ${ex.details}");
                            }

                            BlocProvider.of<HomeBloc>(context)
                                .add(SignInSignOutEvent(position.latitude, position.longitude));
                          },
                          buttonColor: AppColor.eastBay,
                          padding: EdgeInsets.symmetric(
                            horizontal: Sizes.dimen_48.w,
                            vertical: Sizes.dimen_14.h,
                          ),
                          isTrailingPresent: false,
                        )
                      : SizedBox(
                          height: Sizes.dimen_10.h,
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
                    child: rosterPresent
                        ? User.instance.isOnLeave
                            ? Center(
                                child: Text('You are on leave today.', style: Theme.of(context).textTheme.headline5))
                            : state.isSignedIn
                                ? Padding(
                                    padding: EdgeInsets.only(left: Sizes.dimen_0.w),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: Sizes.dimen_4.h,
                                          ),
                                        ),
                                        Text(
                                          'Your work duration remaining.',
                                          style: Theme.of(context).textTheme.headline6,
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            height: Sizes.dimen_10.h,
                                          ),
                                        ),
                                        // Image.asset(
                                        //   'assets/images/Frame.png',
                                        //   height: Sizes.dimen_200,
                                        // ),
                                        CountdownTimer(
                                          endTime:
                                              // User.instance.shiftSignInTime != 0 &&
                                              //         User.instance.shiftSignInTime != null
                                              //     ? User.instance.shiftSignInTime +
                                              //         User.instance.duration -
                                              //         ((User.instance.workDurationInMins ?? 0) * 60 * 1000)
                                              //     :
                                              // DateTime.now().millisecondsSinceEpoch +
                                              //     User.instance.duration -
                                              //     (User.instance.workDurationInMins * 60 * 1000),
                                              User.instance.shiftEndTime,
                                          daysSymbol: Text('days'),
                                          emptyWidget: Text(
                                            '00:00:00',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2
                                                .copyWith(color: AppColor.lightBlue),
                                          ),
                                          widgetBuilder: (context, time) {
                                            //print('inside timer');
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.timer,
                                                  size: 100,
                                                  color: AppColor.lightBlue,
                                                ),
                                                Text(
                                                  time != null
                                                      ? '${time.hours != null ? time.hours.toString().padLeft(2, '0') : '00'}:${time.min != null ? time.min.toString().padLeft(2, '0') : '00'}:${time.sec.toString().padLeft(2, '0')}'
                                                      : '00:00:00',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline2
                                                      .copyWith(color: AppColor.lightBlue),
                                                ),
                                              ],
                                            );
                                          },
                                        ),

                                        Expanded(child: SizedBox(height: Sizes.dimen_10.h)),
                                        // MyRaisedButton(
                                        //   buttonTitle: state.isCheckInLoading
                                        //       ? 'Please wait...'
                                        //       : state.isCheckedIn
                                        //           ? 'Check-out'
                                        //           : 'Check-in',
                                        //   buttonColor: AppColor.lightBlue,
                                        //   isTrailingPresent: false,
                                        //   padding: EdgeInsets.symmetric(
                                        //     horizontal: Sizes.dimen_20.w,
                                        //     vertical: Sizes.dimen_18.h,
                                        //   ),
                                        //   onPressed: () async {
                                        //     User.instance.checkInTime =
                                        //         DateFormat.jm().format(DateTime.now()).toString();
                                        //     var taskId = state.isCheckedIn
                                        //         ? User.instance.taskId.toString()
                                        //         : '83b921b5-8be6-4322-b6b0-60ca5f4e9033';
                                        //     BlocProvider.of<HomeBloc>(context).add(CheckInCheckOutEvent(id: taskId));
                                        //   },
                                        // ),
                                        // Expanded(
                                        //   child: SizedBox(
                                        //     height: Sizes.dimen_4.h,
                                        //   ),
                                        // ),
                                        // state.isCheckedIn
                                        //     ? Text('Checkin time : ${User.instance.checkInTime}')
                                        //     : Container(),
                                        Expanded(
                                          child: SizedBox(
                                            height: Sizes.dimen_4.h,
                                          ),
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
                                      // Image.asset(
                                      //   'assets/images/Frame.png',
                                      //   height: Sizes.dimen_200.h,
                                      // ),
                                      Column(
                                        children: [
                                          Text(
                                            'Your work duration',
                                            style: Theme.of(context).textTheme.headline5,
                                          ),
                                          Text(
                                            () {
                                              return _getTimeString(User.instance.endTime - User.instance.startTime);
                                            }(),
                                            style: Theme.of(context).textTheme.headline2,
                                          )
                                        ],
                                      ),
                                      Expanded(child: SizedBox(height: Sizes.dimen_4.h)),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pushNamed('apply-leave-screen').then((value) {
                                              BlocProvider.of<HomeBloc>(context).add(HomeInitialEvent());

                                              //setState(() {});
                                            });
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
                                            onTap: () async {
                                              _duration = await showDurationPicker(
                                                  context: context, initialTime: Duration(minutes: 0));

                                              print(_duration);
                                              if (_duration != null) {
                                                var failureOrSuccess = await getIt<RemoteDataSrc>()
                                                    .runningLate(duration: _duration.inMinutes);
                                                failureOrSuccess.fold(
                                                  (l) => FlushbarHelper.createError(message: l.message).show(context),
                                                  (r) => FlushbarHelper.createSuccess(message: 'Submit successful')
                                                      .show(context),
                                                );
                                              }
                                            },
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
                                      ]),
                                      Expanded(
                                        child: SizedBox(
                                          height: Sizes.dimen_4.h,
                                        ),
                                      )
                                    ],
                                  )
                        :
                        //roster not present
                        Center(
                            child: Text(
                              'No roster for today',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getTimeString(int value) {
    final int timeInSec = value ~/ (1000 * 60);
    final int hour = timeInSec ~/ 60;
    final int minutes = timeInSec % 60;
    return '${hour.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")} hr';
  }
}
