// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'auth_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$AuthFailureTearOff {
  const _$AuthFailureTearOff();

// ignore: unused_element
  CancelledByUser cancelledByUser() {
    return const CancelledByUser();
  }

// ignore: unused_element
  ServerError serverError() {
    return const ServerError();
  }

// ignore: unused_element
  InvalidUsernamePasscodeCombination invalidUsernamePasscodeCombination() {
    return const InvalidUsernamePasscodeCombination();
  }

// ignore: unused_element
  NoInternetConnectivity noInternetConnectivity() {
    return const NoInternetConnectivity();
  }
}

/// @nodoc
// ignore: unused_element
const $AuthFailure = _$AuthFailureTearOff();

/// @nodoc
mixin _$AuthFailure {
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result cancelledByUser(),
    @required Result serverError(),
    @required Result invalidUsernamePasscodeCombination(),
    @required Result noInternetConnectivity(),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result cancelledByUser(),
    Result serverError(),
    Result invalidUsernamePasscodeCombination(),
    Result noInternetConnectivity(),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result cancelledByUser(CancelledByUser value),
    @required Result serverError(ServerError value),
    @required
        Result invalidUsernamePasscodeCombination(
            InvalidUsernamePasscodeCombination value),
    @required Result noInternetConnectivity(NoInternetConnectivity value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result cancelledByUser(CancelledByUser value),
    Result serverError(ServerError value),
    Result invalidUsernamePasscodeCombination(
        InvalidUsernamePasscodeCombination value),
    Result noInternetConnectivity(NoInternetConnectivity value),
    @required Result orElse(),
  });
}

/// @nodoc
abstract class $AuthFailureCopyWith<$Res> {
  factory $AuthFailureCopyWith(
          AuthFailure value, $Res Function(AuthFailure) then) =
      _$AuthFailureCopyWithImpl<$Res>;
}

/// @nodoc
class _$AuthFailureCopyWithImpl<$Res> implements $AuthFailureCopyWith<$Res> {
  _$AuthFailureCopyWithImpl(this._value, this._then);

  final AuthFailure _value;
  // ignore: unused_field
  final $Res Function(AuthFailure) _then;
}

/// @nodoc
abstract class $CancelledByUserCopyWith<$Res> {
  factory $CancelledByUserCopyWith(
          CancelledByUser value, $Res Function(CancelledByUser) then) =
      _$CancelledByUserCopyWithImpl<$Res>;
}

/// @nodoc
class _$CancelledByUserCopyWithImpl<$Res>
    extends _$AuthFailureCopyWithImpl<$Res>
    implements $CancelledByUserCopyWith<$Res> {
  _$CancelledByUserCopyWithImpl(
      CancelledByUser _value, $Res Function(CancelledByUser) _then)
      : super(_value, (v) => _then(v as CancelledByUser));

  @override
  CancelledByUser get _value => super._value as CancelledByUser;
}

/// @nodoc
class _$CancelledByUser implements CancelledByUser {
  const _$CancelledByUser();

