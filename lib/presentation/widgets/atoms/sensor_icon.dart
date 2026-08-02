import 'package:flutter/material.dart';

import '../../../core/theme/app_palette.dart';
import '../../../domain/entities/sensor_type.dart';

/// Material icon for a measurement, tinted with that measurement's color.
class SensorIcon extends StatelessWidget {
  const SensorIcon({
    super.key,
    required this.type,
    this.size = 24,
    this.overrideColor,
  });

  final SensorType type;
  final double size;
  final Color? overrideColor;

  /// Icon glyph per measurement, also used by the graph dropdown.
  static IconData iconFor(SensorType type) => switch (type) {
        SensorType.temperature => Icons.thermostat,
        SensorType.humidity => Icons.water_drop,
        SensorType.rainfall => Icons.cloud_queue,
        SensorType.windSpeed => Icons.air,
        SensorType.windDirection => Icons.explore,
      };

  @override
  Widget build(BuildContext context) {
    return Icon(
      iconFor(type),
      size: size,
      color: overrideColor ?? context.palette.colorFor(type),
    );
  }
}
