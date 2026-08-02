import '../entities/device_entity.dart';
import '../repositories/device_repository.dart';

/// Fetches every weather station.
///
/// Errors are left to bubble; the provider layer turns them into
/// `AsyncValue.error` and the widget renders the user-facing message.
class GetDevicesUseCase {
  const GetDevicesUseCase(this._repository);

  final DeviceRepository _repository;

  Future<List<DeviceEntity>> execute() => _repository.getDevices();
}
