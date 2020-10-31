part of 'apply_leave_bloc.dart';

class ApplyLeaveEvent extends Equatable {
  const ApplyLeaveEvent(this.startDate, this.endDate, this.leaveType, this.reason);

  final String startDate;
  final String endDate;
  final String leaveType;
  final String reason;

  @override
  List<Object> get props => [startDate, endDate, leaveType, reason];
}
