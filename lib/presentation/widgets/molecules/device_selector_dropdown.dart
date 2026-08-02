import 'package:flutter/material.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../domain/entities/device_entity.dart';

/// Bottom sheet listing every station, with a tick beside the active one.
class DeviceSelectorSheet extends StatelessWidget {
  const DeviceSelectorSheet({
    super.key,
    required this.devices,
    required this.selectedDeviceId,
    required this.onSelect,
  });

  final List<DeviceEntity> devices;
  final int? selectedDeviceId;
  final ValueChanged<int> onSelect;

  /// Opens the sheet and returns the chosen station id, or null if dismissed.
  static Future<int?> show(
    BuildContext context, {
    required List<DeviceEntity> devices,
    required int? selectedDeviceId,
  }) {
    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => DeviceSelectorSheet(
        devices: devices,
        selectedDeviceId: selectedDeviceId,
        onSelect: (id) => Navigator.of(sheetContext).pop(id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return SafeArea(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Icon(Icons.sensors, size: 20, color: palette.secondaryText),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Select station',
                    style: AppTextStyles.headlineSmall
                        .copyWith(color: palette.primaryText),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: palette.divider),
            Flexible(
              child: devices.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Text(
                        'No stations registered.',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: palette.mutedText),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: devices.length,
                      separatorBuilder: (_, __) =>
                          Divider(height: 1, color: palette.divider),
                      itemBuilder: (context, index) {
                        final device = devices[index];
                        final isSelected = device.id == selectedDeviceId;

                        return InkWell(
                          onTap: () => onSelect(device.id),
                          child: Container(
                            height: 56,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        device.displayName,
                                        style: AppTextStyles.bodyLarge.copyWith(
                                          color: palette.primaryText,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        device.type == null
                                            ? 'ID ${device.id}'
                                            : 'ID ${device.id} \u00B7 ${device.type}',
                                        style: AppTextStyles.bodySmall
                                            .copyWith(color: palette.mutedText),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(Icons.check, color: palette.success, size: 20),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}
