import 'package:flutter/material.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../domain/entities/sensor_type.dart';
import 'sensor_icon.dart';

/// Field name shown above or beside a value, with an optional leading icon.
class DataLabel extends StatelessWidget {
  const DataLabel({
    super.key,
    required this.label,
    this.type,
    this.showIcon = false,
    this.iconSize = 16,
    this.style,
    this.textAlign,
  });

  final String label;
  final SensorType? type;
  final bool showIcon;
  final double iconSize;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      style: style ??
          AppTextStyles.labelLarge.copyWith(color: context.palette.secondaryText),
    );

    if (!showIcon || type == null) return text;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SensorIcon(type: type!, size: iconSize),
        const SizedBox(width: AppSpacing.sm),
        Flexible(child: text),
      ],
    );
  }
}
