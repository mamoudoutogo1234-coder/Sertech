class RouteNames {
  RouteNames._();

  static const String dashboard = 'dashboard';
  static const String zones = 'zones';
  static const String zoneDetail = 'zone-detail';
  static const String measurements = 'measurements';
  static const String irrigation = 'irrigation';
  static const String camera = 'camera';
  static const String activity = 'activity';
  static const String commandDetail = 'command-detail';
  static const String notifications = 'notifications';
  static const String settings = 'settings';
  static const String irrigationTiming = 'irrigation-timing';
  static const String onboarding = 'onboarding';
  static const String login = 'login';
  static const String register = 'register';
}

class RoutePaths {
  RoutePaths._();

  static const String dashboard = '/';
  static const String zones = '/zones';
  static const String measurements = '/measurements';
  static const String irrigation = '/irrigation';
  static const String camera = '/camera';
  static const String activity = '/activity';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String irrigationTiming = '/irrigation/timing';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';

  static String zoneDetail(String id) => '/zones/$id';
  static String commandDetail(String id) => '/activity/$id';
}
