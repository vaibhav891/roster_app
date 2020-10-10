part of 'user_report_bloc.dart';

class UserReportEvent extends Equatable {
  const UserReportEvent({@required this.endDate, @required this.startDate});
  final String startDate;
  final String endDate;

  @override
  List<Object> get props => [startDate, endDate];
}
