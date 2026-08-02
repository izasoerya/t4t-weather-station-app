/// Every timing value used by the app, in one place.
class DurationConstants {
  const DurationConstants._();

  /// How often the dashboard re-queries the latest sensor reading.
  static const Duration pollInterval = Duration(seconds: 5);

  // Graph time ranges.
  static const Duration graphShort = Duration(hours: 12);
  static const Duration graphMedium = Duration(days: 1);
  static const Duration graphLong = Duration(days: 7);
  static const Duration graphExtended = Duration(days: 30);

  // Animation timings, from design.md.
  static const Duration animationFast = Duration(milliseconds: 100);
  static const Duration animationNormal = Duration(milliseconds: 200);
  static const Duration animationSlow = Duration(milliseconds: 300);
  static const Duration animationHover = Duration(milliseconds: 150);
}
