class User {
  static final User _instance = User._();

  User._();

  static User get instance => _instance;

  String userId;
  String userRole;
  bool isFirstLogin;
  String token;
  double lat;
  double long;
  String startTime;
  String endTime;
  String checkInTime;
  int taskId;
  bool isSignedIn;

  factory User() {
    return _instance;
  }
}
