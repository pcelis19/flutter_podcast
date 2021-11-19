import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class ThemePacket {
  final ThemeMode themeMode;
  final MaterialColor primaryColor;
  final MaterialAccentColor accentColor;

  const ThemePacket(this.themeMode, this.primaryColor, this.accentColor);
  ThemePacket copyWith(
          {ThemeMode? themeMode,
          MaterialColor? primaryColor,
          MaterialAccentColor? accentColor}) =>
      ThemePacket(themeMode ?? this.themeMode,
          primaryColor ?? this.primaryColor, accentColor ?? this.accentColor);

  static const defaultTheme =
      ThemePacket(ThemeMode.system, Colors.cyan, Colors.pinkAccent);
}

class ThemeService {
  static final _themeModeController = BehaviorSubject<ThemePacket>()
    ..sink.add(
      const ThemePacket(ThemeMode.system, Colors.cyan, Colors.pinkAccent),
    );

  /// will enable light mode
  static void enableLightTheme() => _themeModeController.sink
      .add(_themeModeController.value.copyWith(themeMode: ThemeMode.light));

  /// will enable system mode
  static void enableSystemTheme() => _themeModeController.sink
      .add(_themeModeController.value.copyWith(themeMode: ThemeMode.system));

  /// will enable dark theme
  static void enableDarkTheme() => _themeModeController.sink
      .add(_themeModeController.value.copyWith(themeMode: ThemeMode.dark));

  /// changes the primary color of the application
  static void changePrimaryColor(MaterialColor nextPrimaryColor) =>
      _themeModeController.sink.add(
          _themeModeController.value.copyWith(primaryColor: nextPrimaryColor));

  /// changes the accent color of the application
  static void changeAccentColor(MaterialAccentColor nextAccentColor) =>
      _themeModeController.sink.add(
          _themeModeController.value.copyWith(accentColor: nextAccentColor));

  static void revertToDefaultColors() =>
      _themeModeController.sink.add(_themeModeController.value.copyWith(
          primaryColor: ThemePacket.defaultTheme.primaryColor,
          accentColor: ThemePacket.defaultTheme.accentColor));

  /// current theme of the application
  static Stream<ThemePacket> get themeModeStream => _themeModeController.stream;

  /// initial data for the current theme of the application
  static ThemePacket get themeModeInitialData => _themeModeController.value;
}
