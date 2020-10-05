import 'package:flutter/material.dart';
import 'package:roster_app/common/screenutils/screen_utils.dart';
import 'package:roster_app/common/themes/theme_color.dart';
import 'package:roster_app/presentation/User/apply_leave_screen.dart';
import 'package:roster_app/presentation/User/qr_scan_screen.dart';
import 'package:roster_app/presentation/User/user_dashboard_screen.dart';
import 'package:roster_app/presentation/login/login_screen.dart';
import 'package:roster_app/presentation/login/setup_passcode_screen.dart';
import 'package:roster_app/presentation/manager/manager_dashboard_screen.dart';

class RosterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init();
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
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/setup-passcode-screen': (context) => SetupPasscodeScreen(),
        '/user-dashboard': (context) => UserDashboardScreen(),
        '/apply-leave-screen': (context) => ApplyLeaveScreen(),
        '/qr-scan-screen': (context) => QrScanScreen(),
        '/manager-dashboard': (context) => ManagerDashboardScreen(),
      },
    );
  }
}
