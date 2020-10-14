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
        Map<String, String> headers = {
          'Content-Type': 'application/json',
          'app-key': ApiConstants.APP_KEY,
        };

        await _client.post(ApiConstants.RESET_PASSCODE_ENDPOINT, body, headers);
        return right('success');
      } catch (e) {
        print(e.toString());
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
          "passcode": passcode,
        });
        print('$body');
        Map<String, String> headers = {'Content-Type': 'application/json', 'app-key': ApiConstants.APP_KEY};

        // if (userId.contains('manager')) {
        //   User.instance.userId = userId;
        //   User.instance.userRole = 'manager';
        //   return right('NO');
        // }

        final response = await _client.post(ApiConstants.LOGIN_ENDPOINT, body, headers);
        Map<String, dynamic> decodedToken = JwtDecoder.decode(response['token']);
        print(decodedToken);
        User.instance.token = response['token'];
        User.instance.userId = userId ?? '';
        User.instance.userRole = decodedToken['data']['public']['role'] ?? '';

        if (User.instance.userRole == "User") {
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
          User.instance.endTime =
              DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(timeResponse['endTimeTs']));
        }
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
      try {
        var body = jsonEncode({
          "userId": userId,
          "passcode": passcode,
          "newPasscode": newPasscode,
        });
        print('$body');
        Map<String, String> headers = {'Content-Type': 'application/json', 'app-key': ApiConstants.APP_KEY};

        final response = await _client.post(ApiConstants.UPDATE_PASSCODE_ENDPOINT, body, headers);
        return right(unit);
      } catch (e) {
        return left(AuthFailure(e.toString()));
      }
    } else {
      return left(AuthFailure('Check your Internet connection'));
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> shiftSignIn({double lat, double long}) async {
    print('enter remoteDataSourceImpl shiftSignIn');
    if (await DataConnectionChecker().hasConnection) {
      try {
        var body = jsonEncode({
          "latitude": lat,
          "longitude": long,
        });
        print('$body');
        Map<String, String> headers = {
          'Authorization': 'Bearer ${User.instance.token}',
          'Content-Type': 'application/json',
          'app-key': ApiConstants.APP_KEY,
        };

        //await Future.delayed(Duration(seconds: 5));
        await _client.post(ApiConstants.SHIFT_SIGNIN_ENDPOINT, body, headers);
        return right(unit);
      } catch (e) {
        print(e.toString());
        return left(AuthFailure(e.toString()));
      }
    } else
      return left(AuthFailure('Check your Internet connection'));
  }

  @override
  Future<Either<AuthFailure, Unit>> shiftSignOut({double lat, double long}) async {
    print('enter remoteDataSourceImpl shiftSignOut');
    if (await DataConnectionChecker().hasConnection) {
      try {
        var body = jsonEncode({
          "latitude": lat,
          "longitude": long,
        });
        print('$body');

        //await Future.delayed(Duration(seconds: 5));
        Map<String, String> headers = {
          'Authorization': 'Bearer ${User.instance.token}',
          'Content-Type': 'application/json',
          'app-key': ApiConstants.APP_KEY,
        };

        await _client.post(ApiConstants.SHIFT_SIGNOUT_ENDPOINT, body, headers);
        return right(unit);
      } catch (e) {
        return left(AuthFailure(e.toString()));
      }
    } else
      return left(AuthFailure('Check your Internet connection'));
  }

  @override
  Future<Either<AuthFailure, int>> startTask({String id}) async {
    print('enter remoteDataSourceImpl startTask');
    if (await DataConnectionChecker().hasConnection) {
      try {
        var body = jsonEncode({
          "locationCode": id,
          "status": "checkin",
        });
        print('$body');
        Map<String, String> headers = {
          'Authorization': 'Bearer ${User.instance.token}',
          'Content-Type': 'application/json',
          'app-key': ApiConstants.APP_KEY,
        };

        //var responseBody = await Future.delayed(Duration(seconds: 5));
        var responseBody = await _client.post(ApiConstants.TASK_ENDPOINT, body, headers);
        print(responseBody["taskId"]);
        User.instance.taskId = responseBody["taskId"];
        return right(responseBody['taskId']);
        //return right('1234');
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
        var body = jsonEncode({"taskId": int.parse(id), "status": "checkout"});
        print('$body');
        Map<String, String> headers = {
          'Authorization': 'Bearer ${User.instance.token}',
          'Content-Type': 'application/json',
          'app-key': ApiConstants.APP_KEY,
        };

        //var responseBody = await Future.delayed(Duration(seconds: 5));
        var responseBody = await _client.post(ApiConstants.TASK_ENDPOINT, body, headers);
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
        var body;
        int stDate = int.parse(startDate);
        int enDate = int.parse(endDate);

        if (reason == null) {
          body = jsonEncode({
            "startDateTs": stDate,
            "endDateTs": enDate,
            "type": leaveType,
          });
        } else {
          body = jsonEncode({
            "startDateTs": stDate,
            "endDateTs": enDate,
            "reason": reason,
            "type": leaveType,
          });
        }
        print('$body');
        Map<String, String> headers = {
          'Authorization': 'Bearer ${User.instance.token}',
          'Content-Type': 'application/json',
          'app-key': ApiConstants.APP_KEY,
        };

        //var responseBody = await Future.delayed(Duration(seconds: 5));
        await _client.post(ApiConstants.APPLY_LEAVE_ENDPOINT, body, headers);
        //return right(responseBody['taskId']);
        return right(unit);
      } catch (e) {
        return left(AuthFailure(e.toString()));
      }
    } else
      return left(AuthFailure('Check your Internet connection'));
  }

  @override
  Future<Either<AuthFailure, Unit>> runningLate({int duration}) async {
    print('enter remoteDataSourceImpl runningLate');
    if (await DataConnectionChecker().hasConnection) {
      try {
        var body = jsonEncode({
          "durationInMins": duration,
        });
        print('$body');
        Map<String, String> headers = {
          'Authorization': 'Bearer ${User.instance.token}',
          'Content-Type': 'application/json',
          'app-key': ApiConstants.APP_KEY,
        };

        //var responseBody = await Future.delayed(Duration(seconds: 5));
        await _client.post(ApiConstants.RUNNING_LATE_ENDPOINT, body, headers);
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
        Map<String, String> headers = {
          'Authorization': 'Bearer ${User.instance.token}',
          'Content-Type': 'application/json',
          'app-key': ApiConstants.APP_KEY,
        };

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
  Future<Either<AuthFailure, UsersReport>> fetchUserReport({
    String startDate,
    String endDate,
  }) async {
    print('enter remoteDataSourceImpl fetchUserReport');
    if (await DataConnectionChecker().hasConnection) {
      try {
        var body = jsonEncode({
          "startDateTs": startDate,
          "endDateTs": endDate,
        });
        print('$body');
        Map<String, String> headers = {
          'Authorization': 'Bearer ${User.instance.token}',
          'Content-Type': 'application/json',
          'app-key': ApiConstants.APP_KEY,
        };

        // var responseBody = jsonEncode({
        //   "startDateTs": 1231,
        //   "endDateTs": 2568,
        //   "totalWorkTimeInHrs": 36,
        //   "remainingWorkTimeInHrs": 26,
        //   "workSummary": [
        //     {
        //       "locationId": 8,
        //       "locationName": "VR Mall - Bengaluru",
        //       "dailyReport": [
        //         {
        //           "name": "Adeesh",
        //           "userId": 63,
        //           "dateTs": 1602018342485,
        //           "checkInTimeTs": 1602018342485,
        //           "checkOutTimeTs": 1602018342485,
        //           "durationInHrs": 9,
        //           "lateInMins": 19
        //         },
        //         {"name": "Adeesh", "userId": 64, "dateTs": 1602018342485, "leaveType": "sick"},
        //         {"name": "Adeesh", "userId": 65, "dateTs": 1602018342485, "leaveType": "planned"},
        //         {
        //           "name": "Adeesh",
        //           "userId": 66,
        //           "dateTs": 1602018342485,
        //           "checkInTimeTs": 1602018342485,
        //           "checkOutTimeTs": 1602018342485,
        //           "durationInHrs": 3,
        //           "lateInMins": 25
        //         }
        //       ]
        //     },
        //     {
        //       "locationId": 1,
        //       "locationName": "VB Mall - Bengaluru",
        //       "dailyReport": [
        //         {
        //           "name": "Adeesh",
        //           "userId": 63,
        //           "dateTs": 1602018342486,
        //           "checkInTimeTs": 1602018342486,
        //           "checkOutTimeTs": 1602018342486,
        //           "durationInHrs": 10,
        //           "lateInMins": 12
        //         },
        //         {
        //           "name": "Adeesh",
        //           "userId": 64,
        //           "dateTs": 1602018342486,
        //           "checkInTimeTs": 1602018342486,
        //           "checkOutTimeTs": 1602018342486,
        //           "durationInHrs": 3,
        //           "lateInMins": 3
        //         },
        //         {
        //           "name": "Adeesh",
        //           "userId": 65,
        //           "dateTs": 1602018342486,
        //           "checkInTimeTs": 1602018342486,
        //           "checkOutTimeTs": 1602018342486,
        //           "durationInHrs": 8,
        //           "lateInMins": 10
        //         },
        //         {
        //           "name": "Adeesh",
        //           "userId": 66,
        //           "dateTs": 1602018342486,
        //           "checkInTimeTs": 1602018342486,
        //           "checkOutTimeTs": 1602018342486,
        //           "durationInHrs": 8,
        //           "lateInMins": 36
        //         }
        //       ]
        //     },
        //     {
        //       "locationId": 9,
        //       "locationName": "VG Mall - Bengaluru",
        //       "dailyReport": [
        //         {
        //           "name": "Adeesh",
        //           "userId": 63,
        //           "dateTs": 1602018342486,
        //           "checkInTimeTs": 1602018342486,
        //           "checkOutTimeTs": 1602018342486,
        //           "durationInHrs": 1,
        //           "lateInMins": 43
        //         },
        //         {
        //           "name": "Adeesh",
        //           "userId": 64,
        //           "dateTs": 1602018342486,
        //           "checkInTimeTs": 1602018342486,
        //           "checkOutTimeTs": 1602018342486,
        //           "durationInHrs": 1,
        //           "lateInMins": 40
        //         },
        //         {
        //           "name": "Adeesh",
        //           "userId": 65,
        //           "dateTs": 1602018342486,
        //           "checkInTimeTs": 1602018342486,
        //           "checkOutTimeTs": 1602018342486,
        //           "durationInHrs": 2,
        //           "lateInMins": 48
        //         },
        //         {
        //           "name": "Adeesh",
        //           "userId": 66,
        //           "dateTs": 1602018342486,
        //           "checkInTimeTs": 1602018342486,
        //           "checkOutTimeTs": 1602018342486,
        //           "durationInHrs": 0,
        //           "lateInMins": 48
        //         }
        //       ]
        //     }
        //   ]
        // });
        var responseBody = await _client.post(ApiConstants.USERS_REPORT_ENDPOINT, body, headers);

        print(responseBody.toString());
        return right(UsersReport.fromJson(responseBody));
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
          'Authorization': 'Bearer ${User.instance.token}',
          'Content-Type': 'application/json',
          'app-key': ApiConstants.APP_KEY,
        };

        var responseBody = await _client.get(ApiConstants.USER_SITE_ENDPOINT, headers);
        // var responseBody = jsonEncode(
        //   {
        //     "Locations": [
        //       {
        //         "id": 1,
        //         "name": "VR Bengaluru",
        //         "address": "Whitefield Main Rd, Devasandra Industrial Estate, Mahadevapura, ",
        //         "city": "Bengaluru",
        //         "state": "Karnataka",
        //         "country": "India",
        //         "zipCode": "560048",
        //         "radiusInMeter": 100,
        //         "company": "Virtuous Retail",
        //         "location": {"latitude": 12.996383, "longitude": 77.6942964}
        //       }
        //     ]
        //   },
        // );
        return right(LocationsList.fromJson(responseBody));
      } catch (e) {
        return left(AuthFailure(e.toString()));
      }
    } else
      return left(AuthFailure('Check your Internet connection'));
  }

  Future<Either<AuthFailure, Unit>> updateDeviceInfo({Map<String, dynamic> deviceInfo}) async {
    print('enter remoteDataSourceImpl updateDeviceInfo');
    if (await DataConnectionChecker().hasConnection) {
      try {
        var body = jsonEncode(deviceInfo);
        print('$body');
        Map<String, String> headers = {
          'Authorization': 'Bearer ${User.instance.token}',
          'Content-Type': 'application/json',
          'app-key': ApiConstants.APP_KEY,
        };

        //var responseBody = await Future.delayed(Duration(seconds: 5));
        await _client.post(ApiConstants.UPDATE_DEVICE_INFO_ENDPOINT, body, headers);
        //return right(responseBody['taskId']);
        return right(unit);
      } catch (e) {
        return left(AuthFailure(e.toString()));
      }
    } else
      return left(AuthFailure('Check your Internet connection'));
  }
}
