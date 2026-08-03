import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_station_dashboard/presentation/widgets/molecules/prediction_card.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/error_handler.dart';
import '../../domain/entities/sensor_type.dart';
import '../providers/device_provider.dart';
import '../providers/historical_sensor_provider.dart';
import '../providers/sensor_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/molecules/device_selector_dropdown.dart';
import '../widgets/organisms/app_header.dart';
import '../widgets/organisms/detail_graph_section.dart';
import '../widgets/organisms/sensor_grid.dart';

/// The single screen of the app: header, sensor grid, collapsible graph.
class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final device = ref.watch(currentDeviceProvider);
    final isOnline = ref.watch(isDeviceOnlineProvider);
    final lastUpdated = ref.watch(lastUpdatedProvider);
    final selectedSensorType = ref.watch(selectedSensorTypeProvider);
    final isDark = context.isDarkMode;

    // Surfaces a failed device query once, without blocking the rest of the UI.
    ref.listen(devicesProvider, (previous, next) {
      if (next.hasError && previous?.hasError != true) {
        _showError(next.error!);
      }
    });

    return Scaffold(
      backgroundColor: palette.primaryBg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              device: device,
              isOnline: isOnline,
              lastUpdated: lastUpdated,
              isDarkMode: isDark,
              onDeviceDropdownTap: _openDeviceSelector,
              onThemeToggleTap: () => ref
                  .read(themeModeProvider.notifier)
                  .toggle(Theme.of(context).brightness),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshAll,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SensorGrid(
                        selectedType: selectedSensorType,
                        onSensorTap: _openGraphFor,
                      ),
                      const DetailGraphSection(),
                      const PredictionCard()
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Tapping a card opens the graph on that measurement. Tapping the card whose
  /// measurement is already showing collapses the graph again, which makes the
  /// gesture its own undo.
  void _openGraphFor(SensorType type) {
    ref.read(selectedSensorTypeProvider.notifier).state = type;
  }

  Future<void> _openDeviceSelector() async {
    final devicesAsync = ref.read(devicesProvider);

    final devices = devicesAsync.valueOrNull;
    if (devices == null) {
      if (devicesAsync.hasError) {
        _showError(devicesAsync.error!);
      }
      return;
    }

    final selected = await DeviceSelectorSheet.show(
      context,
      devices: devices,
      selectedDeviceId: ref.read(effectiveDeviceIdProvider),
    );

    if (selected == null || !mounted) return;
    // Writing the id restarts polling: sensorDataProvider watches the effective
    // device id, so its notifier rebuilds and the old timer is cancelled.
    ref.read(selectedDeviceIdProvider.notifier).state = selected;
  }

  Future<void> _refreshAll() async {
    ref.invalidate(devicesProvider);
    await ref.read(sensorDataProvider.notifier).refresh();
  }

  void _showError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ErrorHandler.userMessage(error))),
    );
  }
}
