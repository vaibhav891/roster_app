import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:roster_app/data/core/api_client.dart';
import 'package:roster_app/data/data_sources/remote_data_source.dart';
import 'package:roster_app/domain/auth/i_auth_facade.dart';
import 'package:roster_app/domain/sign_in_form_bloc/sign_in_form_bloc.dart';

GetIt getIt = GetIt.I;

Future<void> setup() async {
  getIt.registerLazySingleton<Client>(() => Client());

  getIt.registerLazySingleton<ApiClient>(() => ApiClient(getIt<Client>()));
  getIt.registerLazySingleton<IAuthFacade>(() => RemoteDataSource(getIt<ApiClient>()));
  getIt.registerFactory<SignInFormBloc>(() => SignInFormBloc(getIt<IAuthFacade>()));
  //getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<IAuthFacade>()));
}
