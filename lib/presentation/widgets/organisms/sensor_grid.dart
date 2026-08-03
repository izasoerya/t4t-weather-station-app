import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/design_tokens.dart';
import '../../../domain/entities/sensor_entity.dart';
import '../../../domain/entities/sensor_type.dart';
import '../../providers/sensor_provider.dart';
import '../molecules/error_state_view.dart';
import '../molecules/sensor_card.dart';

/// Responsive grid of the five sensor cards.
///
/// The dashboard groups the first three sensors on the top row and the two wind
/// sensors on the second row so the lower cards can span the wider two-up row.
class SensorGrid extends ConsumerWidget {
  const SensorGrid({super.key, required this.onSensorTap, this.selectedType});

  final ValueChanged<SensorType> onSensorTap;
  final SensorType? selectedType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sensorAsync = ref.watch(sensorDataProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return sensorAsync.when(
            data: (readings) => _grid(
              child: (type) => SensorCard(
                type: type,
                value: _valueFor(_latest(readings), type),
                textValue: _textFor(_latest(readings), type),
                isSelected: selectedType == type,
                onTap: () => onSensorTap(type),
              ),
              width: constraints.maxWidth,
            ),
            loading: () => _grid(
              child: (_) => const SensorCardSkeleton(),
              width: constraints.maxWidth,
            ),
            error: (error, _) => ErrorStateView(
              error: error,
              onRetry: () => ref.read(sensorDataProvider.notifier).refresh(),
            ),
          );
        },
      ),
    );
  }

  /// Newest reading, or null when the station has never reported.
  SensorEntity? _latest(List<SensorEntity> readings) =>
      readings.isEmpty ? null : readings.first;

  Widget _grid({
    required Widget Function(SensorType type) child,
    required double width,
  }) {
    if (width < 360) {
      return Column(
        children: [
          for (final type in SensorType.values)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: SizedBox(width: double.infinity, child: child(type)),
            ),
        ],
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: child(SensorType.temperature)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: child(SensorType.humidity)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: child(SensorType.rainfall)),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(child: child(SensorType.windSpeed)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: child(SensorType.windDirection)),
          ],
        ),
      ],
    );
  }

  /// Cardinal directions render as text, so their numeric slot stays empty.
  double? _valueFor(SensorEntity? reading, SensorType type) {
    if (reading == null || type.isCardinal) return null;
    return reading.valueFor(type);
  }

  String? _textFor(SensorEntity? reading, SensorType type) {
    if (reading == null || !type.isCardinal) return null;
    final direction = reading.windDirection.trim();
    return direction.isEmpty
        ? '--'
        : SensorEntity.cardinalLongerText(direction);
  }
}
