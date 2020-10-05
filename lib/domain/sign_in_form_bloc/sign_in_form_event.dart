part of 'sign_in_form_bloc.dart';

@freezed
abstract class SignInFormEvent with _$SignInFormEvent {
  const factory SignInFormEvent.registerWithEmailnPasswordPressed() = RegisterWithEmailnPasswordPressed;
  const factory SignInFormEvent.signInWithEmailnPasswordPressed() = SignInWithEmailnPasswordPressed;
  const factory SignInFormEvent.emailChanged(String emailStr) = EmailChanged;
  const factory SignInFormEvent.passwordChanged(String passwordStr) = PasswordChanged;
}
