import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:roster_app/domain/auth/auth_failure.dart';
import 'package:roster_app/data/data_sources/remote_data_src.dart';

part 'update_passcode_event.dart';
part 'update_passcode_state.dart';

class UpdatePasscodeBloc extends Bloc<UpdatePasscodeEvent, UpdatePasscodeState> {
  final RemoteDataSrc _remoteDataSrc;
  UpdatePasscodeBloc(this._remoteDataSrc) : super(UpdatePasscodeInitial());

  @override
  Stream<UpdatePasscodeState> mapEventToState(
    UpdatePasscodeEvent event,
  ) async* {
    yield UpdatePasscodeDoneState(true, none());

    var successOrFailure = await _remoteDataSrc.updatePasscode(
        userId: (event as UpdatePasscodePressedEvent).userId,
        passcode: (event as UpdatePasscodePressedEvent).passcode,
        newPasscode: (event as UpdatePasscodePressedEvent).newPasscode);

    yield UpdatePasscodeDoneState(false, successOrFailure == null ? none() : some(successOrFailure));
  }
}
