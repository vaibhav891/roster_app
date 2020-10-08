class ApiConstants {
  ApiConstants._();

  static const String APP_NAME = 'Roster-App';
  static const String BASE_URL = 'https://yis-roswed-dev-rzl6t4rbta-ts.a.run.app';
  static const String API_KEY = '93bb2c82215e5135930597c0dbfeb783';
  static const String BASE_IMAGE_URL = 'https://image.tmdb.org/t/p/w500';
  static const String LOGIN_ENDPOINT = '/api/v1/security/login';
  static const String UPDATE_PASSCODE_ENDPOINT = '/api/v1/security/passcode';
  static const String RESET_PASSCODE_ENDPOINT = '/api/v1/security/reset';
  static const String SHIFT_SIGNIN_ENDPOINT = '/api/v1/user/check-in';
  static const String SHIFT_SIGNOUT_ENDPOINT = '/api/v1/user/check-out';
  static const String TASK_ENDPOINT = '/api/v1/job';
  static const String APPLY_LEAVE_ENDPOINT = '/api/v1/user/leave';
  static const String RUNNING_LATE_ENDPOINT = '/api/v1/user/runninglate';
}
