import 'package:flutter/material.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/theme/design_tokens.dart';

/// Card surface with the radius, border and shadow from design.md.
///
/// Used instead of Material's `Card` so the elevation rules stay identical
/// across Flutter versions and so light and dark shadows can differ, which
/// `Card` alone cannot express.
class AppSurface extends StatelessWidget {
  const AppSurface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.onTap,
    this.elevated = false,
    this.radius = DesignTokens.radiusMd,
    this.showBorder = true,
    this.borderColor,
    this.boxShadow,
    this.color,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool elevated;
  final double radius;
  final bool showBorder;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final borderRadius = BorderRadius.circular(radius);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: color ?? palette.cardBg,
        borderRadius: BorderRadius.circular(5),
        border: showBorder
            ? Border.all(color: borderColor ?? palette.border)
            : null,
        boxShadow:
            boxShadow ?? (elevated ? palette.hoverShadow : palette.cardShadow),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          splashColor: palette.hoverBg.withOpacity(DesignTokens.opacityActive),
          highlightColor:
              palette.hoverBg.withOpacity(DesignTokens.opacityHover),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
