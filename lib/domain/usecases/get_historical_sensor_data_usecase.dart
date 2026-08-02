import 'package:equatable/equatable.dart';

import '../../core/constants/app_constants.dart';
import '../entities/sensor_entity.dart';
import '../exceptions/app_exceptions.dart';
import '../repositories/sensor_repository.dart';

/// Input for [GetHistoricalSensorDataUseCase].
class GetHistoricalSensorDataParams extends Equatable {
  const GetHistoricalSensorDataParams({
    required this.deviceId,
    required this.startTime,
    required this.endTime,
    this.sampleSize = AppConstants.graphSampleSize,
  });

  final int deviceId;
  final DateTime startTime;
  final DateTime endTime;
  final int sampleSize;

  @override
  List<Object?> get props => [deviceId, startTime, endTime, sampleSize];
}

/// Fetches a time window of readings for the graph.
///
/// Validates the window before hitting the network, then returns data the
/// repository has already downsampled to [GetHistoricalSensorDataParams.sampleSize]
/// points in chronological order.
class GetHistoricalSensorDataUseCase {
  const GetHistoricalSensorDataUseCase(this._repository);

  final SensorRepository _repository;

  Future<List<SensorEntity>> execute(
    GetHistoricalSensorDataParams params,
  ) async {
    if (!params.startTime.isBefore(params.endTime)) {
      throw const SensorDataException(
        'Invalid time range: startTime must be before endTime',
      );
    }
    if (params.sampleSize < 2) {
      throw const SensorDataException('sampleSize must be at least 2');
    }

    return _repository.getHistoricalSensorData(
      deviceId: params.deviceId,
      startTime: params.startTime,
      endTime: params.endTime,
      sampleSize: params.sampleSize,
    );
  }
}
