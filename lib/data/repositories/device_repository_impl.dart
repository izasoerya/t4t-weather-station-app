import '../../core/utils/error_handler.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/device_entity.dart';
import '../../domain/exceptions/app_exceptions.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/remote/supabase_api_service.dart';
import '../mappers/device_mapper.dart';

/// Reads devices from Supabase and hands back domain entities.
class DeviceRepositoryImpl implements DeviceRepository {
  const DeviceRepositoryImpl(this._api);

  final SupabaseApiService _api;

  @override
  Future<List<DeviceEntity>> getDevices() async {
    try {
      return await logger.timed('getDevices', () async {
        final dtos = await _api.getDevices();
        logger.info('Fetched ${dtos.length} devices');
        return dtos.toEntities();
      });
    } catch (e, s) {
      throw ErrorHandler.mapError(e, s);
    }
  }

  @override
  Future<DeviceEntity?> getDeviceById(int id) async {
    final devices = await getDevices();
    for (final device in devices) {
      if (device.id == id) return device;
    }
    logger.warning('Device $id not present in device list');
    throw DeviceNotFoundException(id);
  }
}
