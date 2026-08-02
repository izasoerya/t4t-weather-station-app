import 'package:flutter/material.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../domain/entities/sensor_type.dart';
import '../atoms/sensor_icon.dart';

/// Picks which measurement the graph plots.
class SensorTypeSelectorRow extends StatelessWidget {
  const SensorTypeSelectorRow({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final SensorType selected;
  final ValueChanged<SensorType> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final type in SensorType.values) ...[
            _Chip(
              type: type,
              selected: type == selected,
              palette: palette,
              onTap: () => onChanged(type),
            ),
            if (type != SensorType.values.last)
              const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.type,
    required this.selected,
    required this.palette,
    required this.onTap,
  });

  final SensorType type;
  final bool selected;
  final AppPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(DesignTokens.radiusMd);
    final accent = palette.colorFor(type);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: selected ? accent.withOpacity(0.16) : Colors.transparent,
            borderRadius: borderRadius,
            border: Border.all(
              color: selected ? accent.withOpacity(0.45) : palette.divider,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SensorIcon(type: type, size: 14),
              const SizedBox(width: 4),
              Text(
                type.shortLabel,
                style: AppTextStyles.labelLarge.copyWith(
                  color: selected ? palette.primaryText : palette.secondaryText,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
