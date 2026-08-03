import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Gemini API configuration sourced from `.env`.
class GeminiConstants {
  const GeminiConstants._();

  static String get apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  static bool get isConfigured => apiKey.isNotEmpty;

  static const String modelName = 'gemini-3.1-flash-lite';
}
