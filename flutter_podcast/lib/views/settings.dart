import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_podcast/services/theme_service.dart';
import 'package:flutter_podcast/utils/theme_utils.dart';
import 'package:settings_ui/settings_ui.dart';

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
                      title: 'Primary Color',
                      trailing: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
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
                                children: FlexScheme.values
                                    .map<Widget>(
                                      (e) => TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, e),
                                        child: Text(
                                          e.toString(),
                                        ),
                                      ),
                                    )
                                    .toList()
                                  ..add(Center(
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('Cancel'),
                                    ),
                                  )),
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
}
