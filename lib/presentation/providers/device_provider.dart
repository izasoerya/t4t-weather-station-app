import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/device_entity.dart';
import 'usecase_provider.dart';

/// Every registered station. Fetched once and cached; the device list rarely
/// changes, so it is not part of the 5-second polling loop.
final devicesProvider = FutureProvider<List<DeviceEntity>>((ref) async {
  final useCase = ref.watch(getDevicesUseCaseProvider);
  return useCase.execute();
});

/// The station the person picked, or null before they pick one.
final selectedDeviceIdProvider = StateProvider<int?>((ref) => null);

/// The station the dashboard is actually showing.
///
/// Falls back to the first station in the list so the dashboard has data on
/// first launch. Deriving the default here rather than writing to
/// [selectedDeviceIdProvider] from a widget keeps the fallback out of the build
/// phase, where mutating a provider would throw.
final effectiveDeviceIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(selectedDeviceIdProvider);
  if (selected != null) return selected;

  return ref.watch(devicesProvider).maybeWhen(
        data: (devices) => devices.isEmpty ? null : devices.first.id,
        orElse: () => null,
      );
});

/// Full entity for the active station, for the header and the picker.
final currentDeviceProvider = Provider<DeviceEntity?>((ref) {
  final deviceId = ref.watch(effectiveDeviceIdProvider);
  if (deviceId == null) return null;

  return ref.watch(devicesProvider).maybeWhen(
        data: (devices) {
          for (final device in devices) {
            if (device.id == deviceId) return device;
          }
          return null;
        },
        orElse: () => null,
      );
});
