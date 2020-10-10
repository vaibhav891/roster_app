import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:roster_app/data/core/api_client.dart';
import 'package:roster_app/data/core/api_constants.dart';
import 'package:roster_app/domain/auth/auth_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:roster_app/data/data_sources/remote_data_src.dart';
import 'package:roster_app/domain/auth/user.dart';
import 'package:roster_app/domain/model/locations.dart';
import 'package:roster_app/domain/model/users_report.dart';

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
        Map<String, String> headers = {'Content-Type': 'application/json', 'app-key': ApiConstants.APP_KEY};

        await _client.post(ApiConstants.RESET_PASSCODE_ENDPOINT, body, headers);
        return right('success');
      } catch (e) {
        return left(AuthFailure(e.toString()));
      }
    } else
      return left(AuthFailure('Check your Internet connection'));
  }

  @override
  Future<Either<AuthFailure, String>> signInUser({String userId, String passcode}) async {
    print('enter remoteDataSourceImpl signInUser');
    if (await DataConnectionChecker().hasConnection) {
      try {
        var body = jsonEncode({
          "userId": userId,
          "passcode": 'Abc@1234',
        });
        print('$body');
        Map<String, String> headers = {'Content-Type': 'application/json', 'app-key': ApiConstants.APP_KEY};

        if (userId.contains('manager')) {
          User.instance.userId = userId;
          User.instance.userRole = 'manager';
          return right('NO');
        }

        final response = await _client.post(ApiConstants.LOGIN_ENDPOINT, body, headers);
        Map<String, dynamic> decodedToken = JwtDecoder.decode(response['token']);
        print(decodedToken);
        User.instance.token = response['token'];
        User.instance.userId = decodedToken['data']['public']['user'] ?? '';
        User.instance.userRole = decodedToken['data']['public']['role'] ?? '';

        headers = {
          'Authorization': 'Bearer ${User.instance.token}',
          'content-type': 'application/json',
          'app-key': ApiConstants.APP_KEY
        };
        //print(headers);
        var date = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final timeResponse = await _client.get('${ApiConstants.SHIFT_TIMING_ENDPOINT}?date=$date', headers);
        User.instance.startTime =
            DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(timeResponse['startTimeTs']));
        User.instance.endTime = DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(timeResponse['endTimeTs']));

        return right(response['isFirstLogin'] ? 'YES' : 'NO');
      } catch (e) {
        return left(AuthFailure(e.toString()));
      }
    } else
      return left(AuthFailure('Check your Internet connection'));
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
      Map<String, String> headers = {'Content-Type': 'application/json', 'app-key': ApiConstants.APP_KEY};

      //     final response = await _client.post(ApiConstants.UPDATE_PASSCODE_ENDPOINT, body, headers);
      return right(unit);
      // } catch (e){
      //   return left(AuthFailure(e.toString()));
      //   }
    } else {
      return left(AuthFailure('Check your Internet connection'));
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
        Map<String, String> headers = {'Content-Type': 'application/json', 'app-key': ApiConstants.APP_KEY};

        await Future.delayed(Duration(seconds: 5));
        // await _client.post(ApiConstants.SHIFT_SIGNIN_ENDPOINT, body, headers);
        return right(unit);
      } catch (e) {
        return left(AuthFailure(e.toString()));
      }
    } else
      return left(AuthFailure('Check your Internet connection'));
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
        Map<String, String> headers = {'Content-Type': 'application/json', 'app-key': ApiConstants.APP_KEY};

        // await _client.post(ApiConstants.SHIFT_SIGNOUT_ENDPOINT, body, headers);
        return right(unit);
      } catch (e) {
        return left(AuthFailure(e.toString()));
      }
    } else
      return left(AuthFailure('Check your Internet connection'));
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
        Map<String, String> headers = {'Content-Type': 'application/json', 'app-key': ApiConstants.APP_KEY};

        var responseBody = await Future.delayed(Duration(seconds: 5));
        // await _client.post(ApiConstants.TASK_ENDPOINT, body, headers);
        //return right(responseBody['taskId']);
        return right('1234');
      } catch (e) {
        return left(AuthFailure(e.toString()));
      }
    } else
      return left(AuthFailure('Check your Internet connection'));
  }

  @override
  Future<Either<AuthFailure, String>> finishTask({String id}) async {
    print('enter remoteDataSourceImpl finishTask');
    if (await DataConnectionChecker().hasConnection) {
      try {
        var body = jsonEncode({"taskId": id, "status": "Finished"});
        print('$body');
        Map<String, String> headers = {'Content-Type': 'application/json', 'app-key': ApiConstants.APP_KEY};

        var responseBody = await Future.delayed(Duration(seconds: 5));
        // await _client.post(ApiConstants.TASK_ENDPOINT, body, headers);
        //return right(responseBody['taskId']);
        return right('Success');
      } catch (e) {
        return left(AuthFailure(e.toString()));
      }
    } else
      return left(AuthFailure('Check your Internet connection'));
  }

  @override
  Future<Either<AuthFailure, Unit>> applyLeave(
      {String startDate, String endDate, String leaveType, String reason}) async {
    print('enter remoteDataSourceImpl applyLeave');
    if (await DataConnectionChecker().hasConnection) {
      try {
        var body = jsonEncode({"startDateTs": startDate, "endDateTs": endDate, "reasom": leaveType});
        print('$body');
        Map<String, String> headers = {'Content-Type': 'application/json', 'app-key': ApiConstants.APP_KEY};

        var responseBody = await Future.delayed(Duration(seconds: 5));
        //await _client.post(ApiConstants.APPLY_LEAVE_ENDPOINT, body, headers);
        //return right(responseBody['taskId']);
        return right(unit);
      } catch (e) {
        return left(AuthFailure(e.toString()));
      }
    } else
      return left(AuthFailure('Check your Internet connection'));
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
        Map<String, String> headers = {'Content-Type': 'application/json', 'app-key': ApiConstants.APP_KEY};

        var responseBody = await Future.delayed(Duration(seconds: 5));
        //await _client.post(ApiConstants.RUNNING_LATE_ENDPOINT, body, headers);
        //return right(responseBody['taskId']);
        return right(unit);
      } catch (e) {
        return left(AuthFailure(e.toString()));
      }
    } else
      return left(AuthFailure('Check your Internet connection'));
  }

  @override
  Future<Either<AuthFailure, Map<String, dynamic>>> getShiftTiming({String date}) async {
    print('enter remoteDataSourceImpl getShiftTiming');
    if (await DataConnectionChecker().hasConnection) {
      try {
        //var responseBody = await Future.delayed(Duration(seconds: 5));
        Map<String, String> headers = {'Content-Type': 'application/json', 'app-key': ApiConstants.APP_KEY};

        var responseBody = await _client.get(ApiConstants.SHIFT_TIMING_ENDPOINT + '?date=$date', headers);
        //return right(responseBody['taskId']);
        return right({'startTime': responseBody['startTimeTs'], 'endTime': responseBody['endTime']});
      } catch (e) {
        return left(AuthFailure(e.toString()));
      }
    } else
      return left(AuthFailure('Check your Internet connection'));
  }

  @override
  Future<Either<AuthFailure, UsersReport>> fetchUserReport({String startDate, String endDate}) async {
    print('enter remoteDataSourceImpl fetchUserReport');
    if (await DataConnectionChecker().hasConnection) {
      try {
        var body = jsonEncode({
          "startDateTs": startDate,
          "endDateTs": endDate,
        });
        print('$body');
        Map<String, String> headers = {'Content-Type': 'application/json', 'app-key': ApiConstants.APP_KEY};

        //var responseBody = await Future.delayed(Duration(seconds: 5));
        var responseBody = await _client.post(ApiConstants.USERS_REPORT_ENDPOINT, body, headers);
        return right(UsersReport.fromJson(jsonDecode(responseBody)));
      } catch (e) {
        return left(AuthFailure(e.toString()));
      }
    } else
      return left(AuthFailure('Check your Internet connection'));
  }

  @override
  Future<Either<AuthFailure, LocationsList>> fetchUserSite() async {
    print('enter remoteDataSourceImpl fetchUserSite');
    if (await DataConnectionChecker().hasConnection) {
      try {
        //var responseBody = await Future.delayed(Duration(seconds: 5));
        Map<String, String> headers = {
          'Authorization':'Bearer ${User.instance.token}',
          'Content-Type': 'application/json',
          'app-key': ApiConstants.APP_KEY,
        };

        var responseBody = await _client.get(ApiConstants.USER_SITE_ENDPOINT, headers );
        //return right(responseBody['taskId']);
        return right(LocationsList.fromJson(jsonDecode(responseBody)));
      } catch (e) {
        return left(AuthFailure(e.toString()));
      }
    } else
      return left(AuthFailure('Check your Internet connection'));
  }
}
