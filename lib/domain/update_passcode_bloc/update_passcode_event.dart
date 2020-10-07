part of 'update_passcode_bloc.dart';

@immutable
abstract class UpdatePasscodeEvent {}

class UpdatePasscodePressedEvent extends UpdatePasscodeEvent {
  final String userId;
  final String passcode;
  final String newPasscode;

  UpdatePasscodePressedEvent(this.userId, this.passcode, this.newPasscode);
}
