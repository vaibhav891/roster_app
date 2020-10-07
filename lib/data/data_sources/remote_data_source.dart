import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:roster_app/data/core/api_client.dart';
import 'package:roster_app/data/core/api_constants.dart';
import 'package:roster_app/domain/auth/auth_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:roster_app/domain/auth/i_auth_facade.dart';
import 'package:roster_app/domain/auth/value_objects.dart';
import 'package:roster_app/domain/auth/user.dart';

class RemoteDataSource implements IAuthFacade {
  final ApiClient _client;

  RemoteDataSource(this._client);

  @override
  Future<Either<AuthFailure, String>> registerUser({String userId}) async {
    print('enter remoteDataSource registerUser');
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
    print('enter remoteDataSource signInUser');
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
    print('enter remoteDataSource updatePasscode');

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
}
