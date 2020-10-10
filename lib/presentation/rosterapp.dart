import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roster_app/common/screenutils/screen_utils.dart';
import 'package:roster_app/common/themes/theme_color.dart';
import 'package:roster_app/di/get_it.dart';
import 'package:roster_app/domain/shift_signing_bloc/shift_signing_bloc.dart';
import 'package:roster_app/domain/sign_in_form_bloc/sign_in_form_bloc.dart';
import 'package:roster_app/domain/task_bloc/task_bloc.dart';
//import 'package:roster_app/domain/user_report_bloc/user_report_bloc.dart';
import 'package:roster_app/presentation/User/apply_leave_screen.dart';
import 'package:roster_app/presentation/User/qr_scan_screen.dart';
import 'package:roster_app/presentation/User/user_dashboard_screen.dart';
import 'package:roster_app/presentation/login/login_screen.dart';
import 'package:roster_app/presentation/login/setup_passcode_screen.dart';
import 'package:roster_app/presentation/manager/manager_dashboard_screen.dart';

class RosterApp extends StatelessWidget {
  final SignInFormBloc signInFormBloc = getIt<SignInFormBloc>();
  final ShiftSigningBloc shiftSigningBloc = getIt<ShiftSigningBloc>();
  final TaskBloc taskBloc = getIt<TaskBloc>();
  //final UserReportBloc userReportBloc = getIt<UserReportBloc>();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => signInFormBloc,
        ),
        BlocProvider(
          create: (context) => shiftSigningBloc,
        ),
        BlocProvider(
          create: (context) => taskBloc,
        ),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScopeNode focusScopeNode = FocusScope.of(context);
          if (!focusScopeNode.hasPrimaryFocus && focusScopeNode.focusedChild != null) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: MaterialApp(
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
          initialRoute: '/',
          routes: {
            '/': (context) => LoginScreen(),
            '/setup-passcode-screen': (context) => SetupPasscodeScreen(),
            '/user-dashboard': (context) => UserDashboardScreen(),
            '/apply-leave-screen': (context) => ApplyLeaveScreen(),
            '/qr-scan-screen': (context) => QrScanScreen(),
            '/manager-dashboard': (context) => ManagerDashboardScreen(),
          },
        ),
      ),
    );
  }
}
