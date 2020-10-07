part of 'sign_in_form_bloc.dart';

@freezed
abstract class SignInFormState with _$SignInFormState {
  const factory SignInFormState({
    @required bool isSubmitting,
    @required Option<Either<AuthFailure, String>> authFailureOrSuccessOption,
    @required bool isRegister,
  }) = _SignInFormState;

  factory SignInFormState.initial() => SignInFormState(
        authFailureOrSuccessOption: none(),
        isSubmitting: false,
        isRegister: false,
      );
}
