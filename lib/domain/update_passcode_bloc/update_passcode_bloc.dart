import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:roster_app/domain/auth/auth_failure.dart';
import 'package:roster_app/domain/auth/i_auth_facade.dart';

part 'update_passcode_event.dart';
part 'update_passcode_state.dart';

class UpdatePasscodeBloc extends Bloc<UpdatePasscodeEvent, UpdatePasscodeState> {
  final IAuthFacade _iAuthFacade;
  UpdatePasscodeBloc(this._iAuthFacade) : super(UpdatePasscodeInitial());

  @override
  Stream<UpdatePasscodeState> mapEventToState(
    UpdatePasscodeEvent event,
  ) async* {
    yield UpdatePasscodeDoneState(true, none());

    var successOrFailure = await _iAuthFacade.updatePasscode(
        userId: (event as UpdatePasscodePressedEvent).userId,
        passcode: (event as UpdatePasscodePressedEvent).passcode,
        newPasscode: (event as UpdatePasscodePressedEvent).newPasscode);

    yield UpdatePasscodeDoneState(false, successOrFailure == null ? none() : some(successOrFailure));
  }
}
