class User {
  static final User _instance = User._();

  User._();

  static User get instance => _instance;

  String uid = '';
  String userId = '';
  String userRole = '';
  bool isFirstLogin = true;
  String token = '';
  double lat = 0.0;
  double long = 0.0;
  int startTime = 0;
  int endTime = 0;
  int duration = 0;
  int shiftSignInTime = 0;
  int workDurationInMins = 0;
  String checkInTime = '';
  int taskId = 0;
  bool isSignedIn = false;
  bool isOnLeave = false;

  factory User() {
    return _instance;
  }

  clear() {
    _instance.uid = '';
    _instance.userId = '';
    _instance.userRole = '';
    _instance.isFirstLogin = true;
    _instance.token = '';
    _instance.startTime = 0;
    _instance.endTime = 0;
    _instance.lat = 0.0;
    _instance.long = 0.0;
    _instance.startTime = 0;
    _instance.endTime = 0;
    _instance.duration = 0;
    _instance.shiftSignInTime = 0;
    _instance.workDurationInMins = 0;
    _instance.checkInTime = '';
    _instance.taskId = 0;
    _instance.isSignedIn = false;
    _instance.isOnLeave = false;
  }
}
