import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:roster_app/data/data_sources/remote_data_src.dart';
import 'package:roster_app/domain/auth/auth_failure.dart';
import 'package:roster_app/domain/auth/user.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._remoteDataSrc) : super(HomeState.initial());

  final RemoteDataSrc _remoteDataSrc;

  @override
  Stream<HomeState> mapEventToState(HomeEvent event,) async* {
    if (event is HomeInitialEvent) {
      yield state.copyWith(
        isSignInLoading: true,
        failure: AuthFailure(""),
      );
      Either<AuthFailure, Unit> successOrFailure;
      successOrFailure = await _remoteDataSrc.syncInfo();

      yield successOrFailure.fold(
        (l) => state.copyWith(
          isSignInLoading: false,
          failure: l,
        ),
        (r) {
          return state.copyWith(
            isSignInLoading: false,
            isSignedIn: User.instance.isSignedIn,
            isCheckedIn: User.instance.taskId != null ? true : false,
            failure: AuthFailure(""),
          );
        },
      );
    }
    if (event is SignInSignOutEvent) {
      yield state.copyWith(
        isSignInLoading: true,
        failure: AuthFailure(""),
      );

      Either<AuthFailure, Unit> successOrFailure;
      if (!state.isSignedIn) {
        successOrFailure = await _remoteDataSrc.shiftSignIn(lat: event.lat, long: event.long);
      } else {
        successOrFailure = await _remoteDataSrc.shiftSignOut(lat: event.lat, long: event.long);
      }
      yield successOrFailure.fold(
        (l) => state.copyWith(
          isSignInLoading: false,
          failure: l,
        ),
        (r) => state.copyWith(
          isSignInLoading: false,
          isSignedIn: !state.isSignedIn,
          failure: AuthFailure(""),
        ),
      );
    }
    if (event is CheckInCheckOutEvent) {
      yield state.copyWith(
        isCheckInLoading: true,
        failure: AuthFailure(""),
      );

      var successOrFailure;
      if (!state.isCheckedIn) {
        successOrFailure = await _remoteDataSrc.startTask(id: event.id);
      } else {
        successOrFailure = await _remoteDataSrc.finishTask(id: event.id);
      }
      yield successOrFailure.fold(
        (l) => state.copyWith(
          isCheckInLoading: false,
          failure: l,
        ),
        (r) => state.copyWith(
          isCheckInLoading: false,
          isCheckedIn: !state.isCheckedIn,
          failure: AuthFailure(""),
        ),
      );
    }
  }
}
