import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:roster_app/data/core/api_client.dart';
import 'package:roster_app/data/core/api_constants.dart';
import 'package:roster_app/domain/NotificationBloc/Models/notification_model.dart';
import 'package:roster_app/domain/auth/auth_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:roster_app/data/data_sources/remote_data_src.dart';
import 'package:roster_app/domain/auth/user.dart';
import 'package:roster_app/domain/model/locations.dart';
import 'package:roster_app/domain/model/users_report.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    var prefs = await SharedPreferences.getInstance();
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
        prefs.setString('token', response['token']);
        User.instance.token = response['token'];
        User.instance.userId = decodedToken['data']['public']['user'] ?? '';
        User.instance.userRole = decodedToken['data']['public']['role'] ?? '';

        // if (User.instance.userRole == "User") {
        //   headers = {
        //     'Authorization': 'Bearer ${User.instance.token}',
        //     'content-type': 'application/json',
        //     'app-key': ApiConstants.APP_KEY
        //   };
        //   //print(headers);
        //   var date = DateFormat('yyyy-MM-dd').format(DateTime.now());
        //   final timeResponse = await _client.get('${ApiConstants.SHIFT_TIMING_ENDPOINT}?date=$date', headers);
        //   User.instance.startTime =
        //       DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(timeResponse['startTimeTs']));
        //   User.instance.endTime =
        //       DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(timeResponse['endTimeTs']));
        //   SharedPreferences prefs = await SharedPreferences.getInstance();
        //   prefs.setString('shiftStartTime', User.instance.startTime);
        //   prefs.setString('shiftEndTime', User.instance.endTime);
        // }
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
          'x-app-timezone': 'Australia/Sydney'
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
          'x-app-timezone': 'Australia/Sydney'
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
          'x-app-timezone': 'Australia/Sydney'
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
          'x-app-timezone': 'Australia/Sydney'
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
            "zoneId": "Australia/Sydney",
            "type": leaveType,
          });
        } else {
          body = jsonEncode({
            "startDateTs": stDate,
            "endDateTs": enDate,
            "reason": reason,
            "zoneId": "Australia/Sydney",
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
          'x-app-timezone': 'Australia/Sydney'
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

  // @override
  // Future<Either<AuthFailure, Map<String, dynamic>>> getShiftTiming({String date}) async {
  //   print('enter remoteDataSourceImpl getShiftTiming');
  //   if (await DataConnectionChecker().hasConnection) {
  //     try {
  //       //var responseBody = await Future.delayed(Duration(seconds: 5));
  //       Map<String, String> headers = {
  //         'Authorization': 'Bearer ${User.instance.token}',
  //         'Content-Type': 'application/json',
  //         'app-key': ApiConstants.APP_KEY,
  //       };

  //       var responseBody = await _client.get(ApiConstants.SHIFT_TIMING_ENDPOINT + '?date=$date', headers);
  //       //return right(responseBody['taskId']);
  //       return right({'startTime': responseBody['startTimeTs'], 'endTime': responseBody['endTime']});
  //     } catch (e) {
  //       return left(AuthFailure(e.toString()));
  //     }
  //   } else
  //     return left(AuthFailure('Check your Internet connection'));
  // }

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
          'x-app-timezone': 'Australia/Sydney'
        };

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
          'x-app-timezone': 'Australia/Sydney'
        };

        var responseBody = await _client.get(ApiConstants.USER_SITE_ENDPOINT, headers);
        return right(LocationsList.fromJson(responseBody));
      } catch (e) {
        return left(AuthFailure(e.toString()));
      }
    } else
      return left(AuthFailure('Check your Internet connection'));
  }

  @override
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
          'x-app-timezone': 'Australia/Sydney'
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

  @override
  Future<Either<AuthFailure, Unit>> syncInfo() async {
    print('enter remoteDataSourceImpl syncInfo');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (await DataConnectionChecker().hasConnection) {
      try {
        Map<String, String> headers = {
          'Authorization': 'Bearer ${User.instance.token}',
          'Content-Type': 'application/json',
          'app-key': ApiConstants.APP_KEY,
          'x-app-timezone': 'Australia/Sydney'
        };

        var date = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final timeResponse = await _client.get('${ApiConstants.SHIFT_TIMING_ENDPOINT}?date=$date', headers);

        if (timeResponse.containsKey('startTimeTs')) {
          // User.instance.startTime =
          //     DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(timeResponse['startTimeTs']));
          // User.instance.endTime =
          //     DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(timeResponse['endTimeTs']));
          User.instance.startTime = timeResponse['startTimeTs'];
          User.instance.endTime = timeResponse['endTimeTs'];
          User.instance.duration = User.instance.endTime - User.instance.startTime;
          prefs.setInt('shiftStartTime', User.instance.startTime);
          prefs.setInt('shiftEndTime', User.instance.endTime);
          prefs.setInt('shiftDuration', User.instance.duration);
        }

        headers = {
          'Authorization': 'Bearer ${User.instance.token}',
          'Content-Type': 'application/json',
          'app-key': ApiConstants.APP_KEY,
          'x-app-timezone': 'Australia/Sydney'
        };

        var responseBody = await _client.get(ApiConstants.SYNC_INFO_ENDPOINT, headers);
        if ((responseBody as Map).containsKey('taskId')) {
          User.instance.taskId = (responseBody as Map)['taskId'];
        }
        if ((responseBody as Map).containsKey('signInTimeTs')) {
          User.instance.shiftSignInTime = responseBody['signInTimeTs'];
          // User.instance.startTime = responseBody['signInTimeTs'];
          // // DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(responseBody['signInTimeTs']));
          // prefs.setInt('shiftStartTime', User.instance.startTime);
        }
        if ((responseBody as Map).containsKey('checkInTimeTs')) {
          User.instance.checkInTime =
              DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(timeResponse['checkInTimeTs'])).toString();
        }
        User.instance.isSignedIn = responseBody['isSignedIn'];
        User.instance.isOnLeave = responseBody['isUserOnLeave'];

        return right(unit);
      } catch (e) {
        return left(AuthFailure(e.toString()));
      }
    } else
      return left(AuthFailure('Check your Internet connection'));
  }

  @override
  Future<Either<AuthFailure, NotificationList>> fetchNotifications() async {
    print('enter remoteDataSourceImpl fetchUserSite');
    if (await DataConnectionChecker().hasConnection) {
      try {
        //var responseBody = await Future.delayed(Duration(seconds: 5));
        Map<String, String> headers = {
          'Authorization': 'Bearer ${User.instance.token}',
          'Content-Type': 'application/json',
          'app-key': ApiConstants.APP_KEY,
          'x-app-timezone': 'Australia/Sydney'
        };

        var responseBody = await _client.get(ApiConstants.GET_NOTIFICATION_ENDPOINT, headers);
        //print(responseBody.toString());
        //var decodedJson = jsonDecode(responseBody);
        return right(NotificationList.fromJson(responseBody));
      } catch (e) {
        return left(AuthFailure(e.toString()));
      }
    } else
      return left(AuthFailure('Check your Internet connection'));
  }
}
