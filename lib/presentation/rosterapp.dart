import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:roster_app/common/screenutils/screen_utils.dart';
import 'package:roster_app/common/themes/theme_color.dart';
import 'package:roster_app/di/get_it.dart';
import 'package:roster_app/domain/auth/user.dart';
import 'package:roster_app/domain/home_bloc/home_bloc.dart';
import 'package:roster_app/domain/sign_in_form_bloc/sign_in_form_bloc.dart';
import 'package:roster_app/presentation/User/apply_leave_screen.dart';
import 'package:roster_app/presentation/User/qr_scan_screen.dart';
import 'package:roster_app/presentation/User/user_dashboard_screen.dart';
import 'package:roster_app/presentation/common/lifecycle_event_handler.dart';
import 'package:roster_app/presentation/login/login_screen.dart';
import 'package:roster_app/presentation/login/setup_passcode_screen.dart';
import 'package:roster_app/presentation/manager/Notification/notification_list_screen.dart';
import 'package:roster_app/presentation/manager/manager_dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RosterApp extends StatefulWidget {
  @override
  _RosterAppState createState() => _RosterAppState();
}

class _RosterAppState extends State<RosterApp> {
  final SignInFormBloc signInFormBloc = getIt<SignInFormBloc>();

  final HomeBloc homeBloc = getIt<HomeBloc>();
  SharedPreferences prefs;

  _initializeSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('token')) {
      User.instance.token = prefs.getString('token');
      Map<String, dynamic> decodedToken = JwtDecoder.decode(User.instance.token);
      User.instance.userId = decodedToken['data']['public']['user'] ?? '';
      User.instance.userRole = decodedToken['data']['public']['role'] ?? '';
      print('app launch - token ${User.instance.token}');
    }
    if (prefs.containsKey('shiftStartTime')) User.instance.startTime = prefs.getInt('shiftStartTime');

    if (prefs.containsKey('shiftEndTime')) User.instance.endTime = prefs.getInt('shiftEndTime');
    if (prefs.containsKey('shiftDuration')) {
      User.instance.duration = prefs.getInt('shiftDuration');
      print('prefs ->shiftDuration ${User.instance.duration}');
    }
    if (prefs.containsKey('shiftEndTm')) {
      User.instance.shiftEndTime = prefs.getInt('shiftEndTm');
      print('prefs ->shiftEndTime ${User.instance.shiftEndTime}');
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeSharedPrefs();
    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
      resumeCallBack: () async => print('App resumed'),
      // () async => setState(() {
      //       // check if token is present
      //       if (User.instance.token == null) {
      //         Navigator.of(context).pushNamed('login');
      //       }
      //       print("resume callback");
      //     }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => signInFormBloc,
        ),
        BlocProvider(
          create: (context) => homeBloc,
        ),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScopeNode focusScopeNode = FocusScope.of(context);
          if (!focusScopeNode.hasPrimaryFocus && focusScopeNode.focusedChild != null) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: FutureBuilder(
          future: _initializeSharedPrefs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Roster App',
                theme: ThemeData(
                  fontFamily: 'Product Sans',
                  accentColor: AppColor.lightBlue,
                  scaffoldBackgroundColor: Colors.transparent,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  textTheme: Theme.of(context).textTheme.apply(
                        fontFamily: 'Product Sans',
                        bodyColor: AppColor.paleSky,
                        displayColor: AppColor.paleSky,
                      ),
                  appBarTheme: const AppBarTheme(elevation: 0),
                ),
                initialRoute: User.instance.token != null && User.instance.token != ''
                    ? User.instance.userRole == 'User'
                        ? 'user-dashboard'
                        : 'manager-dashboard'
                    : 'login',
                routes: {
                  'login': (context) => LoginScreen(),
                  'setup-passcode-screen': (context) => SetupPasscodeScreen(),
                  'user-dashboard': (context) => UserDashboardScreen(),
                  'apply-leave-screen': (context) => ApplyLeaveScreen(),
                  'qr-scan-screen': (context) => QrScanScreen(),
                  'manager-dashboard': (context) => ManagerDashboardScreen(),
                  'manager-notifications': (context) => NotificationListScreen(),
                },
              );
            } else
              return CircularProgressIndicator();
            //Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
