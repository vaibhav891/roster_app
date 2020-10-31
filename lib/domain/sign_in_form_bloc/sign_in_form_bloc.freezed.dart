// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'sign_in_form_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$SignInFormEventTearOff {
  const _$SignInFormEventTearOff();

// ignore: unused_element
  RegisterUser registerUser(String username) {
    return RegisterUser(
      username,
    );
  }

// ignore: unused_element
  SignInUser signInUser(String username, String passcode) {
    return SignInUser(
      username,
      passcode,
    );
  }

// ignore: unused_element
  SignOutUser signOutUser() {
    return const SignOutUser();
  }
}

/// @nodoc
// ignore: unused_element
const $SignInFormEvent = _$SignInFormEventTearOff();

/// @nodoc
mixin _$SignInFormEvent {
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result registerUser(String username),
    @required Result signInUser(String username, String passcode),
    @required Result signOutUser(),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result registerUser(String username),
    Result signInUser(String username, String passcode),
    Result signOutUser(),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result registerUser(RegisterUser value),
    @required Result signInUser(SignInUser value),
    @required Result signOutUser(SignOutUser value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result registerUser(RegisterUser value),
    Result signInUser(SignInUser value),
    Result signOutUser(SignOutUser value),
    @required Result orElse(),
  });
}

/// @nodoc
abstract class $SignInFormEventCopyWith<$Res> {
  factory $SignInFormEventCopyWith(
          SignInFormEvent value, $Res Function(SignInFormEvent) then) =
      _$SignInFormEventCopyWithImpl<$Res>;
}

/// @nodoc
class _$SignInFormEventCopyWithImpl<$Res>
    implements $SignInFormEventCopyWith<$Res> {
  _$SignInFormEventCopyWithImpl(this._value, this._then);

  final SignInFormEvent _value;
  // ignore: unused_field
  final $Res Function(SignInFormEvent) _then;
}

/// @nodoc
abstract class $RegisterUserCopyWith<$Res> {
  factory $RegisterUserCopyWith(
          RegisterUser value, $Res Function(RegisterUser) then) =
      _$RegisterUserCopyWithImpl<$Res>;
  $Res call({String username});
}

/// @nodoc
class _$RegisterUserCopyWithImpl<$Res>
    extends _$SignInFormEventCopyWithImpl<$Res>
    implements $RegisterUserCopyWith<$Res> {
  _$RegisterUserCopyWithImpl(
      RegisterUser _value, $Res Function(RegisterUser) _then)
      : super(_value, (v) => _then(v as RegisterUser));

  @override
  RegisterUser get _value => super._value as RegisterUser;

  @override
  $Res call({
    Object username = freezed,
  }) {
    return _then(RegisterUser(
      username == freezed ? _value.username : username as String,
    ));
  }
}

/// @nodoc
class _$RegisterUser with DiagnosticableTreeMixin implements RegisterUser {
  const _$RegisterUser(this.username) : assert(username != null);

