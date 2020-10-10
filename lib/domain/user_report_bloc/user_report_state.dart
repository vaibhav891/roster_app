part of 'user_report_bloc.dart';

class UserReportState extends Equatable {
  const UserReportState();

  @override
  List<Object> get props => [];
}

class UserReportInitial extends UserReportState {}

class UserReportError extends UserReportState {
  final AuthFailure failure;

  UserReportError(this.failure);

  @override
  List<Object> get props => [failure];
}

class UserReportLoaded extends UserReportState {
  final UsersReport usersReport;

  UserReportLoaded(this.usersReport);

  @override
  List<Object> get props => [usersReport];
}

class UserReportLoading extends UserReportState {}
