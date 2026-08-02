import 'package:flutter/material.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/design_tokens.dart';
import '../../providers/historical_sensor_provider.dart';

/// Chip row for picking the graph window.
class TimeRangeButtons extends StatelessWidget {
  const TimeRangeButtons({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.accentColor,
    this.ranges = TimeRange.values,
  });

  final TimeRange selected;
  final ValueChanged<TimeRange> onChanged;
  final Color accentColor;
  final List<TimeRange> ranges;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final range in ranges) ...[
            _Chip(
              label: range.label,
              isActive: range == selected,
              accentColor: accentColor,
              palette: palette,
              onTap: () => onChanged(range),
            ),
            if (range != ranges.last) const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.isActive,
    required this.accentColor,
    required this.palette,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final Color accentColor;
  final AppPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(DesignTokens.radiusMd);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 28,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? accentColor : Colors.transparent,
            borderRadius: borderRadius,
            border: Border.all(color: isActive ? accentColor : palette.divider),
          ),
          child: Text(
            label,
            style: AppTextStyles.labelLarge.copyWith(
              color: isActive ? Colors.white : palette.secondaryText,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
