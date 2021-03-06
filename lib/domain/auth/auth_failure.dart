import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

//part 'auth_failure.freezed.dart';

// @freezed
// abstract class AuthFailure with _$AuthFailure {
//   const factory AuthFailure.cancelledByUser() = CancelledByUser;
//   const factory AuthFailure.serverError() = ServerError;
//   //const factory AuthFailure.emailAlreadyInUse() = EmailAlreadyInUse;
//   const factory AuthFailure.invalidUsernamePasscodeCombination() = InvalidUsernamePasscodeCombination;
//   const factory AuthFailure.noInternetConnectivity() = NoInternetConnectivity;
// }
class AuthFailure extends Equatable {
  final String message;

  AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}
