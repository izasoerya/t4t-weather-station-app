import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Light, dark or follow-the-system, using Flutter's own [ThemeMode].
final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void setMode(ThemeMode mode) => state = mode;

  /// Flips to the opposite of what the person is currently looking at.
  ///
  /// Takes the rendered brightness rather than reading [state], because in
  /// `ThemeMode.system` the state alone cannot say whether the screen is
  /// currently light or dark. Tapping the moon on a system-dark phone should
  /// produce light, not another dark.
  void toggle(Brightness currentBrightness) {
    state = currentBrightness == Brightness.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }
}
