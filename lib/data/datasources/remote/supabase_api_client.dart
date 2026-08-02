import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/utils/logger.dart';
import '../../../domain/exceptions/app_exceptions.dart';
import '../models/device_dto.dart';
import '../models/sensor_dto.dart';
import 'supabase_api_service.dart';

/// Dio-backed implementation of [SupabaseApiService].
///
/// Builds PostgREST query strings by hand because two of the filters share the
/// `created_at` key. Passing a list value makes Dio emit the key twice
/// (`created_at=gte...&created_at=lte...`), which is what PostgREST expects for
/// a bounded range and what a single map entry cannot express.
class SupabaseApiClient implements SupabaseApiService {
  SupabaseApiClient({Dio? dio}) : _dio = dio ?? createDio();

  final Dio _dio;

  /// Configures a Dio instance with Supabase auth headers, timeouts and
  /// request logging.
  static Dio createDio() {
    if (!ApiConstants.isConfigured) {
      logger.warning(
        'Supabase credentials missing. Copy .env.example to .env and fill it in.',
      );
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.restBaseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.apiTimeout,
        sendTimeout: ApiConstants.apiTimeout,
        responseType: ResponseType.json,
        headers: {
          // PostgREST needs both: apikey identifies the project, the bearer
          // token carries the role that RLS policies are evaluated against.
          'apikey': ApiConstants.supabaseAnonKey,
          'Authorization': 'Bearer ${ApiConstants.supabaseAnonKey}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(_LoggingInterceptor());
    return dio;
  }

  @override
  Future<List<DeviceDto>> getDevices({
    int limit = ApiConstants.maxDevicesPerQuery,
  }) async {
    _assertConfigured();
    final response = await _dio.get<dynamic>(
      ApiConstants.devicesEndpoint,
      queryParameters: <String, dynamic>{
        'select': '*',
        'order': 'id.asc',
        'limit': limit,
      },
    );
    return _decodeList(response.data, DeviceDto.fromJson);
  }

  @override
  Future<List<SensorDto>> getLatestSensorData(
    int deviceId, {
    int limit = 1,
  }) async {
    _assertConfigured();
    final response = await _dio.get<dynamic>(
      ApiConstants.sensorsEndpoint,
      queryParameters: <String, dynamic>{
        'select': '*',
        'device_id': 'eq.$deviceId',
        'order': 'created_at.desc',
        'limit': limit,
      },
    );
    return _decodeList(response.data, SensorDto.fromJson);
  }

  @override
  Future<List<SensorDto>> getHistoricalSensorData({
    required int deviceId,
    required DateTime startTime,
    required DateTime endTime,
    int limit = ApiConstants.maxRecordsPerQuery,
  }) async {
    _assertConfigured();
    final response = await _dio.get<dynamic>(
      ApiConstants.sensorsEndpoint,
      queryParameters: <String, dynamic>{
        'select': '*',
        'device_id': 'eq.$deviceId',
        'created_at': <String>[
          'gte.${startTime.toUtc().toIso8601String()}',
          'lte.${endTime.toUtc().toIso8601String()}',
        ],
        'order': 'created_at.desc',
        'limit': limit,
      },
    );
    return _decodeList(response.data, SensorDto.fromJson);
  }

  void _assertConfigured() {
    if (!ApiConstants.isConfigured) {
      throw const ConfigurationException(
        'SUPABASE_URL or SUPABASE_ANON_KEY missing from .env',
      );
    }
  }

  /// PostgREST always returns a JSON array for these endpoints.
  List<T> _decodeList<T>(
    dynamic data,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (data == null) return const [];
    if (data is! List) {
      throw SensorDataException('Expected a JSON array, got ${data.runtimeType}');
    }
    return data
        .whereType<Map<String, dynamic>>()
        .map(fromJson)
        .toList(growable: false);
  }
}

/// Logs method, path, status and duration for every request.
class _LoggingInterceptor extends Interceptor {
  final Map<int, DateTime> _startTimes = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _startTimes[options.hashCode] = DateTime.now();
    logger.debug('-> ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    final started = _startTimes.remove(response.requestOptions.hashCode);
    final ms = started == null
        ? '?'
        : DateTime.now().difference(started).inMilliseconds.toString();
    final count = response.data is List ? (response.data as List).length : 1;
    logger.debug(
      '<- ${response.statusCode} ${response.requestOptions.path} '
      '($count records, ${ms}ms)',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _startTimes.remove(err.requestOptions.hashCode);
    logger.error(
      'x ${err.response?.statusCode ?? err.type.name} '
      '${err.requestOptions.path}',
      err.response?.data ?? err.message,
    );
    handler.next(err);
  }
}
