import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class ThemeService {
  static final _themeModeController = BehaviorSubject<ThemeMode>()
    ..sink.add(ThemeMode.system);

  /// will enable light mode
  static enableLightTheme() => _themeModeController.sink.add(ThemeMode.light);

  /// will enable system mode
  static enableSystemTheme() => _themeModeController.sink.add(ThemeMode.system);

  /// will enable dark theme
  static enableDarkTheme() => _themeModeController.sink.add(ThemeMode.dark);

  /// current theme of the application
  static Stream<ThemeMode> get themeModeStream => _themeModeController.stream;

  /// initial data for the current theme of the application
  static ThemeMode get themeModeInitialData => _themeModeController.value;
}

/// if the given context is in [ThemeMode.light]
bool isLightMode(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light;
