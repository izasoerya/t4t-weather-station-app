import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/utils/logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // A missing or unreadable .env should not take the app down at launch. The
  // dashboard still renders and surfaces a configuration error through the
  // normal error path, which is easier to diagnose than a blank screen.
  try {
    await dotenv.load();
  } catch (e) {
    logger.error('Could not load .env, API calls will fail', e);
  }

  runApp(const ProviderScope(child: WeatherStationApp()));
}
