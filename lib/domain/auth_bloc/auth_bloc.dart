import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:roster_app/domain/auth/i_auth_facade.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthFacade _authFacade;

  AuthBloc(
    this._authFacade,
  ) : super(const AuthState.initial());

  @override
  AuthState get initialState => const AuthState.initial();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    yield* event.map(
      authCheckRequested: (e) async* {
        final user = await _authFacade.signedInUser();
        yield user.fold(
          () => const AuthState.unauthenticated(),
          (_) => const AuthState.authenticated(),
        );

        // yield _authFacade.signedInUser().then((value) => value.fold(
        //       () => const AuthState.unauthenticated(),
        //       (_) => const AuthState.authenticated(),
        //     ));
      },
      signedOut: (e) async* {
        await _authFacade.signOut();
        yield const AuthState.unauthenticated();
      },
    );
  }
}
