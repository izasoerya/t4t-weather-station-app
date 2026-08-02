import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../domain/entities/sensor_type.dart';
import '../atoms/data_label.dart';
import '../atoms/sensor_icon.dart';
import '../atoms/value_display.dart';
import 'app_surface.dart';

/// One measurement, centered: icon, label, value.
///
/// Tapping a card opens the graph for that measurement, so the whole surface is
/// the touch target rather than just the icon.
class SensorCard extends StatelessWidget {
  const SensorCard({
    super.key,
    required this.type,
    this.value,
    this.textValue,
    this.onTap,
    this.isSelected = false,
  });

  final SensorType type;
  final double? value;
  final String? textValue;
  final VoidCallback? onTap;

  /// Highlights the card whose measurement the graph is showing.
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final accent = palette.colorFor(type);

    return SizedBox(
      height: AppConstants.sensorCardHeight,
      child: AppSurface(
        onTap: onTap,
        elevated: false,
        radius: 2.5,
        padding: const EdgeInsetsGeometry.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.sm,
        ),
        borderColor: isSelected
            ? accent.withOpacity(0.22)
            : palette.divider.withOpacity(0.40),
        color: isSelected
            ? Color.alphaBlend(accent.withOpacity(0.04), palette.cardBg)
            : palette.cardBg,
        child: _TileContent(type: type, value: value, textValue: textValue),
      ),
    );
  }
}

class _TileContent extends StatelessWidget {
  const _TileContent({
    required this.type,
    required this.value,
    required this.textValue,
  });

  final SensorType type;
  final double? value;
  final String? textValue;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 25,
              child: Center(
                child: SensorIcon(type: type, size: 25),
              ),
            ),
            DataLabel(
              label: type.label,
              textAlign: TextAlign.start,
              style: AppTextStyles.bodySmall.copyWith(
                color: palette.secondaryText,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: ValueDisplay(
            type: type,
            value: value,
            textValue: textValue,
            style: AppTextStyles.dataLarge,
            unitBelow: true,
          ),
        ),
      ],
    );
  }
}

/// Placeholder shown while the first poll is in flight.
class SensorCardSkeleton extends StatefulWidget {
  const SensorCardSkeleton({super.key});

  @override
  State<SensorCardSkeleton> createState() => _SensorCardSkeletonState();
}

class _SensorCardSkeletonState extends State<SensorCardSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return SizedBox(
      height: AppConstants.sensorCardHeight,
      child: AppSurface(
        radius: 14,
        padding: const EdgeInsets.all(12),
        boxShadow: const [],
        borderColor: palette.divider.withOpacity(0.72),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0.35, end: 0.75).animate(_controller),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: _bar(palette.divider, 72, 10, DesignTokens.radiusSm),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _bar(palette.divider, 24, 24, DesignTokens.radiusSm),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _bar(palette.divider, 56, 16, DesignTokens.radiusSm),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bar(Color color, double width, double height, double radius) =>
      Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
}
