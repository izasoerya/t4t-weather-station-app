import 'package:flutter_test/flutter_test.dart';
import 'package:weather_station_dashboard/data/datasources/models/sensor_dto.dart';
import 'package:weather_station_dashboard/data/mappers/sensor_mapper.dart';
import 'package:weather_station_dashboard/domain/entities/sensor_type.dart';

void main() {
  const json = {
    'id': 12345,
    'device_id': 1,
    'temperature': 28.4,
    'humidity': 65,
    'wind_speed': 12.6,
    'wind_direction': 'NE',
    'rainfall': 1.2,
    'created_at': '2024-01-15T10:30:00+00:00',
  };

  group('SensorDto.fromJson', () {
    test('maps every snake_case column', () {
      final dto = SensorDto.fromJson(Map<String, dynamic>.from(json));

      expect(dto.id, 12345);
      expect(dto.deviceId, 1);
      expect(dto.temperature, 28.4);
      expect(dto.windSpeed, 12.6);
      expect(dto.windDirection, 'NE');
      expect(dto.rainfall, 1.2);
    });

    test('widens whole numbers to double', () {
      final dto = SensorDto.fromJson(Map<String, dynamic>.from(json));
      expect(dto.humidity, isA<double>());
      expect(dto.humidity, 65.0);
    });

    test('parses the timestamp as UTC', () {
      final dto = SensorDto.fromJson(Map<String, dynamic>.from(json));
      expect(dto.createdAt.isUtc, isTrue);
      expect(dto.createdAt.hour, 10);
    });
  });

  group('SensorEntity', () {
    test('exposes a numeric value per sensor type', () {
      final entity = SensorDto.fromJson(Map<String, dynamic>.from(json)).toEntity();

      expect(entity.valueFor(SensorType.temperature), 28.4);
      expect(entity.valueFor(SensorType.humidity), 65.0);
      expect(entity.valueFor(SensorType.rainfall), 1.2);
      expect(entity.valueFor(SensorType.windSpeed), 12.6);
    });

    test('converts a cardinal direction to a bearing for the chart', () {
      final entity = SensorDto.fromJson(Map<String, dynamic>.from(json)).toEntity();
      expect(entity.valueFor(SensorType.windDirection), 45.0);
      expect(entity.copyWith(windDirection: 'WSW').windDirectionDegrees, 247.5);
      expect(entity.copyWith(windDirection: 'zz').windDirectionDegrees, 0);
    });
  });
}
