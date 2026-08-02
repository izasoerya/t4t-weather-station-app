import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Severity levels, ordered from most to least verbose.
enum LogLevel { debug, info, warning, error }

/// Single logging entry point for the whole app.
///
/// Wraps `dart:developer` so log output survives release builds being stripped
/// of `print`, and gives one place to bolt on Crashlytics or Sentry later:
/// add a sink in [log] and every existing call site starts reporting.
class AppLogger {
  AppLogger._();

  static final AppLogger instance = AppLogger._();

  /// Messages below this level are dropped. Release builds only keep warnings
  /// and errors.
  LogLevel minimumLevel = kReleaseMode ? LogLevel.warning : LogLevel.debug;

  void debug(String message, [Object? data]) =>
      log(LogLevel.debug, message, data);

  void info(String message, [Object? data]) =>
      log(LogLevel.info, message, data);

  void warning(String message, [Object? data]) =>
      log(LogLevel.warning, message, data);

  void error(String message, [Object? exception, StackTrace? stackTrace]) =>
      log(LogLevel.error, message, exception, stackTrace);

  void log(
    LogLevel level,
    String message, [
    Object? data,
    StackTrace? stackTrace,
  ]) {
    if (level.index < minimumLevel.index) return;

    final timestamp = DateTime.now().toIso8601String();
    final buffer = StringBuffer('[$timestamp] ${_tag(level)} $message');
    if (data != null) buffer.write(' | $data');

    developer.log(
      buffer.toString(),
      name: 'WeatherStation',
      level: _developerLevel(level),
      error: level == LogLevel.error ? data : null,
      stackTrace: stackTrace,
    );
  }

  /// Times [action], logs its duration, and rethrows any failure after logging.
  ///
  /// Used by repositories so every API call reports how long it took without
  /// each method repeating the same try/catch scaffolding.
  Future<T> timed<T>(String operation, Future<T> Function() action) async {
    debug('Starting: $operation');
    final stopwatch = Stopwatch()..start();
    try {
      final result = await action();
      stopwatch.stop();
      debug('Completed: $operation (${stopwatch.elapsedMilliseconds}ms)');
      return result;
    } catch (e, s) {
      stopwatch.stop();
      error('Failed: $operation (${stopwatch.elapsedMilliseconds}ms)', e, s);
      rethrow;
    }
  }

  String _tag(LogLevel level) => switch (level) {
        LogLevel.debug => 'DEBUG',
        LogLevel.info => 'INFO ',
        LogLevel.warning => 'WARN ',
        LogLevel.error => 'ERROR',
      };

  int _developerLevel(LogLevel level) => switch (level) {
        LogLevel.debug => 500,
        LogLevel.info => 800,
        LogLevel.warning => 900,
        LogLevel.error => 1000,
      };
}

/// Shorthand used across the app.
final AppLogger logger = AppLogger.instance;
