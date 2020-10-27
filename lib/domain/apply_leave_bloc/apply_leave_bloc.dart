import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:roster_app/data/data_sources/remote_data_src.dart';
import 'package:roster_app/domain/auth/auth_failure.dart';

part 'apply_leave_event.dart';
part 'apply_leave_state.dart';

class ApplyLeaveBloc extends Bloc<ApplyLeaveEvent, ApplyLeaveState> {
  ApplyLeaveBloc(this._remoteDataSrc) : super(ApplyLeaveState.initial());

  final RemoteDataSrc _remoteDataSrc;

  @override
  Stream<ApplyLeaveState> mapEventToState(
    ApplyLeaveEvent event,
  ) async* {
    yield state.copyWith(
      isLoading: true,
      successOrFailure: null, //right(unit),
    );

    Either<AuthFailure, Unit> successOrFailure;
    successOrFailure = await _remoteDataSrc.applyLeave(
      startDate: event.startDate,
      endDate: event.endDate,
      leaveType: event.leaveType,
      reason: event.reason,
    );
    yield state.copyWith(
      isLoading: false,
      successOrFailure: successOrFailure,
    );
  }
}
