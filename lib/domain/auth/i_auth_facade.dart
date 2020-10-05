import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:roster_app/domain/auth/auth_failure.dart';
import 'package:roster_app/domain/auth/user.dart';
import 'package:roster_app/domain/auth/value_objects.dart';

abstract class IAuthFacade {
  //Future<Option<User>> signedInUser();

  Future<Either<AuthFailure, Unit>> registerUser({@required String userId});

  Future<Either<AuthFailure, Unit>> signInUser({@required String userId, @required String passcode});

  Future<void> signOut();
}
