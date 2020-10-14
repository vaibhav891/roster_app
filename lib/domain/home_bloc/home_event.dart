part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class SignInSignOutEvent extends HomeEvent {
  final double lat;
  final double long;

  SignInSignOutEvent(this.lat, this.long);

  @override
  List<Object> get props => [lat, long];
}

class CheckInCheckOutEvent extends HomeEvent {
  final String id;

  CheckInCheckOutEvent({@required this.id});
  @override
  List<Object> get props => [id];
}
