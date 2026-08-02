import '../../domain/entities/sensor_entity.dart';
import '../datasources/models/sensor_dto.dart';

/// DTO to entity translation for sensor readings.
extension SensorMapper on SensorDto {
  SensorEntity toEntity() => SensorEntity(
        id: id,
        deviceId: deviceId,
        temperature: temperature,
        humidity: humidity,
        windSpeed: windSpeed,
        windDirection: windDirection,
        rainfall: rainfall,
        createdAt: createdAt,
      );
}

extension SensorListMapper on List<SensorDto> {
  List<SensorEntity> toEntities() => map((dto) => dto.toEntity()).toList();
}
