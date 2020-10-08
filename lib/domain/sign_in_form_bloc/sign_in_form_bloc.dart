import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:roster_app/domain/auth/auth_failure.dart';
import 'package:roster_app/data/data_sources/remote_data_src.dart';

part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';

part 'sign_in_form_bloc.freezed.dart';

@injectable
class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final RemoteDataSrc _authFacade;

  SignInFormBloc(this._authFacade) : super(SignInFormState.initial());

  // @override
  // SignInFormState get initialState => SignInFormState.initial();

  @override
  Stream<SignInFormState> mapEventToState(
    SignInFormEvent event,
  ) async* {
    // implement mapEventToState
    yield* event.map(
      registerUser: (RegisterUser value) async* {
        print('start registerUser bloc');
        Either<AuthFailure, String> successOrFailure;
        yield state.copyWith(
          isSubmitting: true,
          authFailureOrSuccessOption: none(),
        );

        successOrFailure = await _authFacade.registerUser(
          userId: value.username,
        );
        print('end registerUser bloc');
        yield state.copyWith(
          isSubmitting: false,
          isRegister: true,
          authFailureOrSuccessOption: successOrFailure == null ? none() : some(successOrFailure),
        );
      },
      signInUser: (SignInUser value) async* {
        print('start signInUser bloc');
        Either<AuthFailure, String> successOrFailure;
        yield state.copyWith(
          isSubmitting: true,
          authFailureOrSuccessOption: none(),
        );

        successOrFailure = await _authFacade.signInUser(userId: value.username, passcode: value.passcode);
        print('end signInUser bloc');
        yield state.copyWith(
          isSubmitting: false,
          authFailureOrSuccessOption: successOrFailure == null ? none() : some(successOrFailure),
        );
      },
    );
  }
}
