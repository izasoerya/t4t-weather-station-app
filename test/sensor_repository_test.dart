import 'package:flutter_test/flutter_test.dart';
import 'package:weather_station_dashboard/data/datasources/models/device_dto.dart';
import 'package:weather_station_dashboard/data/datasources/models/sensor_dto.dart';
import 'package:weather_station_dashboard/data/datasources/remote/supabase_api_service.dart';
import 'package:weather_station_dashboard/data/repositories/sensor_repository_impl.dart';

/// Hand-written stand-in for the API, so no mocking package is needed.
class _FakeApi implements SupabaseApiService {
  _FakeApi(this.rows);

  final List<SensorDto> rows;

  @override
  Future<List<DeviceDto>> getDevices({int limit = 100}) async => const [];

  @override
  Future<List<SensorDto>> getLatestSensorData(int deviceId, {int limit = 1}) async =>
      rows.take(limit).toList();

  @override
  Future<List<SensorDto>> getHistoricalSensorData({
    required int deviceId,
    required DateTime startTime,
    required DateTime endTime,
    int limit = 1000,
  }) async =>
      rows;
}

SensorDto _row(int i) => SensorDto(
      id: i,
      deviceId: 1,
      temperature: 20 + i.toDouble(),
      humidity: 60,
      windSpeed: 10,
      windDirection: 'NE',
      rainfall: 0,
      createdAt: DateTime.utc(2024, 1, 15).add(Duration(minutes: i)),
    );

void main() {
  group('SensorRepositoryImpl.getHistoricalSensorData', () {
    test('downsamples to the requested point count', () async {
      final repo = SensorRepositoryImpl(
        _FakeApi(List.generate(720, _row).reversed.toList()),
      );

      final result = await repo.getHistoricalSensorData(
        deviceId: 1,
        startTime: DateTime.utc(2024, 1, 15),
        endTime: DateTime.utc(2024, 1, 16),
      );

      expect(result, hasLength(30));
    });

    test('returns points oldest first so the chart reads left to right', () async {
      final repo = SensorRepositoryImpl(
        _FakeApi(List.generate(100, _row).reversed.toList()),
      );

      final result = await repo.getHistoricalSensorData(
        deviceId: 1,
        startTime: DateTime.utc(2024, 1, 15),
        endTime: DateTime.utc(2024, 1, 16),
      );

      expect(result.first.createdAt.isBefore(result.last.createdAt), isTrue);
    });
  });
}
