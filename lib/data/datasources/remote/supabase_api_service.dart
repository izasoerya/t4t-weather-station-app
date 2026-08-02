import '../models/device_dto.dart';
import '../models/sensor_dto.dart';

/// Read-only contract against the Supabase REST API.
///
/// Declared as an interface so repositories depend on the shape of the API
/// rather than on Dio. Swapping in a Retrofit-generated implementation, a fake
/// for tests, or a Supabase realtime client means writing a new class here and
/// changing one line in `repositories_provider.dart`.
abstract interface class SupabaseApiService {
  /// `GET /devices?select=*&limit={limit}`
  Future<List<DeviceDto>> getDevices({int limit});

  /// `GET /sensors?device_id=eq.{deviceId}&order=created_at.desc&limit={limit}`
  Future<List<SensorDto>> getLatestSensorData(int deviceId, {int limit});

  /// `GET /sensors?device_id=eq.{deviceId}&created_at=gte.{start}&created_at=lte.{end}`
  ///
  /// [startTime] and [endTime] must already be UTC.
  Future<List<SensorDto>> getHistoricalSensorData({
    required int deviceId,
    required DateTime startTime,
    required DateTime endTime,
    int limit,
  });
}
