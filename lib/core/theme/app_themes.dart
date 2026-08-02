import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_palette.dart';
import 'app_text_styles.dart';
import 'design_tokens.dart';

/// Builds the light and dark `ThemeData` used by `MaterialApp`.
///
/// Only theme slots the app actually relies on are configured. Card, chip and
/// dialog surfaces are painted by the widgets themselves through
/// [AppPalette], which keeps the shadow and radius rules from design.md in one
/// place and avoids the Material defaults fighting them.
ThemeData getLightTheme() => _buildTheme(Brightness.light);

ThemeData getDarkTheme() => _buildTheme(Brightness.dark);

ThemeData _buildTheme(Brightness brightness) {
  final palette = AppPalette.forBrightness(brightness);
  final isDark = brightness == Brightness.dark;

  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.info,
    brightness: brightness,
  ).copyWith(
    surface: palette.cardBg,
    onSurface: palette.primaryText,
    error: palette.error,
    outline: palette.border,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: palette.primaryBg,
    canvasColor: palette.primaryBg,
    dividerColor: palette.divider,
    splashFactory: InkSparkle.splashFactory,
    appBarTheme: AppBarTheme(
      backgroundColor: isDark ? palette.secondaryBg : palette.cardBg,
      foregroundColor: palette.primaryText,
      surfaceTintColor: Colors.transparent,
      elevation: isDark ? 4 : 2,
      shadowColor: isDark
          ? const Color.fromRGBO(0, 0, 0, 0.5)
          : const Color.fromRGBO(0, 0, 0, 0.08),
      centerTitle: false,
    ),
    iconTheme: IconThemeData(color: palette.secondaryText, size: 24),
    dividerTheme: DividerThemeData(
      color: palette.divider,
      thickness: 1,
      space: 1,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: colorScheme.primary),
    popupMenuTheme: PopupMenuThemeData(
      color: palette.cardBg,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: palette.cardBg,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DesignTokens.radiusLg),
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: isDark ? palette.cardBg : palette.primaryText,
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: isDark ? palette.primaryText : palette.primaryBg,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
      ),
    ),
    textTheme: _buildTextTheme(palette),
  );
}

TextTheme _buildTextTheme(AppPalette palette) => TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(color: palette.primaryText),
      headlineLarge:
          AppTextStyles.headlineLarge.copyWith(color: palette.primaryText),
      headlineSmall:
          AppTextStyles.headlineSmall.copyWith(color: palette.primaryText),
      titleMedium: AppTextStyles.headlineSmall.copyWith(color: palette.primaryText),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: palette.primaryText),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: palette.secondaryText),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: palette.mutedText),
      labelLarge: AppTextStyles.labelLarge.copyWith(color: palette.secondaryText),
      labelSmall: AppTextStyles.labelSmall.copyWith(color: palette.mutedText),
    );
