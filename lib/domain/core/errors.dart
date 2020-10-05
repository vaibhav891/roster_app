import 'package:roster_app/domain/core/failures.dart';

class UnexpectedValueError extends Error {
  final ValueFailure valueFailure;

  UnexpectedValueError(this.valueFailure);

  @override
  String toString() {
    return Error.safeToString(
        'Encountered a ValueFailure at an unrecoverable point. Terminating. Failure was $valueFailure');
  }
}
