import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/supabase_api_client.dart';
import '../../data/datasources/remote/supabase_api_service.dart';
import '../../data/repositories/device_repository_impl.dart';
import '../../data/repositories/sensor_repository_impl.dart';
import '../../domain/repositories/device_repository.dart';
import '../../domain/repositories/sensor_repository.dart';

/// Single Dio-backed API client for the app.
///
/// Riverpod caches the instance, so one connection pool and one set of
/// interceptors serve every repository. Override this provider in tests to
/// swap in a fake without touching any other layer.
final supabaseApiServiceProvider = Provider<SupabaseApiService>(
  (ref) => SupabaseApiClient(),
);

final deviceRepositoryProvider = Provider<DeviceRepository>(
  (ref) => DeviceRepositoryImpl(ref.watch(supabaseApiServiceProvider)),
);

final sensorRepositoryProvider = Provider<SensorRepository>(
  (ref) => SensorRepositoryImpl(ref.watch(supabaseApiServiceProvider)),
);
