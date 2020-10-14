part of 'manager_report_bloc.dart';

abstract class ManagerReportEvent extends Equatable {
  const ManagerReportEvent();

  @override
  List<Object> get props => [];
}

class ManagerReportLocationEvent extends ManagerReportEvent {}

class ManagerReportLoadEvent extends ManagerReportEvent {
  final String startDate;
  final String endDate;

  ManagerReportLoadEvent({
    @required this.startDate,
    @required this.endDate,
  });

  @override
  List<Object> get props => [
        startDate,
        endDate,
      ];
}
