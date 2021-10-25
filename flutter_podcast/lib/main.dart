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
    return StreamBuilder<ThemeMode>(
      stream: ThemeService.themeModeStream,
      initialData: ThemeService.themeModeInitialData,
      builder: (context, snapshot) {
        return MaterialApp(
          home: const Home(),
          debugShowCheckedModeBanner: false,
          themeMode: snapshot.data,
          theme: ThemeData.light().copyWith(
            accentColor: Colors.pinkAccent,
            primaryColor: Colors.cyanAccent,
            pageTransitionsTheme: _pageTransitionTheme,
          ),
          darkTheme: ThemeData.dark().copyWith(
            accentColor: Colors.pinkAccent,
            primaryColor: Colors.cyanAccent,
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
