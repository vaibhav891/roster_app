import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:roster_app/domain/auth/value_objects.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const factory User({@required UniqueId uid}) = _User;
}
