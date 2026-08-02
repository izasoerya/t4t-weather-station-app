import 'package:intl/intl.dart';

/// Numeric formatting for sensor readings.
extension NumExt on num {
  /// Fixed-decimal string that drops a trailing `.0` when [decimals] is 0.
  String toFixed(int decimals) => NumberFormat(
        decimals == 0 ? '0' : '0.${'0' * decimals}',
      ).format(this);

  /// `65%`
  String toPercentage({int decimals = 0}) => '${toFixed(decimals)}%';

  /// `28.4°C`
  String toCelsius({int decimals = 1}) => '${toFixed(decimals)}\u00B0C';

  /// `12.6 km/h`
  String toKmh({int decimals = 1}) => '${toFixed(decimals)} km/h';

  /// `1.2 mm`
  String toMm({int decimals = 1}) => '${toFixed(decimals)} mm';

  /// `45°`
  String toDegrees({int decimals = 0}) => '${toFixed(decimals)}\u00B0';
}

/// Same formatters for values that may be absent.
extension NullableNumExt on num? {
  static const String placeholder = '--';

  String toFixedOrDash(int decimals) =>
      this == null ? placeholder : this!.toFixed(decimals);
}
