import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

import '../../core/constants/gemini_constants.dart';
import '../../domain/entities/sensor_entity.dart';
import '../../domain/entities/sensor_type.dart';
import 'device_provider.dart';
import 'historical_sensor_provider.dart';
import 'sensor_provider.dart';

/// Hourly heartbeat that forces the prediction to refresh.
final predictionRefreshTickProvider =
    StreamProvider.autoDispose<DateTime>((ref) {
  return Stream<DateTime>.periodic(
    const Duration(hours: 1),
    (_) => DateTime.now().toUtc(),
  );
});

/// Live AI prediction for the currently selected metric.
final predictionProvider = FutureProvider.autoDispose<String>((ref) async {
  ref.watch(predictionRefreshTickProvider);

  final deviceId = ref.watch(effectiveDeviceIdProvider);
  if (deviceId == null) {
    return 'Select a station to generate a prediction.';
  }

  if (!GeminiConstants.isConfigured) {
    return 'Add GEMINI_API_KEY to .env to generate a live prediction.';
  }

  final sensorType = ref.read(selectedSensorTypeProvider);
  final timeRange = ref.read(graphTimeRangeProvider);
  final latestReadings = await ref.read(sensorDataProvider.future);
  final latest = latestReadings.isEmpty ? null : latestReadings.first;
  if (latest == null) {
    return 'No live sensor reading is available yet.';
  }

  final historicalReadings = await ref.read(
    historicalSensorDataProvider((deviceId: deviceId, timeRange: timeRange))
        .future,
  );

  final model = GenerativeModel(
    model: GeminiConstants.modelName,
    apiKey: GeminiConstants.apiKey,
  );

  final prompt = _buildPrompt(
    sensorType: sensorType,
    timeRange: timeRange,
    latest: latest,
    history: historicalReadings,
  );

  final response = await model.generateContent([Content.text(prompt)]);
  final prediction = response.text?.trim();

  if (prediction == null || prediction.isEmpty) {
    return 'Gemini did not return a prediction.';
  }

  return prediction;
});

String _buildPrompt({
  required SensorType sensorType,
  required TimeRange timeRange,
  required SensorEntity latest,
  required List<SensorEntity> history,
}) {
  final formatter = DateFormat('MMM d, HH:mm');
  final historySample = history.reversed.take(8).toList(growable: false);

  final historyLines = historySample.isEmpty
      ? 'No history available.'
      : historySample.map((reading) {
          final time = formatter.format(reading.createdAt.toUtc());
          return '$time | ${_describeReading(reading)}';
        }).join('\n');

  return '''
You are a concise weather analyst for a dashboard.
Use the live reading and recent history to predict the next short-term trend for ${sensorType.label}.
Write 1 short paragraph only, plain text, no bullets, no markdown, no disclaimers.
Keep it specific, useful, and add a percentage prediction of the weather that will happen in a few hours (e.g. in the next 3 hours, there estimated 67% will rain) and keep it under 35 words.

Current reading:
${_describeReading(latest)}

Recent history for ${timeRange.label} (oldest to newest):
$historyLines

Prediction:
''';
}

String _describeReading(SensorEntity reading) {
  final direction = SensorEntity.cardinalLongerText(reading.windDirection);
  return [
    'Temperature ${reading.temperature.toStringAsFixed(1)}°C',
    'Humidity ${reading.humidity.toStringAsFixed(1)}%',
    'Rainfall ${reading.rainfall.toStringAsFixed(1)} mm',
    'Wind speed ${reading.windSpeed.toStringAsFixed(1)} km/h',
    'Wind direction $direction',
  ].join(', ');
}
