import 'package:equatable/equatable.dart';

import '../entities/sensor_entity.dart';
import '../repositories/sensor_repository.dart';

/// Input for [GetSensorDataUseCase].
class GetSensorDataParams extends Equatable {
  const GetSensorDataParams({required this.deviceId});

  final int deviceId;

  @override
  List<Object?> get props => [deviceId];
}

/// Fetches the newest reading for one station. Called every 5 seconds by the
/// polling provider.
class GetSensorDataUseCase {
  const GetSensorDataUseCase(this._repository);

  final SensorRepository _repository;

  Future<List<SensorEntity>> execute(GetSensorDataParams params) =>
      _repository.getLatestSensorData(params.deviceId);
}
