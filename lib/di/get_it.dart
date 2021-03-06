import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:roster_app/data/core/api_client.dart';
import 'package:roster_app/data/data_sources/remote_data_source_impl.dart';
import 'package:roster_app/data/data_sources/remote_data_src.dart';
import 'package:roster_app/domain/apply_leave_bloc/apply_leave_bloc.dart';
import 'package:roster_app/domain/home_bloc/home_bloc.dart';
import 'package:roster_app/domain/manager_report_bloc/manager_report_bloc.dart';
import 'package:roster_app/domain/sign_in_form_bloc/sign_in_form_bloc.dart';
import 'package:roster_app/domain/update_passcode_bloc/update_passcode_bloc.dart';
import 'package:roster_app/domain/user_report_bloc/user_report_bloc.dart';

GetIt getIt = GetIt.I;

Future<void> setup() async {
  getIt.registerLazySingleton<Client>(() => Client());

  getIt.registerLazySingleton<ApiClient>(() => ApiClient(getIt<Client>()));
  getIt.registerLazySingleton<RemoteDataSrc>(() => RemoteDataSrcImpl(getIt<ApiClient>()));
  getIt.registerFactory<SignInFormBloc>(() => SignInFormBloc(getIt<RemoteDataSrc>()));
  getIt.registerFactory<UpdatePasscodeBloc>(() => UpdatePasscodeBloc(getIt<RemoteDataSrc>()));
  //getIt.registerFactory<ShiftSigningBloc>(() => ShiftSigningBloc(getIt<RemoteDataSrc>()));
  //getIt.registerFactory<TaskBloc>(() => TaskBloc(getIt<RemoteDataSrc>()));
  getIt.registerFactory<ApplyLeaveBloc>(() => ApplyLeaveBloc(getIt<RemoteDataSrc>()));
  getIt.registerFactory<UserReportBloc>(() => UserReportBloc(getIt<RemoteDataSrc>()));
  getIt.registerFactory<ManagerReportBloc>(() => ManagerReportBloc(getIt<RemoteDataSrc>()));
  getIt.registerFactory<HomeBloc>(() => HomeBloc(getIt<RemoteDataSrc>()));
}
