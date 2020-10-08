import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:roster_app/data/core/api_client.dart';
import 'package:roster_app/data/core/api_constants.dart';
import 'package:roster_app/domain/auth/auth_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:roster_app/data/data_sources/remote_data_src.dart';
import 'package:roster_app/domain/auth/user.dart';

class RemoteDataSrcImpl implements RemoteDataSrc {
  final ApiClient _client;

  RemoteDataSrcImpl(this._client);

  @override
  Future<Either<AuthFailure, String>> registerUser({String userId}) async {
    print('enter remoteDataSourceImpl registerUser');
    if (await DataConnectionChecker().hasConnection) {
      try {
        var body = jsonEncode({
          "userId": userId,
        });
        print('$body');

        await _client.post(ApiConstants.RESET_PASSCODE_ENDPOINT, body);
        return right('success');
      } on Exception {
        return left(AuthFailure.invalidUsernamePasscodeCombination());
      }
    } else
      return left(AuthFailure.noInternetConnectivity());
  }

  @override
  Future<Either<AuthFailure, String>> signInUser({String userId, String passcode}) async {
    print('enter remoteDataSourceImpl signInUser');
    if (await DataConnectionChecker().hasConnection) {
      try {
        var body = jsonEncode({
          "userId": userId,
          "passcode": passcode,
        });
        print('$body');

        final response = await _client.post(ApiConstants.LOGIN_ENDPOINT, body);
        Map<String, dynamic> decodedToken = JwtDecoder.decode(response['token']);
        print(decodedToken);
        User.instance.userId = decodedToken['data']['public']['user'] ?? '';
        User.instance.userRole = decodedToken['data']['public']['role'] ?? '';
        return right(response['isFirstLogin'] ? 'YES' : 'NO');
      } on Exception {
        return left(AuthFailure.invalidUsernamePasscodeCombination());
      }
    } else
      return left(AuthFailure.noInternetConnectivity());
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthFailure, Unit>> updatePasscode({String userId, String passcode, String newPasscode}) async {
    print('enter remoteDataSourceImpl updatePasscode');

    if (await DataConnectionChecker().hasConnection) {
      //   try {
      var body = jsonEncode({
        "userId": userId,
        "passcode": passcode,
        "newPasscode": newPasscode,
      });
      print('$body');

      //     final response = await _client.post(ApiConstants.UPDATE_PASSCODE_ENDPOINT, body);
      return right(unit);
      //   } on Exception {
      //return left(AuthFailure.serverError());
      //   }
    } else {
      return left(AuthFailure.noInternetConnectivity());
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> shiftSignIn({String lat, String long}) async {
    print('enter remoteDataSourceImpl shiftSignIn');
    if (await DataConnectionChecker().hasConnection) {
      try {
        var body = jsonEncode({
          "latitude": lat,
          "longitude": long,
        });
        print('$body');
        await Future.delayed(Duration(seconds: 5));
        // await _client.post(ApiConstants.SHIFT_SIGNIN_ENDPOINT, body);
        return right(unit);
      } on Exception {
        return left(AuthFailure.serverError());
      }
    } else
      return left(AuthFailure.noInternetConnectivity());
  }

  @override
  Future<Either<AuthFailure, Unit>> shiftSignOut({String lat, String long}) async {
    print('enter remoteDataSourceImpl shiftSignOut');
    if (await DataConnectionChecker().hasConnection) {
      try {
        var body = jsonEncode({
          "latitude": lat,
          "longitude": long,
        });
        print('$body');

        await Future.delayed(Duration(seconds: 5));
        // await _client.post(ApiConstants.SHIFT_SIGNOUT_ENDPOINT, body);
        return right(unit);
      } on Exception {
        return left(AuthFailure.serverError());
      }
    } else
      return left(AuthFailure.noInternetConnectivity());
  }

  @override
  Future<Either<AuthFailure, String>> startTask({String id}) async {
    print('enter remoteDataSourceImpl startTask');
    if (await DataConnectionChecker().hasConnection) {
      try {
        var body = jsonEncode({
          "locationId": id,
        });
        print('$body');
        var responseBody = await Future.delayed(Duration(seconds: 5));
        // await _client.post(ApiConstants.TASK_ENDPOINT, body);
        //return right(responseBody['taskId']);
        return right('1234');
      } on Exception {
        return left(AuthFailure.serverError());
      }
    } else
      return left(AuthFailure.noInternetConnectivity());
  }

  @override
  Future<Either<AuthFailure, String>> finishTask({String id}) async {
    print('enter remoteDataSourceImpl finishTask');
    if (await DataConnectionChecker().hasConnection) {
      try {
        var body = jsonEncode({"taskId": id, "status": "Finished"});
        print('$body');
        var responseBody = await Future.delayed(Duration(seconds: 5));
        // await _client.post(ApiConstants.TASK_ENDPOINT, body);
        //return right(responseBody['taskId']);
        return right('Success');
      } on Exception {
        return left(AuthFailure.serverError());
      }
    } else
      return left(AuthFailure.noInternetConnectivity());
  }

  @override
  Future<Either<AuthFailure, Unit>> applyLeave(
      {String startDate, String endDate, String leaveType, String reason}) async {
    print('enter remoteDataSourceImpl applyLeave');
    if (await DataConnectionChecker().hasConnection) {
      try {
        var body = jsonEncode({"startDateTs": startDate, "endDateTs": endDate, "reasom": leaveType});
        print('$body');
        var responseBody = await Future.delayed(Duration(seconds: 5));
        //await _client.post(ApiConstants.APPLY_LEAVE_ENDPOINT, body);
        //return right(responseBody['taskId']);
        return right(unit);
      } on Exception {
        return left(AuthFailure.serverError());
      }
    } else
      return left(AuthFailure.noInternetConnectivity());
  }

  @override
  Future<Either<AuthFailure, Unit>> runningLate({int date, double duration}) async {
    print('enter remoteDataSourceImpl runningLate');
    if (await DataConnectionChecker().hasConnection) {
      try {
        var body = jsonEncode({
          "dateTs": date,
          "durationInMins": duration,
        });
        print('$body');
        var responseBody = await Future.delayed(Duration(seconds: 5));
        //await _client.post(ApiConstants.RUNNING_LATE_ENDPOINT, body);
        //return right(responseBody['taskId']);
        return right(unit);
      } on Exception {
        return left(AuthFailure.serverError());
      }
    } else
      return left(AuthFailure.noInternetConnectivity());
  }
}
