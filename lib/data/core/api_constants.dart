class ApiConstants {
  ApiConstants._();

  static const String APP_NAME = 'Roster-App';
  static const String BASE_URL = 'https://yis-roswed-dev-rzl6t4rbta-ts.a.run.app';
  static const String APP_KEY = 'kh3Ty7vmeLcWHhchlpEVZPILnRTNqrsB';
  static const String BASE_IMAGE_URL = 'https://image.tmdb.org/t/p/w500';
  static const String LOGIN_ENDPOINT = '/api/v1/security/login';
  static const String UPDATE_PASSCODE_ENDPOINT = '/api/v1/security/passcode';
  static const String RESET_PASSCODE_ENDPOINT = '/api/v1/security/reset';
  static const String SHIFT_SIGNIN_ENDPOINT = '/api/v1/user/sign-in';
  static const String SHIFT_SIGNOUT_ENDPOINT = '/api/v1/user/sign-out';
  static const String TASK_ENDPOINT = '/api/v1/job';
  static const String APPLY_LEAVE_ENDPOINT = '/api/v1/user/leave';
  static const String RUNNING_LATE_ENDPOINT = '/api/v1/user/runninglate';
  static const String SHIFT_TIMING_ENDPOINT = '/api/v1/user/shift';
  static const String USERS_REPORT_ENDPOINT = '/api/v1/report';
  static const String USER_SITE_ENDPOINT = '/api/v1/user/site';
  static const String UPDATE_DEVICE_INFO_ENDPOINT = '/api/v1/user/deviceInfo';
}
