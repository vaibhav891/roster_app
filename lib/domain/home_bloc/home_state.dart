part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    @required this.isCheckInLoading,
    @required this.isSignInLoading,
    @required this.isSignedIn,
    @required this.isCheckedIn,
    @required this.failure,
  });

  final bool isSignInLoading;
  final bool isCheckInLoading;

  final bool isSignedIn;
  final bool isCheckedIn;
  final AuthFailure failure;

  @override
  List<Object> get props => [isCheckInLoading, isSignInLoading, isSignedIn, isCheckedIn, failure];

  factory HomeState.initial() => HomeState(
        isSignInLoading: false,
        isCheckInLoading: false,
        isSignedIn: false,
        isCheckedIn: false,
        failure: null,
      );

  HomeState copyWith({
    bool isSignInLoading,
    bool isCheckInLoading,
    bool isSignedIn,
    bool isCheckedIn,
    AuthFailure failure,
  }) {
    return HomeState(
      isSignInLoading: isSignInLoading ?? this.isSignInLoading,
      isCheckInLoading: isCheckInLoading ?? this.isCheckInLoading,
      isSignedIn: isSignedIn ?? this.isSignedIn,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
      failure: failure ?? this.failure,
    );
  }
}
