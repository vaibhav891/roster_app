import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pedantic/pedantic.dart';
import 'package:roster_app/di/get_it.dart' as getIt;
import 'package:roster_app/presentation/rosterapp.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]));
  unawaited(getIt.setup());
  runApp(RosterApp());
}
