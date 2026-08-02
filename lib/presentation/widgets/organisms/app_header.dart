import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../domain/entities/device_entity.dart';
import '../atoms/status_indicator.dart';
import '../atoms/timestamp_badge.dart';

/// Two-row header: title with station picker and theme toggle on top, status
/// and last-updated time underneath.
class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.device,
    required this.isOnline,
    required this.lastUpdated,
    required this.onDeviceDropdownTap,
    required this.onThemeToggleTap,
    required this.isDarkMode,
  });

  final DeviceEntity? device;
  final bool isOnline;
  final DateTime? lastUpdated;
  final VoidCallback onDeviceDropdownTap;
  final VoidCallback onThemeToggleTap;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.sensors, size: 32, color: palette.secondaryText),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppConstants.headerTitle,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: palette.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    StatusIndicator(isOnline: isOnline),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _DeviceChip(
                label: device?.displayName ?? 'Station 1',
                onTap: onDeviceDropdownTap,
              ),
              const SizedBox(width: AppSpacing.md),
              _ThemeToggleButton(
                isDarkMode: isDarkMode,
                onTap: onThemeToggleTap,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TimestampBadge(
            timestamp: lastUpdated,
            prefix: 'Last updated:',
            filled: false,
          ),
        ],
      ),
    );
  }
}

/// Tappable station label that opens the picker.
class _DeviceChip extends StatelessWidget {
  const _DeviceChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final borderRadius = BorderRadius.circular(DesignTokens.radiusMd);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Container(
          height: DesignTokens.minTouchTarget,
          constraints: const BoxConstraints(maxWidth: 118),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(color: palette.divider.withOpacity(0.8)),
            color: context.isDarkMode ? palette.primaryBg : palette.cardBg,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: palette.primaryText),
                ),
              ),
              Icon(Icons.expand_more, size: 18, color: palette.secondaryText),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeToggleButton extends StatelessWidget {
  const _ThemeToggleButton({required this.isDarkMode, required this.onTap});

  final bool isDarkMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: DesignTokens.minTouchTarget,
          height: DesignTokens.minTouchTarget,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDarkMode ? palette.primaryBg : palette.secondaryBg,
            border: Border.all(color: palette.divider.withOpacity(0.8)),
          ),
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
              key: ValueKey<bool>(isDarkMode),
              size: 18,
              color: palette.warning,
            ),
          ),
        ),
      ),
    );
  }
}
