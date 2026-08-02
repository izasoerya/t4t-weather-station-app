import '../../core/constants/app_constants.dart';
import '../../core/utils/data_sampler.dart';
import '../../core/utils/error_handler.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/sensor_entity.dart';
import '../../domain/repositories/sensor_repository.dart';
import '../datasources/remote/supabase_api_service.dart';
import '../mappers/sensor_mapper.dart';

/// Reads sensor measurements from Supabase.
///
/// Two transformations happen here rather than in the UI: the newest-first
/// order the API returns is flipped to chronological order for the chart, and
/// the result is downsampled so a month-long query cannot push a thousand
/// points into a 300px-tall widget.
class SensorRepositoryImpl implements SensorRepository {
  const SensorRepositoryImpl(this._api);

  final SupabaseApiService _api;

  @override
  Future<List<SensorEntity>> getLatestSensorData(int deviceId) async {
    try {
      return await logger.timed('getLatestSensorData($deviceId)', () async {
        final dtos = await _api.getLatestSensorData(deviceId);
        final entities = dtos.toEntities()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        if (entities.isEmpty) {
          logger.warning('No readings returned for device $deviceId');
        }
        return entities;
      });
    } catch (e, s) {
      throw ErrorHandler.mapError(e, s);
    }
  }

  @override
  Future<List<SensorEntity>> getHistoricalSensorData({
    required int deviceId,
    required DateTime startTime,
    required DateTime endTime,
    int sampleSize = AppConstants.graphSampleSize,
  }) async {
    try {
      return await logger.timed(
        'getHistoricalSensorData($deviceId, ${endTime.difference(startTime)})',
        () async {
          final dtos = await _api.getHistoricalSensorData(
            deviceId: deviceId,
            startTime: startTime,
            endTime: endTime,
          );

          final entities = dtos.toEntities()
            ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

          final sampled = DataSampler.uniformSample(entities, sampleSize);
          logger.info(
            'History for device $deviceId: ${entities.length} rows '
            'sampled to ${sampled.length} points',
          );
          return sampled;
        },
      );
    } catch (e, s) {
      throw ErrorHandler.mapError(e, s);
    }
  }
}
