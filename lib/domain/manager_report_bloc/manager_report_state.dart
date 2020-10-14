part of 'manager_report_bloc.dart';

abstract class ManagerReportState extends Equatable {
  const ManagerReportState();

  @override
  List<Object> get props => [];
}

class ManagerReportInitial extends ManagerReportState {}

class ManagerReportLoadingState extends ManagerReportState {}

class ManagerReportErrorState extends ManagerReportState {
  final AuthFailure failure;

  ManagerReportErrorState({@required this.failure});

  @override
  List<Object> get props => [failure];
}

class ManagerReportLoadedState extends ManagerReportState {
  final UsersReport usersReport;

  ManagerReportLoadedState({@required this.usersReport});

  @override
  List<Object> get props => [usersReport];
}

class ManagerReportLocationLoadedState extends ManagerReportState {
  final LocationsList locationsList;

  ManagerReportLocationLoadedState({@required this.locationsList});

  @override
  List<Object> get props => [locationsList];
}
