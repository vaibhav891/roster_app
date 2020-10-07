class User {
  static final User _instance = User._();

  User._();

  static User get instance => _instance;

  String userId;
  String userRole;
  bool isFirstLogin;
  String token;

  factory User() {
    return _instance;
  }
}
