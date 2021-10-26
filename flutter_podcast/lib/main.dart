import 'package:flutter/material.dart';

import 'home/home.dart';
import 'services/theme_service.dart';

void main() {
  runApp(
    const FlutterPodcast(),
  );
}

class FlutterPodcast extends StatelessWidget {
  const FlutterPodcast({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ThemePacket>(
      stream: ThemeService.themeModeStream,
      initialData: ThemeService.themeModeInitialData,
      builder: (context, snapshot) {
        final ThemePacket packet = snapshot.data ?? ThemePacket.defaultTheme;
        return MaterialApp(
          home: const Home(),
          debugShowCheckedModeBanner: false,
          themeMode: packet.themeMode,
          theme: ThemeData.light().copyWith(
            primaryColor: packet.primaryColor,
            accentColor: packet.accentColor,
            pageTransitionsTheme: _pageTransitionTheme,
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: packet.primaryColor,
            accentColor: packet.accentColor,
            pageTransitionsTheme: _pageTransitionTheme,
          ),
        );
      },
    );
  }
}

const _pageTransitionTheme = PageTransitionsTheme(
  builders: {
    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.fuchsia: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
  },
);
