import 'package:flutter/material.dart';

import '../../../core/extensions/date_time_ext.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/design_tokens.dart';

/// Which rendering a [TimestampBadge] uses.
enum TimestampFormat { hourMinute, fullDateTime, relativeTime }

/// Small muted chip showing when a reading arrived, always in UTC+7.
class TimestampBadge extends StatelessWidget {
  const TimestampBadge({
    super.key,
    required this.timestamp,
    this.format = TimestampFormat.hourMinute,
    this.prefix,
    this.filled = true,
  });

  final DateTime? timestamp;
  final TimestampFormat format;
  final String? prefix;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final text = _formatted();

    final label = Text(
      prefix == null ? text : '$prefix $text',
      style: AppTextStyles.bodyMedium.copyWith(color: palette.mutedText),
    );

    if (!filled) return label;

    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
      decoration: BoxDecoration(
        color: palette.hoverBg.withOpacity(context.isDarkMode ? 0.4 : 1),
        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
      ),
      child: label,
    );
  }

  String _formatted() {
    final value = timestamp;
    if (value == null) return '--:--';
    return switch (format) {
      TimestampFormat.hourMinute => value.toFormattedString(),
      TimestampFormat.fullDateTime => value.toDateTimeString(),
      TimestampFormat.relativeTime => value.toRelativeTime(),
    };
  }
}
