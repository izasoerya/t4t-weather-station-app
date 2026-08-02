import 'package:flutter/material.dart';

import '../../domain/entities/sensor_type.dart';
import 'app_colors.dart';
import 'design_tokens.dart';

/// Brightness-aware color set.
///
/// Flutter's `ColorScheme` has no slot for "muted text" or "rainfall cyan", so
/// the palette carries the extra roles design.md defines. Widgets reach it with
/// `context.palette`, which resolves against the ambient theme, so no widget
/// ever branches on brightness itself.
class AppPalette {
  const AppPalette({
    required this.primaryBg,
    required this.secondaryBg,
    required this.cardBg,
    required this.divider,
    required this.primaryText,
    required this.secondaryText,
    required this.mutedText,
    required this.disabledText,
    required this.border,
    required this.hoverBg,
    required this.temperature,
    required this.humidity,
    required this.rainfall,
    required this.windSpeed,
    required this.windDirection,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.cardShadow,
    required this.hoverShadow,
    required this.modalShadow,
  });

  final Color primaryBg;
  final Color secondaryBg;
  final Color cardBg;
  final Color divider;
  final Color primaryText;
  final Color secondaryText;
  final Color mutedText;
  final Color disabledText;
  final Color border;
  final Color hoverBg;

  final Color temperature;
  final Color humidity;
  final Color rainfall;
  final Color windSpeed;
  final Color windDirection;

  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  final List<BoxShadow> cardShadow;
  final List<BoxShadow> hoverShadow;
  final List<BoxShadow> modalShadow;

  static const AppPalette light = AppPalette(
    primaryBg: AppColors.lightPrimaryBg,
    secondaryBg: AppColors.lightSecondaryBg,
    cardBg: AppColors.lightCardBg,
    divider: AppColors.lightDivider,
    primaryText: AppColors.lightPrimaryText,
    secondaryText: AppColors.lightSecondaryText,
    mutedText: AppColors.lightMutedText,
    disabledText: AppColors.lightDisabledText,
    border: AppColors.lightBorder,
    hoverBg: AppColors.lightHoverBg,
    temperature: AppColors.temperature,
    humidity: AppColors.humidity,
    rainfall: AppColors.rainfall,
    windSpeed: AppColors.windSpeed,
    windDirection: AppColors.windDirection,
    success: AppColors.success,
    warning: AppColors.warning,
    error: AppColors.error,
    info: AppColors.info,
    cardShadow: DesignTokens.shadowCardLight,
    hoverShadow: DesignTokens.shadowHoverLight,
    modalShadow: DesignTokens.shadowModalLight,
  );

  static const AppPalette dark = AppPalette(
    primaryBg: AppColors.darkPrimaryBg,
    secondaryBg: AppColors.darkSecondaryBg,
    cardBg: AppColors.darkCardBg,
    divider: AppColors.darkDivider,
    primaryText: AppColors.darkPrimaryText,
    secondaryText: AppColors.darkSecondaryText,
    mutedText: AppColors.darkMutedText,
    disabledText: AppColors.darkDisabledText,
    border: AppColors.darkBorder,
    hoverBg: AppColors.darkHoverBg,
    temperature: AppColors.temperatureDark,
    humidity: AppColors.humidityDark,
    rainfall: AppColors.rainfallDark,
    windSpeed: AppColors.windSpeedDark,
    windDirection: AppColors.windDirectionDark,
    success: AppColors.successDark,
    warning: AppColors.warningDark,
    error: AppColors.errorDark,
    info: AppColors.infoDark,
    cardShadow: DesignTokens.shadowCardDark,
    hoverShadow: DesignTokens.shadowHoverDark,
    modalShadow: DesignTokens.shadowModalDark,
  );

  static AppPalette forBrightness(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;

  /// Accent color for a measurement, used by its icon, value and chart line.
  Color colorFor(SensorType type) => switch (type) {
        SensorType.temperature => temperature,
        SensorType.humidity => humidity,
        SensorType.rainfall => rainfall,
        SensorType.windSpeed => windSpeed,
        SensorType.windDirection => windDirection,
      };
}

/// Palette and text-style shortcuts for widget build methods.
extension PaletteContextExt on BuildContext {
  AppPalette get palette =>
      AppPalette.forBrightness(Theme.of(this).brightness);

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
