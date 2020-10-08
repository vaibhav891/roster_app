import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:roster_app/data/data_sources/remote_data_src.dart';
import 'package:roster_app/domain/auth/auth_failure.dart';

part 'shift_signing_event.dart';
part 'shift_signing_state.dart';

class ShiftSigningBloc extends Bloc<ShiftSigningEvent, ShiftSigningState> {
  ShiftSigningBloc(this._remoteDataSrc) : super(ShiftSigningState.initial());

  final RemoteDataSrc _remoteDataSrc;

  @override
  Stream<ShiftSigningState> mapEventToState(
    ShiftSigningEvent event,
  ) async* {
    print('inside mapeventtostate ${state.isLoading} ');
    yield state.copyWith(
      isLoading: true,
    );

    var successOrFailure;
    if (!state.isSignedIn) {
      successOrFailure = await _remoteDataSrc.shiftSignIn(lat: event.lat, long: event.long);
    } else {
      successOrFailure = await _remoteDataSrc.shiftSignOut(lat: event.lat, long: event.long);
    }
    yield successOrFailure.fold(
      (l) => state.copyWith(
        isLoading: false,
        failure: l,
      ),
      (r) => state.copyWith(
        isLoading: false,
        isSignedIn: !state.isSignedIn,
      ),
    );
  }
}
