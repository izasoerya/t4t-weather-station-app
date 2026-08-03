import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_station_dashboard/core/theme/design_tokens.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/prediction_provider.dart';
import '../molecules/app_surface.dart';

class PredictionCard extends ConsumerWidget {
  const PredictionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.palette;
    final predictionAsync = ref.watch(predictionProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: AppSurface(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.online_prediction_rounded, color: palette.info),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Prediction Result',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: palette.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            predictionAsync.when(
              data: (prediction) => Text(
                prediction,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: palette.primaryText,
                  height: 1.6,
                ),
              ),
              loading: () => Text(
                'Generating prediction...',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: palette.secondaryText,
                  height: 1.6,
                ),
              ),
              error: (error, _) => Text(
                'Prediction unavailable right now. Please try again later.\n$error',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: palette.secondaryText,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
