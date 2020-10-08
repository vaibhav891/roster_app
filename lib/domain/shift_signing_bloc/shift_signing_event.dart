part of 'shift_signing_bloc.dart';

@immutable
class ShiftSigningEvent {
  final String lat;
  final String long;

  ShiftSigningEvent(this.lat, this.long);
}
