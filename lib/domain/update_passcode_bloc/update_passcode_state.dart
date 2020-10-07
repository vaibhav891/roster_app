part of 'update_passcode_bloc.dart';

@immutable
abstract class UpdatePasscodeState {}

class UpdatePasscodeInitial extends UpdatePasscodeState {}

class UpdatePasscodeDoneState extends UpdatePasscodeState {
  final bool isSubmitting;
  final Option<Either<AuthFailure, Unit>> updateFailureOrSuccessOption;

  UpdatePasscodeDoneState(this.isSubmitting, this.updateFailureOrSuccessOption);
}
