/// Base type for every error the domain layer surfaces.
///
/// Data-layer failures (Dio, parsing, HTTP status codes) are translated into
/// one of these subtypes by `ErrorHandler`, so the presentation layer only ever
/// deals with domain vocabulary.
sealed class AppException implements Exception {
  const AppException(this.message, {this.statusCode});

  /// Technical description, safe for logs.
  final String message;

  /// HTTP status behind the failure, when there was one.
  final int? statusCode;

  /// Message shown to the person using the app.
  String get userMessage;

  @override
  String toString() => '$runtimeType($message)';
}

/// No connection, DNS failure, or a timeout.
final class NetworkException extends AppException {
  const NetworkException(super.message, {super.statusCode});

  @override
  String get userMessage =>
      'Cannot reach the weather station service. Check your connection and try again.';
}

/// The API rejected the anon key, or RLS blocked the query.
final class AuthorizationException extends AppException {
  const AuthorizationException(super.message, {super.statusCode});

  @override
  String get userMessage =>
      'Access denied. Verify the Supabase key in .env and the table access policies.';
}

/// The requested station is not in the devices table.
final class DeviceNotFoundException extends AppException {
  const DeviceNotFoundException(this.deviceId)
      : super('Device $deviceId not found', statusCode: 404);

  final int deviceId;

  @override
  String get userMessage => 'Station $deviceId is no longer available.';
}

/// The query succeeded but the payload was empty or malformed.
final class SensorDataException extends AppException {
  const SensorDataException(super.message, {super.statusCode});

  @override
  String get userMessage => 'Sensor data is unavailable right now.';
}

/// Supabase URL or anon key missing from `.env`.
final class ConfigurationException extends AppException {
  const ConfigurationException(super.message);

  @override
  String get userMessage =>
      'App is not configured. Add SUPABASE_URL and SUPABASE_ANON_KEY to .env.';
}

/// Anything that did not match a known failure mode.
final class UnknownException extends AppException {
  const UnknownException(super.message, {super.statusCode});

  @override
  String get userMessage => 'Something went wrong. Please try again.';
}