  @override
  String toString() {
    return 'AuthFailure.cancelledByUser()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is CancelledByUser);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result cancelledByUser(),
    @required Result serverError(),
    @required Result invalidUsernamePasscodeCombination(),
    @required Result noInternetConnectivity(),
  }) {
    assert(cancelledByUser != null);
    assert(serverError != null);
    assert(invalidUsernamePasscodeCombination != null);
    assert(noInternetConnectivity != null);
    return cancelledByUser();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result cancelledByUser(),
    Result serverError(),
    Result invalidUsernamePasscodeCombination(),
    Result noInternetConnectivity(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (cancelledByUser != null) {
      return cancelledByUser();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result cancelledByUser(CancelledByUser value),
    @required Result serverError(ServerError value),
    @required
        Result invalidUsernamePasscodeCombination(
            InvalidUsernamePasscodeCombination value),
    @required Result noInternetConnectivity(NoInternetConnectivity value),
  }) {
    assert(cancelledByUser != null);
    assert(serverError != null);
    assert(invalidUsernamePasscodeCombination != null);
    assert(noInternetConnectivity != null);
    return cancelledByUser(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result cancelledByUser(CancelledByUser value),
    Result serverError(ServerError value),
    Result invalidUsernamePasscodeCombination(
        InvalidUsernamePasscodeCombination value),
    Result noInternetConnectivity(NoInternetConnectivity value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (cancelledByUser != null) {
      return cancelledByUser(this);
    }
    return orElse();
  }
}

abstract class CancelledByUser implements AuthFailure {
  const factory CancelledByUser() = _$CancelledByUser;
}

/// @nodoc
abstract class $ServerErrorCopyWith<$Res> {
  factory $ServerErrorCopyWith(
          ServerError value, $Res Function(ServerError) then) =
      _$ServerErrorCopyWithImpl<$Res>;
}

/// @nodoc
class _$ServerErrorCopyWithImpl<$Res> extends _$AuthFailureCopyWithImpl<$Res>
    implements $ServerErrorCopyWith<$Res> {
  _$ServerErrorCopyWithImpl(
      ServerError _value, $Res Function(ServerError) _then)
      : super(_value, (v) => _then(v as ServerError));

  @override
  ServerError get _value => super._value as ServerError;
}

/// @nodoc
class _$ServerError implements ServerError {
  const _$ServerError();

  @override
  String toString() {
    return 'AuthFailure.serverError()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is ServerError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result cancelledByUser(),
    @required Result serverError(),
    @required Result invalidUsernamePasscodeCombination(),
    @required Result noInternetConnectivity(),
  }) {
    assert(cancelledByUser != null);
    assert(serverError != null);
    assert(invalidUsernamePasscodeCombination != null);
    assert(noInternetConnectivity != null);
    return serverError();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result cancelledByUser(),
    Result serverError(),
    Result invalidUsernamePasscodeCombination(),
    Result noInternetConnectivity(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (serverError != null) {
      return serverError();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result cancelledByUser(CancelledByUser value),
    @required Result serverError(ServerError value),
    @required
        Result invalidUsernamePasscodeCombination(
            InvalidUsernamePasscodeCombination value),
    @required Result noInternetConnectivity(NoInternetConnectivity value),
  }) {
    assert(cancelledByUser != null);
    assert(serverError != null);
    assert(invalidUsernamePasscodeCombination != null);
    assert(noInternetConnectivity != null);
    return serverError(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result cancelledByUser(CancelledByUser value),
    Result serverError(ServerError value),
    Result invalidUsernamePasscodeCombination(
        InvalidUsernamePasscodeCombination value),
    Result noInternetConnectivity(NoInternetConnectivity value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (serverError != null) {
      return serverError(this);
    }
    return orElse();
  }
}

abstract class ServerError implements AuthFailure {
  const factory ServerError() = _$ServerError;
}

/// @nodoc
abstract class $InvalidUsernamePasscodeCombinationCopyWith<$Res> {
  factory $InvalidUsernamePasscodeCombinationCopyWith(
          InvalidUsernamePasscodeCombination value,
          $Res Function(InvalidUsernamePasscodeCombination) then) =
      _$InvalidUsernamePasscodeCombinationCopyWithImpl<$Res>;
}

/// @nodoc
class _$InvalidUsernamePasscodeCombinationCopyWithImpl<$Res>
    extends _$AuthFailureCopyWithImpl<$Res>
    implements $InvalidUsernamePasscodeCombinationCopyWith<$Res> {
  _$InvalidUsernamePasscodeCombinationCopyWithImpl(
      InvalidUsernamePasscodeCombination _value,
      $Res Function(InvalidUsernamePasscodeCombination) _then)
      : super(_value, (v) => _then(v as InvalidUsernamePasscodeCombination));

  @override
  InvalidUsernamePasscodeCombination get _value =>
      super._value as InvalidUsernamePasscodeCombination;
}

/// @nodoc
class _$InvalidUsernamePasscodeCombination
    implements InvalidUsernamePasscodeCombination {
  const _$InvalidUsernamePasscodeCombination();

  @override
  String toString() {
    return 'AuthFailure.invalidUsernamePasscodeCombination()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is InvalidUsernamePasscodeCombination);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result cancelledByUser(),
    @required Result serverError(),
    @required Result invalidUsernamePasscodeCombination(),
    @required Result noInternetConnectivity(),
  }) {
    assert(cancelledByUser != null);
    assert(serverError != null);
    assert(invalidUsernamePasscodeCombination != null);
    assert(noInternetConnectivity != null);
    return invalidUsernamePasscodeCombination();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result cancelledByUser(),
    Result serverError(),
    Result invalidUsernamePasscodeCombination(),
    Result noInternetConnectivity(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (invalidUsernamePasscodeCombination != null) {
      return invalidUsernamePasscodeCombination();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result cancelledByUser(CancelledByUser value),
    @required Result serverError(ServerError value),
    @required
        Result invalidUsernamePasscodeCombination(
            InvalidUsernamePasscodeCombination value),
    @required Result noInternetConnectivity(NoInternetConnectivity value),
  }) {
    assert(cancelledByUser != null);
    assert(serverError != null);
    assert(invalidUsernamePasscodeCombination != null);
    assert(noInternetConnectivity != null);
    return invalidUsernamePasscodeCombination(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result cancelledByUser(CancelledByUser value),
    Result serverError(ServerError value),
    Result invalidUsernamePasscodeCombination(
        InvalidUsernamePasscodeCombination value),
    Result noInternetConnectivity(NoInternetConnectivity value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (invalidUsernamePasscodeCombination != null) {
      return invalidUsernamePasscodeCombination(this);
    }
    return orElse();
  }
}

abstract class InvalidUsernamePasscodeCombination implements AuthFailure {
  const factory InvalidUsernamePasscodeCombination() =
      _$InvalidUsernamePasscodeCombination;
}

/// @nodoc
abstract class $NoInternetConnectivityCopyWith<$Res> {
  factory $NoInternetConnectivityCopyWith(NoInternetConnectivity value,
          $Res Function(NoInternetConnectivity) then) =
      _$NoInternetConnectivityCopyWithImpl<$Res>;
}

/// @nodoc
class _$NoInternetConnectivityCopyWithImpl<$Res>
    extends _$AuthFailureCopyWithImpl<$Res>
    implements $NoInternetConnectivityCopyWith<$Res> {
  _$NoInternetConnectivityCopyWithImpl(NoInternetConnectivity _value,
      $Res Function(NoInternetConnectivity) _then)
      : super(_value, (v) => _then(v as NoInternetConnectivity));

  @override
  NoInternetConnectivity get _value => super._value as NoInternetConnectivity;
}

/// @nodoc
class _$NoInternetConnectivity implements NoInternetConnectivity {
  const _$NoInternetConnectivity();

  @override
  String toString() {
    return 'AuthFailure.noInternetConnectivity()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is NoInternetConnectivity);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result cancelledByUser(),
    @required Result serverError(),
    @required Result invalidUsernamePasscodeCombination(),
    @required Result noInternetConnectivity(),
  }) {
    assert(cancelledByUser != null);
    assert(serverError != null);
    assert(invalidUsernamePasscodeCombination != null);
    assert(noInternetConnectivity != null);
    return noInternetConnectivity();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result cancelledByUser(),
    Result serverError(),
    Result invalidUsernamePasscodeCombination(),
    Result noInternetConnectivity(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (noInternetConnectivity != null) {
      return noInternetConnectivity();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result cancelledByUser(CancelledByUser value),
    @required Result serverError(ServerError value),
    @required
        Result invalidUsernamePasscodeCombination(
            InvalidUsernamePasscodeCombination value),
    @required Result noInternetConnectivity(NoInternetConnectivity value),
  }) {
    assert(cancelledByUser != null);
    assert(serverError != null);
    assert(invalidUsernamePasscodeCombination != null);
    assert(noInternetConnectivity != null);
    return noInternetConnectivity(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result cancelledByUser(CancelledByUser value),
    Result serverError(ServerError value),
    Result invalidUsernamePasscodeCombination(
        InvalidUsernamePasscodeCombination value),
    Result noInternetConnectivity(NoInternetConnectivity value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (noInternetConnectivity != null) {
      return noInternetConnectivity(this);
    }
    return orElse();
  }
}

abstract class NoInternetConnectivity implements AuthFailure {
  const factory NoInternetConnectivity() = _$NoInternetConnectivity;
}
