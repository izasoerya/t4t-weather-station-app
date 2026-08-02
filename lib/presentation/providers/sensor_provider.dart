import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/duration_constants.dart';
import '../../core/utils/error_handler.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/sensor_entity.dart';
import '../../domain/usecases/get_sensor_data_usecase.dart';
import 'device_provider.dart';
import 'usecase_provider.dart';

/// Latest readings for the active station, refreshed every 5 seconds.
final sensorDataProvider =
    AsyncNotifierProvider<SensorDataNotifier, List<SensorEntity>>(
  SensorDataNotifier.new,
);

/// Polls the newest sensor row on a fixed interval.
///
/// [build] watches [effectiveDeviceIdProvider], so switching stations tears the
/// notifier down and rebuilds it: the old timer is cancelled by the `onDispose`
/// hook before the new one starts, which is what stops two loops from running
/// at once. A failed poll updates the error state but leaves the timer running,
/// so the dashboard recovers on its own when the network comes back.
class SensorDataNotifier extends AsyncNotifier<List<SensorEntity>> {
  Timer? _timer;
  bool _isDisposed = false;

  @override
  Future<List<SensorEntity>> build() async {
    final deviceId = ref.watch(effectiveDeviceIdProvider);

    _isDisposed = false;
    ref.onDispose(() {
      _isDisposed = true;
      _timer?.cancel();
      _timer = null;
      logger.debug('Polling stopped for device $deviceId');
    });

    if (deviceId == null) return const [];

    _timer?.cancel();
    _timer = Timer.periodic(
      DurationConstants.pollInterval,
      (_) => _poll(deviceId),
    );
    logger.info(
      'Polling device $deviceId every '
      '${DurationConstants.pollInterval.inSeconds}s',
    );

    return _fetch(deviceId);
  }

  /// Forces an immediate refresh, used by the retry button.
  Future<void> refresh() async {
    final deviceId = ref.read(effectiveDeviceIdProvider);
    if (deviceId == null) return;
    state = const AsyncValue.loading();
    await _poll(deviceId);
  }

  Future<void> _poll(int deviceId) async {
    if (_isDisposed) return;
    try {
      final data = await _fetch(deviceId);
      if (_isDisposed) return;
      state = AsyncValue.data(data);
    } catch (e, s) {
      if (_isDisposed) return;
      logger.warning('Poll failed for device $deviceId', e);
      state = AsyncValue.error(ErrorHandler.mapError(e, s), s);
    }
  }

  Future<List<SensorEntity>> _fetch(int deviceId) {
    final useCase = ref.read(getSensorDataUseCaseProvider);
    return useCase.execute(GetSensorDataParams(deviceId: deviceId));
  }
}

/// Newest single reading, or null while loading, on error, or when the station
/// has never reported.
final latestSensorProvider = Provider<SensorEntity?>((ref) {
  return ref.watch(sensorDataProvider).maybeWhen(
        data: (readings) => readings.isEmpty ? null : readings.first,
        orElse: () => null,
      );
});

/// Timestamp shown as "Last updated" in the header.
final lastUpdatedProvider = Provider<DateTime?>(
  (ref) => ref.watch(latestSensorProvider)?.createdAt,
);

/// Whether the station counts as online.
///
/// A station is online when the last poll succeeded and its newest reading is
/// recent. Without the freshness check a station that stopped transmitting
/// hours ago would still read as online, because the API keeps returning its
/// stale row.
final isDeviceOnlineProvider = Provider<bool>((ref) {
  final async = ref.watch(sensorDataProvider);
  if (async.hasError) return false;

  final latest = ref.watch(latestSensorProvider);
  if (latest == null) return false;

  final age = DateTime.now().toUtc().difference(latest.createdAt.toUtc());
  return age <= AppConstants.onlineThreshold;
});