  @override
  final String username;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SignInFormEvent.registerUser(username: $username)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SignInFormEvent.registerUser'))
      ..add(DiagnosticsProperty('username', username));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is RegisterUser &&
            (identical(other.username, username) ||
                const DeepCollectionEquality()
                    .equals(other.username, username)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(username);

  @override
  $RegisterUserCopyWith<RegisterUser> get copyWith =>
      _$RegisterUserCopyWithImpl<RegisterUser>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result registerUser(String username),
    @required Result signInUser(String username, String passcode),
    @required Result signOutUser(),
  }) {
    assert(registerUser != null);
    assert(signInUser != null);
    assert(signOutUser != null);
    return registerUser(username);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result registerUser(String username),
    Result signInUser(String username, String passcode),
    Result signOutUser(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (registerUser != null) {
      return registerUser(username);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result registerUser(RegisterUser value),
    @required Result signInUser(SignInUser value),
    @required Result signOutUser(SignOutUser value),
  }) {
    assert(registerUser != null);
    assert(signInUser != null);
    assert(signOutUser != null);
    return registerUser(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result registerUser(RegisterUser value),
    Result signInUser(SignInUser value),
    Result signOutUser(SignOutUser value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (registerUser != null) {
      return registerUser(this);
    }
    return orElse();
  }
}

abstract class RegisterUser implements SignInFormEvent {
  const factory RegisterUser(String username) = _$RegisterUser;

  String get username;
  $RegisterUserCopyWith<RegisterUser> get copyWith;
}

/// @nodoc
abstract class $SignInUserCopyWith<$Res> {
  factory $SignInUserCopyWith(
          SignInUser value, $Res Function(SignInUser) then) =
      _$SignInUserCopyWithImpl<$Res>;
  $Res call({String username, String passcode});
}

/// @nodoc
class _$SignInUserCopyWithImpl<$Res> extends _$SignInFormEventCopyWithImpl<$Res>
    implements $SignInUserCopyWith<$Res> {
  _$SignInUserCopyWithImpl(SignInUser _value, $Res Function(SignInUser) _then)
      : super(_value, (v) => _then(v as SignInUser));

  @override
  SignInUser get _value => super._value as SignInUser;

  @override
  $Res call({
    Object username = freezed,
    Object passcode = freezed,
  }) {
    return _then(SignInUser(
      username == freezed ? _value.username : username as String,
      passcode == freezed ? _value.passcode : passcode as String,
    ));
  }
}

/// @nodoc
class _$SignInUser with DiagnosticableTreeMixin implements SignInUser {
  const _$SignInUser(this.username, this.passcode)
      : assert(username != null),
        assert(passcode != null);

  @override
  final String username;
  @override
  final String passcode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SignInFormEvent.signInUser(username: $username, passcode: $passcode)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SignInFormEvent.signInUser'))
      ..add(DiagnosticsProperty('username', username))
      ..add(DiagnosticsProperty('passcode', passcode));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is SignInUser &&
            (identical(other.username, username) ||
                const DeepCollectionEquality()
                    .equals(other.username, username)) &&
            (identical(other.passcode, passcode) ||
                const DeepCollectionEquality()
                    .equals(other.passcode, passcode)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(passcode);

  @override
  $SignInUserCopyWith<SignInUser> get copyWith =>
      _$SignInUserCopyWithImpl<SignInUser>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result registerUser(String username),
    @required Result signInUser(String username, String passcode),
    @required Result signOutUser(),
  }) {
    assert(registerUser != null);
    assert(signInUser != null);
    assert(signOutUser != null);
    return signInUser(username, passcode);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result registerUser(String username),
    Result signInUser(String username, String passcode),
    Result signOutUser(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (signInUser != null) {
      return signInUser(username, passcode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result registerUser(RegisterUser value),
    @required Result signInUser(SignInUser value),
    @required Result signOutUser(SignOutUser value),
  }) {
    assert(registerUser != null);
    assert(signInUser != null);
    assert(signOutUser != null);
    return signInUser(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result registerUser(RegisterUser value),
    Result signInUser(SignInUser value),
    Result signOutUser(SignOutUser value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (signInUser != null) {
      return signInUser(this);
    }
    return orElse();
  }
}

abstract class SignInUser implements SignInFormEvent {
  const factory SignInUser(String username, String passcode) = _$SignInUser;

  String get username;
  String get passcode;
  $SignInUserCopyWith<SignInUser> get copyWith;
}

/// @nodoc
abstract class $SignOutUserCopyWith<$Res> {
  factory $SignOutUserCopyWith(
          SignOutUser value, $Res Function(SignOutUser) then) =
      _$SignOutUserCopyWithImpl<$Res>;
}

/// @nodoc
class _$SignOutUserCopyWithImpl<$Res>
    extends _$SignInFormEventCopyWithImpl<$Res>
    implements $SignOutUserCopyWith<$Res> {
  _$SignOutUserCopyWithImpl(
      SignOutUser _value, $Res Function(SignOutUser) _then)
      : super(_value, (v) => _then(v as SignOutUser));

  @override
  SignOutUser get _value => super._value as SignOutUser;
}

/// @nodoc
class _$SignOutUser with DiagnosticableTreeMixin implements SignOutUser {
  const _$SignOutUser();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SignInFormEvent.signOutUser()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'SignInFormEvent.signOutUser'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is SignOutUser);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result registerUser(String username),
    @required Result signInUser(String username, String passcode),
    @required Result signOutUser(),
  }) {
    assert(registerUser != null);
    assert(signInUser != null);
    assert(signOutUser != null);
    return signOutUser();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result registerUser(String username),
    Result signInUser(String username, String passcode),
    Result signOutUser(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (signOutUser != null) {
      return signOutUser();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result registerUser(RegisterUser value),
    @required Result signInUser(SignInUser value),
    @required Result signOutUser(SignOutUser value),
  }) {
    assert(registerUser != null);
    assert(signInUser != null);
    assert(signOutUser != null);
    return signOutUser(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result registerUser(RegisterUser value),
    Result signInUser(SignInUser value),
    Result signOutUser(SignOutUser value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (signOutUser != null) {
      return signOutUser(this);
    }
    return orElse();
  }
}

abstract class SignOutUser implements SignInFormEvent {
  const factory SignOutUser() = _$SignOutUser;
}

/// @nodoc
class _$SignInFormStateTearOff {
  const _$SignInFormStateTearOff();

// ignore: unused_element
  _SignInFormState call(
      {@required bool isSubmitting,
      @required Option<Either<AuthFailure, String>> authFailureOrSuccessOption,
      @required bool isRegister}) {
    return _SignInFormState(
      isSubmitting: isSubmitting,
      authFailureOrSuccessOption: authFailureOrSuccessOption,
      isRegister: isRegister,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $SignInFormState = _$SignInFormStateTearOff();

/// @nodoc
mixin _$SignInFormState {
  bool get isSubmitting;
  Option<Either<AuthFailure, String>> get authFailureOrSuccessOption;
  bool get isRegister;

  $SignInFormStateCopyWith<SignInFormState> get copyWith;
}

/// @nodoc
abstract class $SignInFormStateCopyWith<$Res> {
  factory $SignInFormStateCopyWith(
          SignInFormState value, $Res Function(SignInFormState) then) =
      _$SignInFormStateCopyWithImpl<$Res>;
  $Res call(
      {bool isSubmitting,
      Option<Either<AuthFailure, String>> authFailureOrSuccessOption,
      bool isRegister});
}

/// @nodoc
class _$SignInFormStateCopyWithImpl<$Res>
    implements $SignInFormStateCopyWith<$Res> {
  _$SignInFormStateCopyWithImpl(this._value, this._then);

  final SignInFormState _value;
  // ignore: unused_field
  final $Res Function(SignInFormState) _then;

  @override
  $Res call({
    Object isSubmitting = freezed,
    Object authFailureOrSuccessOption = freezed,
    Object isRegister = freezed,
  }) {
    return _then(_value.copyWith(
      isSubmitting:
          isSubmitting == freezed ? _value.isSubmitting : isSubmitting as bool,
      authFailureOrSuccessOption: authFailureOrSuccessOption == freezed
          ? _value.authFailureOrSuccessOption
          : authFailureOrSuccessOption as Option<Either<AuthFailure, String>>,
      isRegister:
          isRegister == freezed ? _value.isRegister : isRegister as bool,
    ));
  }
}

/// @nodoc
abstract class _$SignInFormStateCopyWith<$Res>
    implements $SignInFormStateCopyWith<$Res> {
  factory _$SignInFormStateCopyWith(
          _SignInFormState value, $Res Function(_SignInFormState) then) =
      __$SignInFormStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {bool isSubmitting,
      Option<Either<AuthFailure, String>> authFailureOrSuccessOption,
      bool isRegister});
}

/// @nodoc
class __$SignInFormStateCopyWithImpl<$Res>
    extends _$SignInFormStateCopyWithImpl<$Res>
    implements _$SignInFormStateCopyWith<$Res> {
  __$SignInFormStateCopyWithImpl(
      _SignInFormState _value, $Res Function(_SignInFormState) _then)
      : super(_value, (v) => _then(v as _SignInFormState));

  @override
  _SignInFormState get _value => super._value as _SignInFormState;

  @override
  $Res call({
    Object isSubmitting = freezed,
    Object authFailureOrSuccessOption = freezed,
    Object isRegister = freezed,
  }) {
    return _then(_SignInFormState(
      isSubmitting:
          isSubmitting == freezed ? _value.isSubmitting : isSubmitting as bool,
      authFailureOrSuccessOption: authFailureOrSuccessOption == freezed
          ? _value.authFailureOrSuccessOption
          : authFailureOrSuccessOption as Option<Either<AuthFailure, String>>,
      isRegister:
          isRegister == freezed ? _value.isRegister : isRegister as bool,
    ));
  }
}

/// @nodoc
class _$_SignInFormState
    with DiagnosticableTreeMixin
    implements _SignInFormState {
  const _$_SignInFormState(
      {@required this.isSubmitting,
      @required this.authFailureOrSuccessOption,
      @required this.isRegister})
      : assert(isSubmitting != null),
        assert(authFailureOrSuccessOption != null),
        assert(isRegister != null);

  @override
  final bool isSubmitting;
  @override
  final Option<Either<AuthFailure, String>> authFailureOrSuccessOption;
  @override
  final bool isRegister;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SignInFormState(isSubmitting: $isSubmitting, authFailureOrSuccessOption: $authFailureOrSuccessOption, isRegister: $isRegister)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SignInFormState'))
      ..add(DiagnosticsProperty('isSubmitting', isSubmitting))
      ..add(DiagnosticsProperty(
          'authFailureOrSuccessOption', authFailureOrSuccessOption))
      ..add(DiagnosticsProperty('isRegister', isRegister));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _SignInFormState &&
            (identical(other.isSubmitting, isSubmitting) ||
                const DeepCollectionEquality()
                    .equals(other.isSubmitting, isSubmitting)) &&
            (identical(other.authFailureOrSuccessOption,
                    authFailureOrSuccessOption) ||
                const DeepCollectionEquality().equals(
                    other.authFailureOrSuccessOption,
                    authFailureOrSuccessOption)) &&
            (identical(other.isRegister, isRegister) ||
                const DeepCollectionEquality()
                    .equals(other.isRegister, isRegister)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(isSubmitting) ^
      const DeepCollectionEquality().hash(authFailureOrSuccessOption) ^
      const DeepCollectionEquality().hash(isRegister);

  @override
  _$SignInFormStateCopyWith<_SignInFormState> get copyWith =>
      __$SignInFormStateCopyWithImpl<_SignInFormState>(this, _$identity);
}

abstract class _SignInFormState implements SignInFormState {
  const factory _SignInFormState(
      {@required bool isSubmitting,
      @required Option<Either<AuthFailure, String>> authFailureOrSuccessOption,
      @required bool isRegister}) = _$_SignInFormState;

  @override
  bool get isSubmitting;
  @override
  Option<Either<AuthFailure, String>> get authFailureOrSuccessOption;
  @override
  bool get isRegister;
  @override
  _$SignInFormStateCopyWith<_SignInFormState> get copyWith;
}
