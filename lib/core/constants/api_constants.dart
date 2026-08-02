import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Supabase REST API configuration, sourced from `.env`.
///
/// Never hardcode credentials here. `main()` calls `dotenv.load()` before the
/// first widget builds, so these getters are safe to read from anywhere in the
/// app once the app is running.
class ApiConstants {
  const ApiConstants._();

  /// Project URL, e.g. `https://abcdefgh.supabase.co`.
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';

  /// Public anon key used for both the `apikey` and `Authorization` headers.
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  /// Full REST base URL that every endpoint path is appended to.
  static String get restBaseUrl => '$supabaseUrl/rest/v1';

  /// True when both credentials are present, checked at startup.
  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  // Table names.
  static const String devicesTable = 'devices';
  static const String sensorsTable = 'sensors';

  // REST paths.
  static const String devicesEndpoint = '/devices';
  static const String sensorsEndpoint = '/sensors';

  // Timeouts.
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 15);

  // Request limits.
  static const int maxDevicesPerQuery = 100;
  static const int maxRecordsPerQuery = 1000;
  static const int graphDataSampleSize = 30;
}
