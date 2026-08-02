import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../domain/exceptions/app_exceptions.dart';
import 'logger.dart';

/// Translates transport-level failures into domain exceptions.
///
/// Repositories call [mapError] in their catch blocks so nothing above the data
/// layer ever sees a `DioException`. Status-code messages mirror the table in
/// API_REFERENCE.md.
class ErrorHandler {
  const ErrorHandler._();

  static AppException mapError(Object error, [StackTrace? stackTrace]) {
    if (error is AppException) return error;

    if (error is DioException) return _mapDioException(error);

    if (error is SocketException) {
      return NetworkException('Socket failure: ${error.message}');
    }

    if (error is TimeoutException) {
      return const NetworkException('Request timed out');
    }

    if (error is FormatException) {
      return SensorDataException('Malformed response: ${error.message}');
    }

    logger.error('Unmapped error', error, stackTrace);
    return UnknownException(error.toString());
  }

  static AppException _mapDioException(DioException e) => switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout =>
          const NetworkException('Request timed out'),
        DioExceptionType.connectionError =>
          NetworkException('Connection failed: ${e.message}'),
        DioExceptionType.cancel => const NetworkException('Request cancelled'),
        DioExceptionType.badCertificate =>
          const NetworkException('Invalid TLS certificate'),
        DioExceptionType.badResponse => _mapStatusCode(e),
        DioExceptionType.unknown =>
          UnknownException(e.message ?? 'Unknown request failure'),
        DioExceptionType.transformTimeout =>
          const NetworkException('Transform timed out'),
      };

  static AppException _mapStatusCode(DioException e) {
    final status = e.response?.statusCode;
    final body = e.response?.data?.toString() ?? '';

    return switch (status) {
      400 => SensorDataException(
          'Bad request, check query parameters: $body',
          statusCode: 400,
        ),
      401 => const AuthorizationException(
          'Invalid or missing Supabase anon key',
          statusCode: 401,
        ),
      403 => const AuthorizationException(
          'Row Level Security blocked this query',
          statusCode: 403,
        ),
      404 => const SensorDataException(
          'Table or resource not found',
          statusCode: 404,
        ),
      429 => const NetworkException('Rate limited, slow down polling',
          statusCode: 429),
      _ when status != null && status >= 500 => NetworkException(
          'Supabase returned $status',
          statusCode: status,
        ),
      _ =>
        UnknownException('Request failed ($status): $body', statusCode: status),
    };
  }

  /// User-facing text for any error, mapped or not.
  static String userMessage(Object error) =>
      error is AppException ? error.userMessage : mapError(error).userMessage;
}
