import '../entities/sensor_entity.dart';

/// Contract for reading sensor measurements. Implemented in the data layer.
abstract interface class SensorRepository {
  /// Newest reading for [deviceId], as a single-element list (empty when the
  /// station has never reported).
  Future<List<SensorEntity>> getLatestSensorData(int deviceId);

  /// Readings between [startTime] and [endTime], already downsampled to
  /// [sampleSize] points and sorted oldest-first for charting.
  Future<List<SensorEntity>> getHistoricalSensorData({
    required int deviceId,
    required DateTime startTime,
    required DateTime endTime,
    int sampleSize,
  });
}
