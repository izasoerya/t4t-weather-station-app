import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/duration_constants.dart';
import '../../domain/entities/sensor_entity.dart';
import '../../domain/entities/sensor_type.dart';
import '../../domain/usecases/get_historical_sensor_data_usecase.dart';
import 'usecase_provider.dart';

/// Time windows offered by the graph's range buttons.
enum TimeRange {
  period12h,
  period1d,
  period1w,
  period1m;

  /// Short label shown on the chip.
  String get label => switch (this) {
        TimeRange.period12h => '12h',
        TimeRange.period1d => '1d',
        TimeRange.period1w => '1w',
        TimeRange.period1m => '1m',
      };

  Duration get duration => switch (this) {
        TimeRange.period12h => DurationConstants.graphShort,
        TimeRange.period1d => DurationConstants.graphMedium,
        TimeRange.period1w => DurationConstants.graphLong,
        TimeRange.period1m => DurationConstants.graphExtended,
      };

  /// Longer windows need a date on the x-axis; short ones only need the clock.
  bool get needsDateAxis =>
      this == TimeRange.period1w || this == TimeRange.period1m;
}

/// Range currently selected in the graph section.
final graphTimeRangeProvider =
    StateProvider<TimeRange>((ref) => TimeRange.period12h);

/// Measurement currently plotted.
final selectedSensorTypeProvider =
    StateProvider<SensorType>((ref) => SensorType.temperature);

/// Query key for [historicalSensorDataProvider].
typedef HistoryQuery = ({int deviceId, TimeRange timeRange});

/// Historical readings for one station over one window.
///
/// Keyed by station and range so switching between 12H and 1W keeps both
/// results cached instead of refetching, and `autoDispose` drops them once the
/// graph collapses. Data arrives already downsampled to 30 chronological
/// points.
final historicalSensorDataProvider = FutureProvider.autoDispose
    .family<List<SensorEntity>, HistoryQuery>((ref, query) async {
  // Cached briefly so a quick collapse-and-reopen does not refetch.
  final link = ref.keepAlive();
  final timer = Timer(const Duration(minutes: 2), link.close);
  ref.onDispose(timer.cancel);

  final useCase = ref.watch(getHistoricalSensorDataUseCaseProvider);
  final now = DateTime.now().toUtc();

  return useCase.execute(
    GetHistoricalSensorDataParams(
      deviceId: query.deviceId,
      startTime: now.subtract(query.timeRange.duration),
      endTime: now,
      sampleSize: AppConstants.graphSampleSize,
    ),
  );
});
