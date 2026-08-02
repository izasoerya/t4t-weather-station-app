import 'package:flutter/material.dart';

/// Spacing scale built on an 8px base unit.
class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

/// Radii, shadows, timings and opacities from design.md.
class DesignTokens {
  const DesignTokens._();

  // Border radius.
  static const double radiusSm = 4;
  static const double radiusMd = 8;
  static const double radiusLg = 12;

  // Light mode elevation.
  static const List<BoxShadow> shadowCardLight = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.08),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
  static const List<BoxShadow> shadowHoverLight = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.12),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];
  static const List<BoxShadow> shadowModalLight = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.15),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];

  // Dark mode elevation.
  static const List<BoxShadow> shadowCardDark = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.4),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];
  static const List<BoxShadow> shadowHoverDark = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.5),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];
  static const List<BoxShadow> shadowModalDark = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.6),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  // Opacity.
  static const double opacityHover = 0.08;
  static const double opacityActive = 0.12;
  static const double opacityDisabled = 0.5;
  static const double opacityGridLine = 0.3;
  static const double opacityChartFill = 0.2;

  // Touch targets, per the accessibility section of design.md.
  static const double minTouchTarget = 40;
}
