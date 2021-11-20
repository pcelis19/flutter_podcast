import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_podcast/services/theme_service.dart';
import 'package:flutter_podcast/utils/constants.dart';
import 'package:flutter_podcast/utils/theme_utils.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:basic_utils/basic_utils.dart' as basicUtils;

class Settings extends StatelessWidget {
  const Settings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<ThemePacket>(
          stream: ThemeService.themeModeStream,
          initialData: ThemeService.themeModeInitialData,
          builder: (context, snapshot) {
            return SettingsList(
              backgroundColor: Colors.transparent,
              darkBackgroundColor: Colors.transparent,
              lightBackgroundColor: Colors.transparent,
              sections: [
                SettingsSection(
                  title: 'Theme & Colors',
                  tiles: [
                    SettingsTile.switchTile(
                      title: 'Enable Dark Mode',
                      onToggle: (value) {
                        if (isLightMode(context)) {
                          ThemeService.enableDarkTheme();
                        } else {
                          ThemeService.enableLightTheme();
                        }
                      },
                      switchValue: !isLightMode(context),
                    ),
                    SettingsTile(
                      title: 'Theme Scheme',
                      subtitle: spaceCamelCase((snapshot.data?.flexScheme ??
                              ThemePacket.defaultTheme)
                          .toString()
                          .substring(11)),
                      trailing: ThemePreviewColors(
                        themeMode: snapshot.data?.themeMode ?? ThemeMode.system,
                        scheme: snapshot.data?.flexScheme ??
                            ThemePacket.defaultTheme.flexScheme,
                      ),
                      onPressed: (context) {
                        showGeneralDialog<FlexScheme>(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: 'Choose a Theme Scheme',
                          pageBuilder: (_, animation, pageBuilderAnimation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SimpleDialog(
                                title: const Text(
                                  'Choose a Theme Scheme',
                                ),
                                children: <Widget>[
                                  ListTile(
                                    title: const Text('Theme Scheme'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        ModeLabel(
                                          themeMode: ThemeMode.light,
                                        ),
                                        w8SizedBox,
                                        ModeLabel(
                                          themeMode: ThemeMode.dark,
                                        ),
                                      ],
                                    ),
                                  ),
                                ]..addAll(FlexScheme.values
                                    .map<Widget>(
                                      (e) => ListTile(
                                        onTap: () => Navigator.pop(context, e),
                                        title: Text(
                                          spaceCamelCase(
                                              e.toString().substring(11)),
                                        ),
                                        selected:
                                            e == snapshot.data?.flexScheme,
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ThemePreviewColors(
                                              themeMode: ThemeMode.light,
                                              scheme: e,
                                            ),
                                            w8SizedBox,
                                            ThemePreviewColors(
                                              themeMode: ThemeMode.dark,
                                              scheme: e,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList()),
                              ),
                            );
                          },
                        ).then((value) {
                          if (value != null) {
                            ThemeService.changeTheme(value);
                          }
                        });
                      },
                    ),
                    SettingsTile.switchTile(
                      title: 'Default Theme',
                      onToggle: (enabled) {
                        if (enabled) {
                          ThemeService.revertToDefaultColors();
                        }
                      },
                      switchValue: snapshot.data?.flexScheme ==
                          ThemePacket.defaultTheme.flexScheme,
                    ),
                  ],
                ),
                SettingsSection(
                  title: 'Storage',
                  tiles: const [
                    SettingsTile(
                      title: 'Max Podcast Cache',
                      trailing: CircleAvatar(
                        child: Text('5'),
                      ),
                    ),
                  ],
                )
              ],
            );
          }),
    );
  }

  String spaceCamelCase(String original) => basicUtils.StringUtils.capitalize(
      basicUtils.StringUtils.camelCaseToUpperUnderscore(original)
          .replaceAll("_", " "),
      allWords: true);
}

class ModeLabel extends StatelessWidget {
  final ThemeMode themeMode;
  const ModeLabel({
    Key? key,
    required this.themeMode,
  }) : super(key: key);
  String get _title {
    switch (themeMode) {
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
    }
  }

  Color get _backgroundColor {
    switch (themeMode) {
      case ThemeMode.system:
        return Colors.grey;
      case ThemeMode.light:
        return Colors.white;
      case ThemeMode.dark:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: _backgroundColor,
      child: SizedBox(
        width: 32,
        child: Center(
          child: Text(
            _title,
            style: TextStyle(
              fontWeight: Theme.of(context).textTheme.caption?.fontWeight,
              fontSize: Theme.of(context).textTheme.caption?.fontSize,
            ),
          ),
        ),
      ),
    );
  }
}

class ThemePreviewColors extends StatelessWidget {
  final ThemeMode themeMode;
  final FlexScheme scheme;
  const ThemePreviewColors(
      {Key? key, required this.themeMode, required this.scheme})
      : super(key: key);
  ThemeData get flexThemeData {
    switch (themeMode) {
      case ThemeMode.system:
        return FlexThemeData.light(scheme: scheme);
      case ThemeMode.light:
        return FlexThemeData.light(scheme: scheme);
      case ThemeMode.dark:
        return FlexThemeData.dark(scheme: scheme);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        height: 32,
        width: 32,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: flexThemeData.colorScheme.primary,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: flexThemeData.colorScheme.primaryVariant,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: flexThemeData.colorScheme.secondary,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: flexThemeData.colorScheme.secondaryVariant,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
