import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/subjects.dart';
part 'theme_service.g.dart';

@HiveType(typeId: 0)
class ThemePacket extends HiveObject {
  ///
  @HiveField(0)
  final int _flexScheme;

  ///
  @HiveField(1)
  final int _themeMode;

  ThemePacket(FlexScheme flexScheme, ThemeMode themeMode)
      : _flexScheme = flexScheme.index,
        _themeMode = themeMode.index;
  ThemePacket.hive(int flexScheme, int themeMode)
      : _flexScheme = flexScheme,
        _themeMode = themeMode;

  ThemeData get lightMode => FlexThemeData.light(scheme: flexScheme);
  ThemeData get darkMode => FlexThemeData.dark(scheme: flexScheme);

  ThemePacket copyWith({ThemeMode? themeMode, FlexScheme? flexScheme}) =>
      ThemePacket(flexScheme ?? this.flexScheme, themeMode ?? this.themeMode);

  FlexScheme get flexScheme => FlexScheme.values[_flexScheme];
  ThemeMode get themeMode => ThemeMode.values[_themeMode];

  static ThemePacket defaultTheme =
      ThemePacket(FlexScheme.mandyRed, ThemeMode.system);
}

class ThemeService {
  static ThemeService? _instance;
  ThemeService._();
  static ThemeService get instance {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = ThemeService._();
      _init();
      return _instance!;
    }
  }

  static Future<void> _init() async {
    var box = await Hive.openBox<ThemePacket>('themeService');
    var value = box.get('themePacket');
    if (value != null) {
      _themeModeController.add(value);
    } else {
      _themeModeController.sink.add(ThemePacket.defaultTheme);
      box.put('themePacket', ThemePacket.defaultTheme);
    }
    _themeModeController.listen((value) {
      box.put('themePacket', value);
    });
  }

  static final _themeModeController = BehaviorSubject<ThemePacket>();

  /// will enable light mode
  void enableLightTheme() => _themeModeController.sink
      .add(_themeModeController.value.copyWith(themeMode: ThemeMode.light));

  /// will enable system mode
  void enableSystemTheme() => _themeModeController.sink
      .add(_themeModeController.value.copyWith(themeMode: ThemeMode.system));

  /// changes theme scheme of the application
  void changeTheme(FlexScheme flexScheme) => _themeModeController.sink
      .add(_themeModeController.value.copyWith(flexScheme: flexScheme));

  /// will enable dark theme
  void enableDarkTheme() => _themeModeController.sink
      .add(_themeModeController.value.copyWith(themeMode: ThemeMode.dark));

  void revertToDefaultColors() =>
      _themeModeController.sink.add(ThemePacket.defaultTheme);

  /// current theme of the application
  Stream<ThemePacket> get themeModeStream => _themeModeController.stream;

  /// initial data for the current theme of the application
  ThemePacket get themeModeInitialData =>
      _themeModeController.valueOrNull ?? ThemePacket.defaultTheme;
}
