import 'package:flutter/material.dart';
import 'package:flutter_podcast/auth_service/auth_service.dart';

import 'home/home.dart';
import 'services/theme_service.dart';
import 'widgets/constants.dart';

void main() {
  runApp(
    const EntryPoint(),
  );
}

class EntryPoint extends StatelessWidget {
  const EntryPoint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FlutterPodcastUser?>(
      stream: AuthService.userStream,
      initialData: AuthService.user,
      builder: (context, snapshot) {
        FlutterPodcastUser? currentUser = snapshot.data;
        final routeInformationParser = _getRouteInformationParser(currentUser);
        final routerDelegate = _getRouterDelegate(currentUser);

        return MaterialApp.router(
          routeInformationParser: routeInformationParser,
          routerDelegate: routerDelegate,
        );
      },
    );
  }

  /// if currentUser is null
  ///   then the page list should be
  /// * Welcome
  /// * Login -> success login, return value should be else PageList
  /// * Sign up -> success sign up, return value should be else PageList
  /// else if currentUser is not null
  ///   then the page list should be
  /// * FlutterPodcast -> on sign out, return value should be first if block
  RouteInformationParser<Object> _getRouteInformationParser(
      FlutterPodcastUser? flutterPodcastUser) {}
  RouterDelegate<Object> _getRouterDelegate(
      FlutterPodcastUser? flutterPodcastUser) {}
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
            pageTransitionsTheme: pageTransitionTheme,
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: packet.primaryColor,
            accentColor: packet.accentColor,
            pageTransitionsTheme: pageTransitionTheme,
          ),
        );
      },
    );
  }
}
