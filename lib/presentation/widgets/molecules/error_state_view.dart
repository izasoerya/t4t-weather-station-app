import 'package:flutter/material.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/utils/error_handler.dart';
import 'app_surface.dart';

/// Failure state with a retry action.
///
/// Renders `AppException.userMessage`, never the raw exception, so a Postgres
/// error string or a stack trace cannot reach the screen.
class ErrorStateView extends StatelessWidget {
  const ErrorStateView({
    super.key,
    required this.error,
    this.onRetry,
    this.compact = false,
  });

  final Object error;
  final VoidCallback? onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return AppSurface(
      padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: palette.error, size: compact ? 24 : 32),
          const SizedBox(height: AppSpacing.sm),
          Text(
            ErrorHandler.userMessage(error),
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(color: palette.secondaryText),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppSpacing.md),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry'),
              style: TextButton.styleFrom(foregroundColor: palette.info),
            ),
          ],
        ],
      ),
    );
  }
}

/// Neutral state for a successful query that returned nothing.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: palette.mutedText, size: 32),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(color: palette.mutedText),
          ),
        ],
      ),
    );
  }
}
