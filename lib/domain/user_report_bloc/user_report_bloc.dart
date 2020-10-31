import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:roster_app/data/data_sources/remote_data_src.dart';
import 'package:roster_app/domain/auth/auth_failure.dart';
import 'package:roster_app/domain/model/users_report.dart';

part 'user_report_event.dart';
part 'user_report_state.dart';

class UserReportBloc extends Bloc<UserReportEvent, UserReportState> {
  UserReportBloc(this._remoteDataSrc) : super(UserReportInitial());

  final RemoteDataSrc _remoteDataSrc;

  @override
  Stream<UserReportState> mapEventToState(
    UserReportEvent event,
  ) async* {
    yield UserReportLoading();

    var failureOrSuccess = await _remoteDataSrc.fetchUserReport(startDate: event.startDate, endDate: event.endDate);

    yield failureOrSuccess.fold(
      (failure) => UserReportError(failure),
      (report) => UserReportLoaded(report),
    );
  }
}
