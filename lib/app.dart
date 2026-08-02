import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_themes.dart';
import 'presentation/pages/dashboard_page.dart';
import 'presentation/providers/theme_provider.dart';

/// Root widget. Supplies both themes and lets [themeModeProvider] choose.
class WeatherStationApp extends ConsumerWidget {
  const WeatherStationApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: getLightTheme(),
      darkTheme: getDarkTheme(),
      themeMode: ref.watch(themeModeProvider),
      home: const DashboardPage(),
    );
  }
}
