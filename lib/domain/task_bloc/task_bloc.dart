import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:roster_app/data/data_sources/remote_data_src.dart';
import 'package:roster_app/domain/auth/auth_failure.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc(this._remoteDataSrc) : super(TaskState.initial());

  final RemoteDataSrc _remoteDataSrc;

  @override
  Stream<TaskState> mapEventToState(
    TaskEvent event,
  ) async* {
    yield state.copyWith(
      isLoading: true,
    );

    var successOrFailure;
    if (!state.isCheckedIn) {
      successOrFailure = await _remoteDataSrc.startTask(id: event.id);
    } else {
      successOrFailure = await _remoteDataSrc.finishTask(id: event.id);
    }
    yield successOrFailure.fold(
      (l) => state.copyWith(
        isLoading: false,
        failure: l,
      ),
      (r) => state.copyWith(
        isLoading: false,
        isCheckedIn: !state.isCheckedIn,
      ),
    );
  }
}
