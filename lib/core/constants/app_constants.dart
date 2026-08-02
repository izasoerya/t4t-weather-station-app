/// App-wide values that are not timings and not API concerns.
class AppConstants {
  const AppConstants._();

  static const String appName = 'Weather Station Dashboard';
  static const String headerTitle = 'WS-PERSEMAIAN';

  /// Display timezone offset. Supabase stores UTC; the dashboard shows UTC+7.
  static const Duration displayTimezoneOffset = Duration(hours: 7);
  static const String displayTimezoneLabel = 'UTC+7';

  /// Number of points every historical graph is downsampled to.
  static const int graphSampleSize = 30;

  /// A device counts as offline once its newest reading is older than this.
  static const Duration onlineThreshold = Duration(minutes: 15);

  /// Responsive breakpoints, in logical pixels.
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;

  /// Fixed sensor card height, keeps grid rows aligned.
  static const double sensorCardHeight = 110;

  /// Height of the chart plotting area.
  static const double chartHeight = 300;
}
