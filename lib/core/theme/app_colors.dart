import 'package:flutter/material.dart';

/// Raw Grafana-inspired color values from design.md.
///
/// Widgets should read colors through `context.palette` instead of touching
/// these constants directly, so light and dark modes resolve automatically.
class AppColors {
  const AppColors._();

  // ---- Light mode ----
  static const Color lightPrimaryBg = Color(0xFFF7F9FC);
  static const Color lightSecondaryBg = Color(0xFFFFFFFF);
  static const Color lightCardBg = Color(0xFFFFFFFF);
  static const Color lightDivider = Color(0xFFE6EAF0);
  static const Color lightPrimaryText = Color(0xFF111827);
  static const Color lightSecondaryText = Color(0xFF6B7280);
  static const Color lightMutedText = Color(0xFF9CA3AF);
  static const Color lightDisabledText = Color(0xFFD1D5DB);
  static const Color lightBorder = Color(0xFFE8ECF2);
  static const Color lightHoverBg = Color(0xFFF1F5F9);

  // ---- Dark mode ----
  static const Color darkPrimaryBg = Color(0xFF0F172A);
  static const Color darkSecondaryBg = Color(0xFF1E293B);
  static const Color darkCardBg = Color(0xFF243043);
  static const Color darkDivider = Color(0xFF3B4A60);
  static const Color darkPrimaryText = Color(0xFFF9FAFB);
  static const Color darkSecondaryText = Color(0xFFD1D5DB);
  static const Color darkMutedText = Color(0xFF9CA3AF);
  static const Color darkDisabledText = Color(0xFF6B7280);
  static const Color darkBorder = Color(0xFF3B4A60);
  static const Color darkHoverBg = Color(0xFF334155);

  // ---- Sensor colors, light mode ----
  static const Color temperature = Color(0xFFFF6B35);
  static const Color humidity = Color(0xFF004E89);
  static const Color windSpeed = Color(0xFF7B68EE);
  static const Color windDirection = Color(0xFF50C878);
  static const Color rainfall = Color(0xFF0891B2);

  // ---- Sensor colors, dark mode (lifted for contrast on dark backgrounds) ----
  static const Color temperatureDark = Color(0xFFFF6B35);
  static const Color humidityDark = Color(0xFF5B9AFF);
  static const Color windSpeedDark = Color(0xFF9D84EE);
  static const Color windDirectionDark = Color(0xFF50C878);
  static const Color rainfallDark = Color(0xFF06B6D4);

  // ---- Status, light mode ----
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ---- Status, dark mode ----
  static const Color successDark = Color(0xFF10B981);
  static const Color warningDark = Color(0xFFFBBF24);
  static const Color errorDark = Color(0xFFF87171);
  static const Color infoDark = Color(0xFF60A5FA);
}
