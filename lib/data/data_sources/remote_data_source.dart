import 'package:roster_app/data/core/api_client.dart';
import 'package:roster_app/domain/auth/auth_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:roster_app/domain/auth/i_auth_facade.dart';
import 'package:roster_app/domain/auth/value_objects.dart';
import 'package:roster_app/domain/auth/user.dart';

class RemoteDataSource implements IAuthFacade {
  final ApiClient _client;

  RemoteDataSource(this._client);

  @override
  Future<Either<AuthFailure, Unit>> registerUser({String userId}) {
    // TODO: implement registerUser
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthFailure, Unit>> signInUser({String userId, String passcode}) {
    // TODO: implement signInUser
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
