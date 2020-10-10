import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:roster_app/domain/auth/auth_failure.dart';
import 'package:roster_app/domain/model/locations.dart';
import 'package:roster_app/domain/model/users_report.dart';

abstract class RemoteDataSrc {
  //Future<Option<User>> signedInUser();

  Future<Either<AuthFailure, String>> registerUser({@required String userId});

  Future<Either<AuthFailure, String>> signInUser({@required String userId, @required String passcode});

  Future<Either<AuthFailure, Unit>> updatePasscode(
      {@required String userId, @required String passcode, @required String newPasscode});

  Future<void> signOut();

  Future<Either<AuthFailure, Unit>> shiftSignIn({
    @required String lat,
    @required String long,
  });
  Future<Either<AuthFailure, Unit>> shiftSignOut({
    @required String lat,
    @required String long,
  });
  Future<Either<AuthFailure, String>> startTask({@required String id});
  Future<Either<AuthFailure, String>> finishTask({@required String id});

  Future<Either<AuthFailure, Unit>> applyLeave({
    @required String startDate,
    @required String endDate,
    @required String leaveType,
    @required String reason,
  });
  Future<Either<AuthFailure, Unit>> runningLate({
    @required int date,
    @required double duration,
  });

  Future<Either<AuthFailure, Map<String, dynamic>>> getShiftTiming({
    String date,
  });

  Future<Either<AuthFailure, UsersReport>> fetchUserReport({
    String startDate,
    String endDate,
  });

  Future<Either<AuthFailure, LocationsList>> fetchUserSite();

}
