import 'package:flutter/material.dart';

import '../../../core/extensions/num_ext.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/sensor_type.dart';

/// A reading and its unit, colored by measurement type.
///
/// Accepts either a number or a display string, because wind direction reports
/// a cardinal like `NE` where the other four report a double.
class ValueDisplay extends StatelessWidget {
  const ValueDisplay({
    super.key,
    required this.type,
    this.value,
    this.textValue,
    this.showUnit = true,
    this.unitBelow = false,
    this.style,
  });

  /// Numeric reading, or null when unavailable.
  final double? value;

  /// Pre-formatted text that replaces [value], used for cardinal directions.
  final String? textValue;

  final SensorType type;
  final bool showUnit;
  final bool unitBelow;
  final TextStyle? style;

  static const String _placeholder = '--';

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = palette.colorFor(type);
    final hasValue = textValue != null || value != null;
    final display = textValue ??
        (value == null ? _placeholder : value!.toFixed(type.decimals));

    // Cardinal directions carry no unit; a bare "NE" reads better than "NE °".
    final unitVisible = showUnit && hasValue && textValue == null;

    final valueText = Text(
      display,
      overflow: TextOverflow.ellipsis,
      style: (style ?? AppTextStyles.dataMedium).copyWith(
        color: hasValue ? color : palette.disabledText,
      ),
    );

    if (!unitVisible || !unitBelow) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Flexible(child: valueText),
          if (unitVisible) ...[
            const SizedBox(width: 2),
            Text(
              type.unit,
              style: AppTextStyles.bodySmall.copyWith(
                color: palette.secondaryText,
              ),
            ),
          ],
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        valueText,
        const SizedBox(width: 5),
        Text(
          type.unit,
          style: AppTextStyles.bodySmall.copyWith(
            color: palette.secondaryText,
          ),
        ),
      ],
    );
  }
}
