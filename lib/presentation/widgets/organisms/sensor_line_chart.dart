import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/extensions/date_time_ext.dart';
import '../../../core/extensions/num_ext.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../domain/entities/sensor_entity.dart';
import '../../../domain/entities/sensor_type.dart';
import '../../providers/historical_sensor_provider.dart';
import '../molecules/error_state_view.dart';

/// Line chart of up to 30 sampled readings.
///
/// Readings are plotted against their list index rather than their epoch
/// millisecond value: the points are already evenly sampled, and small integer
/// x-values keep the axis interval math readable and the labels aligned.
class SensorLineChart extends StatelessWidget {
  const SensorLineChart({
    super.key,
    required this.data,
    required this.sensorType,
    required this.timeRange,
  });

  final List<SensorEntity> data;
  final SensorType sensorType;
  final TimeRange timeRange;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const EmptyStateView(
        message: 'No data available for this time range.',
        icon: Icons.show_chart,
      );
    }

    final palette = context.palette;
    final accent = palette.colorFor(sensorType);
    final values = data.map((e) => e.valueFor(sensorType)).toList();
    final bounds = _YBounds.from(values);
    final spots = <FlSpot>[
      for (var i = 0; i < values.length; i++) FlSpot(i.toDouble(), values[i]),
    ];

    // Roughly five labels across the axis, whatever the point count.
    final xInterval = (data.length / 5).ceilToDouble().clamp(1, 30).toDouble();

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md, right: AppSpacing.sm),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (data.length - 1).toDouble(),
          minY: bounds.min,
          maxY: bounds.max,
          clipData: FlClipData.all(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: bounds.interval,
            getDrawingHorizontalLine: (_) => FlLine(
              color: palette.divider.withOpacity(DesignTokens.opacityGridLine),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                interval: bounds.interval,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 6,
                  child: Text(
                    value.toFixed(sensorType.decimals == 0 ? 0 : 1),
                    style: AppTextStyles.labelSmall
                        .copyWith(color: palette.mutedText),
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: xInterval,
                getTitlesWidget: (value, meta) {
                  final index = value.round();
                  if (index < 0 || index >= data.length) {
                    return const SizedBox.shrink();
                  }
                  final timestamp = data[index].createdAt;
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 6,
                    child: Text(
                      timeRange.needsDateAxis
                          ? timestamp.toShortDate()
                          : timestamp.toFormattedString(),
                      style: AppTextStyles.labelSmall
                          .copyWith(color: palette.mutedText),
                    ),
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: palette.cardBg,
              tooltipRoundedRadius: DesignTokens.radiusMd,
              getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                final reading = data[spot.x.round().clamp(0, data.length - 1)];
                return LineTooltipItem(
                  '${spot.y.toFixed(sensorType.decimals)} ${sensorType.unit}\n',
                  AppTextStyles.dataSmall.copyWith(color: accent),
                  children: [
                    TextSpan(
                      text: reading.createdAt.toDateTimeString(),
                      style: AppTextStyles.labelSmall
                          .copyWith(color: palette.mutedText),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.25,
              preventCurveOverShooting: true,
              color: accent,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, bar, index) =>
                    FlDotCirclePainter(
                  radius: 3,
                  color: accent,
                  strokeWidth: 0,
                  strokeColor: Colors.transparent,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    accent.withOpacity(DesignTokens.opacityChartFill),
                    accent.withOpacity(0.02),
                  ],
                ),
              ),
            ),
          ],
        ),
        // swapAnimationDuration: const Duration(milliseconds: 300),
        // swapAnimationCurve: Curves.easeOut,
      ),
    );
  }
}

/// Y-axis range with padding and a tick interval.
class _YBounds {
  const _YBounds(this.min, this.max, this.interval);

  final double min;
  final double max;
  final double interval;

  /// Pads the range by 10% so the line never touches the top or bottom edge.
  /// A flat series (every reading identical) would otherwise collapse to a zero
  /// height axis, so it falls back to a fixed one-unit band.
  factory _YBounds.from(List<double> values) {
    var lowest = values.first;
    var highest = values.first;
    for (final value in values) {
      if (value < lowest) lowest = value;
      if (value > highest) highest = value;
    }

    if ((highest - lowest).abs() < 0.001) {
      lowest -= 1;
      highest += 1;
    } else {
      final padding = (highest - lowest) * 0.1;
      lowest -= padding;
      highest += padding;
    }

    final interval = (highest - lowest) / 4;
    return _YBounds(lowest, highest, interval <= 0 ? 1 : interval);
  }
}
