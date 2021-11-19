import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class ThemePacket {
  final FlexScheme flexScheme;
  final ThemeMode themeMode;

  const ThemePacket(this.flexScheme, this.themeMode);

  ThemeData get lightMode => FlexThemeData.light(scheme: flexScheme);
  ThemeData get darkMode => FlexThemeData.dark(scheme: flexScheme);

  ThemePacket copyWith({ThemeMode? themeMode, FlexScheme? flexScheme}) =>
      ThemePacket(flexScheme ?? this.flexScheme, themeMode ?? this.themeMode);

  static const defaultTheme =
      ThemePacket(FlexScheme.mandyRed, ThemeMode.system);
}

class ThemeService {
  static final _themeModeController = BehaviorSubject<ThemePacket>()
    ..sink.add(ThemePacket.defaultTheme);

  /// will enable light mode
  static void enableLightTheme() => _themeModeController.sink
      .add(_themeModeController.value.copyWith(themeMode: ThemeMode.light));

  /// will enable system mode
  static void enableSystemTheme() => _themeModeController.sink
      .add(_themeModeController.value.copyWith(themeMode: ThemeMode.system));

  /// changes theme scheme of the application
  static void changeTheme(FlexScheme flexScheme) => _themeModeController.sink
      .add(_themeModeController.value.copyWith(flexScheme: flexScheme));

  /// will enable dark theme
  static void enableDarkTheme() => _themeModeController.sink
      .add(_themeModeController.value.copyWith(themeMode: ThemeMode.dark));

  static void revertToDefaultColors() =>
      _themeModeController.sink.add(ThemePacket.defaultTheme);

  /// current theme of the application
  static Stream<ThemePacket> get themeModeStream => _themeModeController.stream;

  /// initial data for the current theme of the application
  static ThemePacket get themeModeInitialData => _themeModeController.value;
}
