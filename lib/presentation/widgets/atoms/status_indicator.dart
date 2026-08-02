import 'package:flutter/material.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/design_tokens.dart';

/// Colored dot plus Online/Offline text for the header.
class StatusIndicator extends StatelessWidget {
  const StatusIndicator({super.key, required this.isOnline});

  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = isOnline ? palette.success : palette.error;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.xs + 2),
        Text(
          isOnline ? 'Online' : 'Offline',
          style: AppTextStyles.bodySmall.copyWith(color: palette.secondaryText),
        ),
      ],
    );
  }
}
