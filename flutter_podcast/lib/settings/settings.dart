import 'package:flutter/material.dart';
import 'package:flutter_podcast/services/theme_service.dart';
import 'package:flutter_podcast/utils/theme_utils.dart';
import 'package:settings_ui/settings_ui.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SettingsList(
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
                  showGeneralDialog<MaterialColor>(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: 'Choose a Primary Color',
                    pageBuilder: (_, animation, pageBuilderAnimation) {
                      return FadeTransition(
                        opacity: animation,
                        child: AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Choose a Primary Color',
                              ),
                              Wrap(
                                children: Colors.primaries
                                    .map(
                                      (e) => IconButton(
                                        onPressed: () =>
                                            Navigator.pop(context, e),
                                        icon: CircleAvatar(
                                          backgroundColor: e,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel'),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ).then((value) {
                    if (value != null) {
                      ThemeService.changePrimaryColor(value);
                    }
                  });
                },
              ),
              SettingsTile(
                title: 'Accent Color',
                trailing: CircleAvatar(
                  backgroundColor: Theme.of(context).accentColor,
                ),
                onPressed: (context) {
                  showGeneralDialog<MaterialAccentColor>(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: 'Choose an Accent Color',
                    pageBuilder: (_, animation, pageBuilderAnimation) {
                      return FadeTransition(
                        opacity: animation,
                        child: AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Choose an Accent Color',
                              ),
                              Wrap(
                                children: Colors.accents
                                    .map((e) => IconButton(
                                          onPressed: () => Navigator.pop<
                                              MaterialAccentColor>(context, e),
                                          icon: CircleAvatar(
                                            backgroundColor: e,
                                          ),
                                        ))
                                    .toList(),
                              ),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel'),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ).then(
                    (value) {
                      if (value != null) {
                        ThemeService.changeAccentColor(value);
                      }
                    },
                  );
                },
              ),
              SettingsTile.switchTile(
                title: 'Default Colors',
                onToggle: (enabled) {
                  if (enabled) {
                    ThemeService.revertToDefaultColors();
                  }
                },
                switchValue: Theme.of(context).primaryColor ==
                        ThemePacket.defaultTheme.primaryColor &&
                    Theme.of(context).accentColor ==
                        ThemePacket.defaultTheme.accentColor,
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
      ),
    );
  }
}
