class User {
  static final User _instance = User._();

  User._();

  static User get instance => _instance;

  String uid;
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
  bool isOnLeave = false;

  factory User() {
    return _instance;
  }
}
