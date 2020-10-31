part of 'sign_in_form_bloc.dart';

@freezed
abstract class SignInFormEvent with _$SignInFormEvent {
  const factory SignInFormEvent.registerUser(String username) = RegisterUser;
  const factory SignInFormEvent.signInUser(String username, String passcode) = SignInUser;
  const factory SignInFormEvent.signOutUser() = SignOutUser;
}
