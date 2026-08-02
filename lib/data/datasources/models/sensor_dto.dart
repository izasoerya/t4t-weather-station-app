import 'package:equatable/equatable.dart';

/// Wire format for a row of the `sensors` table.
///
/// Supabase returns `REAL` columns as JSON numbers that may deserialize as
/// `int` when the stored value has no fractional part, so every numeric field
/// goes through `num.toDouble()` rather than a direct cast.
class SensorDto extends Equatable {
  const SensorDto({
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
  final double temperature;
  final double humidity;
  final double windSpeed;
  final String windDirection;
  final double rainfall;
  final DateTime createdAt;

  factory SensorDto.fromJson(Map<String, dynamic> json) => SensorDto(
        id: (json['id'] as num).toInt(),
        deviceId: (json['device_id'] as num).toInt(),
        temperature: _toDouble(json['temperature']),
        humidity: _toDouble(json['humidity']),
        windSpeed: _toDouble(json['wind_speed']),
        windDirection: (json['wind_direction'] as String?) ?? '',
        rainfall: _toDouble(json['rainfall']),
        createdAt: _toDateTime(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'device_id': deviceId,
        'temperature': temperature,
        'humidity': humidity,
        'wind_speed': windSpeed,
        'wind_direction': windDirection,
        'rainfall': rainfall,
        'created_at': createdAt.toUtc().toIso8601String(),
      };

  static double _toDouble(Object? value) => switch (value) {
        final num n => n.toDouble(),
        final String s => double.tryParse(s) ?? 0,
        _ => 0,
      };

  /// Parses `2024-01-15T10:30:00+00:00` and normalises to UTC.
  static DateTime _toDateTime(Object? value) {
    if (value is DateTime) return value.toUtc();
    final parsed = DateTime.tryParse(value?.toString() ?? '');
    return (parsed ?? DateTime.now()).toUtc();
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
