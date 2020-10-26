part of 'apply_leave_bloc.dart';

class ApplyLeaveState extends Equatable {
  const ApplyLeaveState({this.isLoading, this.successOrFailure});
  final bool isLoading;
  final Either<AuthFailure, Unit> successOrFailure;
  @override
  List<Object> get props => [isLoading, successOrFailure];

  factory ApplyLeaveState.initial() => ApplyLeaveState(
        isLoading: false,
        successOrFailure: null, //right(unit),
      );

  ApplyLeaveState copyWith({
    bool isLoading,
    Either<AuthFailure, Unit> successOrFailure,
  }) {
    return ApplyLeaveState(
      isLoading: isLoading ?? this.isLoading,
      successOrFailure: successOrFailure ?? this.successOrFailure,
    );
  }
}

//class ApplyLeaveInitial extends ApplyLeaveState {}
