import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:roster_app/data/data_sources/remote_data_src.dart';
import 'package:roster_app/domain/auth/auth_failure.dart';
import 'package:roster_app/domain/model/locations.dart';
import 'package:roster_app/domain/model/users_report.dart';

part 'manager_report_event.dart';
part 'manager_report_state.dart';

class ManagerReportBloc extends Bloc<ManagerReportEvent, ManagerReportState> {
  ManagerReportBloc(this._remoteDataSrc) : super(ManagerReportInitial());

  final RemoteDataSrc _remoteDataSrc;

  @override
  Stream<ManagerReportState> mapEventToState(
    ManagerReportEvent event,
  ) async* {
    if (event is ManagerReportLocationEvent) {
      print('enter ManagerReportLocationEvent');
      yield ManagerReportLoadingState();

      Either<AuthFailure, LocationsList> failureOrSuccess = await _remoteDataSrc.fetchUserSite();

      yield failureOrSuccess.fold(
        (failure) => ManagerReportErrorState(failure: failure),
        (result) {
          print(result.toString());

          return ManagerReportLocationLoadedState(locationsList: result);
        },
      );
    }
    if (event is ManagerReportLoadEvent) {
      yield ManagerReportLoadingState();

      Either<AuthFailure, LocationsList> failureOrSuccessResult = await _remoteDataSrc.fetchUserSite();
      var message;
      failureOrSuccessResult.fold((l) => message = l.message, (r) => null);

      if (failureOrSuccessResult.isRight()) {
        Either<AuthFailure, UsersReport> failureOrSuccess = await _remoteDataSrc.fetchUserReport(
          startDate: event.startDate,
          endDate: event.endDate,
        );
        yield failureOrSuccess.fold(
          (failure) => ManagerReportErrorState(failure: AuthFailure(message)),
          (result) => ManagerReportLoadedState(usersReport: result),
        );
      } else
        yield ManagerReportErrorState(failure: AuthFailure(message));
    }
  }
}
