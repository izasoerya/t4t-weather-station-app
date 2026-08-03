import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../domain/entities/sensor_type.dart';
import '../../providers/device_provider.dart';
import '../../providers/historical_sensor_provider.dart';
import '../atoms/sensor_icon.dart';
import '../molecules/app_surface.dart';
import '../molecules/error_state_view.dart';
import '../molecules/time_range_buttons.dart';
import 'sensor_line_chart.dart';

/// Historical graph with measurement and range controls.
///
/// The chart subtree is always visible so sensor taps can switch the query
/// immediately without a separate expand/collapse control.
class DetailGraphSection extends ConsumerWidget {
  const DetailGraphSection({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.palette;
    final sensorType = ref.watch(selectedSensorTypeProvider);
    final timeRange = ref.watch(graphTimeRangeProvider);
    final deviceId = ref.watch(effectiveDeviceIdProvider);
    final accent = palette.colorFor(sensorType);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: AppSurface(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(context, ref, sensorType, timeRange, accent),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: AppConstants.chartHeight,
                child: _chart(ref, deviceId, sensorType, timeRange),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(
    BuildContext context,
    WidgetRef ref,
    SensorType sensorType,
    TimeRange timeRange,
    Color accent,
  ) {
    final palette = context.palette;

    return Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SensorIcon(type: sensorType, size: 24),
            const SizedBox(width: AppSpacing.sm),
            Text(
              sensorType.label,
              style: AppTextStyles.bodyLarge.copyWith(
                color: palette.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const Spacer(),
        Flexible(
          child: Align(
            alignment: Alignment.centerRight,
            child: TimeRangeButtons(
              selected: timeRange,
              accentColor: accent,
              onChanged: (range) =>
                  ref.read(graphTimeRangeProvider.notifier).state = range,
            ),
          ),
        ),
      ],
    );
  }

  Widget _chart(
    WidgetRef ref,
    int? deviceId,
    SensorType sensorType,
    TimeRange timeRange,
  ) {
    if (deviceId == null) {
      return const EmptyStateView(
        message: 'Select a station to see its history.',
        icon: Icons.sensors_off,
      );
    }

    final query = (deviceId: deviceId, timeRange: timeRange);
    final historyAsync = ref.watch(historicalSensorDataProvider(query));

    return historyAsync.when(
      data: (readings) => SensorLineChart(
        data: readings,
        sensorType: sensorType,
        timeRange: timeRange,
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: ErrorStateView(
          error: error,
          compact: true,
          onRetry: () => ref.invalidate(historicalSensorDataProvider(query)),
        ),
      ),
    );
  }
}
