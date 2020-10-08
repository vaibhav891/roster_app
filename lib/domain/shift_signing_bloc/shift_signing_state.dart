part of 'shift_signing_bloc.dart';

@immutable
class ShiftSigningState extends Equatable {
  final bool isLoading;
  final bool isSignedIn;
  final AuthFailure failure;

  const ShiftSigningState({@required this.isLoading, @required this.isSignedIn, @required this.failure});

  @override
  List<Object> get props => [isLoading, isSignedIn, failure];

  factory ShiftSigningState.initial() => ShiftSigningState(
        isLoading: false,
        isSignedIn: false,
        failure: null,
      );

  ShiftSigningState copyWith({
    bool isLoading,
    bool isSignedIn,
    AuthFailure failure,
  }) {
    return ShiftSigningState(
      isLoading: isLoading ?? this.isLoading,
      isSignedIn: isSignedIn ?? this.isSignedIn,
      failure: failure ?? this.failure,
    );
  }
}
