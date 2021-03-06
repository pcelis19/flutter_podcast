import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_podcast/services/theme_service.dart';
import 'package:flutter_podcast/utils/constants.dart';
import 'package:flutter_podcast/utils/theme_utils.dart';
import 'package:basic_utils/basic_utils.dart' as basic_utils;

class Settings extends StatelessWidget {
  const Settings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<ThemePacket>(
          stream: ThemeService.instance.themeModeStream,
          initialData: ThemeService.instance.themeModeInitialData,
          builder: (context, snapshot) {
            return ListView(
              // backgroundColor: Colors.transparent,
              // darkBackgroundColor: Colors.transparent,
              // lightBackgroundColor: Colors.transparent,
              children: [
                const Text('Theme & Colors'),
                SwitchListTile(
                  title: const Text('Enable Dark Mode'),
                  onChanged: (value) {
                    if (isLightMode(context)) {
                      ThemeService.instance.enableDarkTheme();
                    } else {
                      ThemeService.instance.enableLightTheme();
                    }
                  },
                  value: !isLightMode(context),
                ),
                ListTile(
                  title: const Text('Theme Scheme'),
                  subtitle: Text(_spaceCamelCase(
                      (snapshot.data?.flexScheme ?? ThemePacket.defaultTheme)
                          .toString()
                          .substring(11))),
                  trailing: ThemePreviewColors(
                    themeMode: snapshot.data?.themeMode ?? ThemeMode.system,
                    scheme: snapshot.data?.flexScheme ??
                        ThemePacket.defaultTheme.flexScheme,
                  ),
                  onTap: () {
                    showGeneralDialog<FlexScheme>(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: 'Choose a Theme Scheme',
                      pageBuilder: (_, animation, pageBuilderAnimation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ChooseThemeScheme(
                              currentScheme: snapshot.data?.flexScheme ??
                                  ThemePacket.defaultTheme.flexScheme),
                        );
                      },
                    ).then((value) {
                      if (value != null) {
                        ThemeService.instance.changeTheme(value);
                      }
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Default Theme'),
                  onChanged: (enabled) {
                    if (enabled) {
                      ThemeService.instance.revertToDefaultColors();
                    }
                  },
                  value: snapshot.data?.flexScheme ==
                      ThemePacket.defaultTheme.flexScheme,
                ),
              ],
            );
          }),
    );
  }
}

/// displays available themes, will pop with value that the user picks, can return null
class ChooseThemeScheme extends StatelessWidget {
  final FlexScheme currentScheme;
  const ChooseThemeScheme({Key? key, required this.currentScheme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
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
        ...FlexScheme.values
            .map<Widget>(
              (e) => ListTile(
                onTap: () => Navigator.pop(context, e),
                title: Text(
                  _spaceCamelCase(e.toString().substring(11)),
                ),
                selected: e == currentScheme,
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
            .toList(),
      ],
    );
  }
}

String _spaceCamelCase(String original) => basic_utils.StringUtils.capitalize(
    basic_utils.StringUtils.camelCaseToUpperUnderscore(original)
        .replaceAll("_", " "),
    allWords: true);

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
