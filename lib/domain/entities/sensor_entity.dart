import 'package:equatable/equatable.dart';

import 'sensor_type.dart';

/// One sensor reading from one station at one instant.
///
/// [createdAt] stays in UTC exactly as Supabase returned it. Conversion to the
/// UTC+7 display timezone happens in the presentation layer.
class SensorEntity extends Equatable {
  const SensorEntity({
    required this.id,
    required this.deviceId,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.rainfall,
    required this.createdAt,
  });

  final int id;
  final int deviceId;

  /// Degrees Celsius.
  final double temperature;

  /// Relative humidity, 0-100.
  final double humidity;

  /// Kilometres per hour.
  final double windSpeed;

  /// Cardinal direction such as `N`, `NE`, `ESE`.
  final String windDirection;

  /// Millimetres.
  final double rainfall;

  /// UTC timestamp from the backend.
  final DateTime createdAt;

  /// Numeric value for [type], used by the chart and by generic widgets.
  ///
  /// Wind direction has no numeric column, so its cardinal string is converted
  /// to a compass bearing to make it plottable.
  double valueFor(SensorType type) => switch (type) {
        SensorType.temperature => temperature,
        SensorType.humidity => humidity,
        SensorType.rainfall => rainfall,
        SensorType.windSpeed => windSpeed,
        SensorType.windDirection => windDirectionDegrees,
      };

  /// Compass bearing for [windDirection], 0-337.5, or 0 when unrecognised.
  double get windDirectionDegrees =>
      _cardinalToDegrees[windDirection.trim().toUpperCase()] ?? 0;

  static const Map<String, double> _cardinalToDegrees = {
    'N': 0,
    'NNE': 22.5,
    'NE': 45,
    'ENE': 67.5,
    'E': 90,
    'ESE': 112.5,
    'SE': 135,
    'SSE': 157.5,
    'S': 180,
    'SSW': 202.5,
    'SW': 225,
    'WSW': 247.5,
    'W': 270,
    'WNW': 292.5,
    'NW': 315,
    'NNW': 337.5,
  };

  static String cardinalLongerText(String cardinal) {
    return switch (cardinal.trim().toUpperCase()) {
      'N' => 'North',
      'NNE' => 'North North East',
      'NE' => 'North East',
      'ENE' => 'East North East',
      'E' => 'East',
      'ESE' => 'East South East',
      'SE' => 'South East',
      'SSE' => 'South South East',
      'S' => 'South',
      'SSW' => 'South South West',
      'SW' => 'South West',
      'WSW' => 'West South West',
      'W' => 'West',
      'WNW' => 'West North West',
      'NW' => 'North West',
      'NNW' => 'North North West',
      _ => cardinal.trim().toUpperCase(),
    };
  }

  SensorEntity copyWith({
    int? id,
    int? deviceId,
    double? temperature,
    double? humidity,
    double? windSpeed,
    String? windDirection,
    double? rainfall,
    DateTime? createdAt,
  }) {
    return SensorEntity(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      windSpeed: windSpeed ?? this.windSpeed,
      windDirection: windDirection ?? this.windDirection,
      rainfall: rainfall ?? this.rainfall,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        deviceId,
        temperature,
        humidity,
        windSpeed,
        windDirection,
        rainfall,
        createdAt,
      ];

  @override
  bool get stringify => true;
}
