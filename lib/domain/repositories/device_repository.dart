import '../entities/device_entity.dart';

/// Contract for reading weather stations. Implemented in the data layer.
abstract interface class DeviceRepository {
  /// Every registered station, ordered by id.
  ///
  /// Throws [AppException] subtypes on failure.
  Future<List<DeviceEntity>> getDevices();

  /// A single station.
  ///
  /// Throws `DeviceNotFoundException` when no station carries that id.
  Future<DeviceEntity?> getDeviceById(int id);
}
