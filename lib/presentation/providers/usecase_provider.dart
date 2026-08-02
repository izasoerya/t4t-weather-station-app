import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_devices_usecase.dart';
import '../../domain/usecases/get_historical_sensor_data_usecase.dart';
import '../../domain/usecases/get_sensor_data_usecase.dart';
import 'repositories_provider.dart';

final getDevicesUseCaseProvider = Provider<GetDevicesUseCase>(
  (ref) => GetDevicesUseCase(ref.watch(deviceRepositoryProvider)),
);

final getSensorDataUseCaseProvider = Provider<GetSensorDataUseCase>(
  (ref) => GetSensorDataUseCase(ref.watch(sensorRepositoryProvider)),
);

final getHistoricalSensorDataUseCaseProvider =
    Provider<GetHistoricalSensorDataUseCase>(
  (ref) => GetHistoricalSensorDataUseCase(ref.watch(sensorRepositoryProvider)),
);
