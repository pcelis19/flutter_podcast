import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_podcast/services/auth_service.dart';
import 'package:flutter_podcast/router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'services/theme_service.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(ThemePacketAdapter());
  runApp(const FlutterPodcastApp());
}

class FlutterPodcastApp extends StatefulWidget {
  ///
  const FlutterPodcastApp({Key? key}) : super(key: key);

  @override
  State<FlutterPodcastApp> createState() => _FlutterPodcastAppState();
}

class _FlutterPodcastAppState extends State<FlutterPodcastApp> {
  /// most recent router for the application
  final FlutterPodcastMainRouter _mainRouter =
      FlutterPodcastMainRouter(AuthService.instance);

  ///
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ThemePacket>(
      stream: ThemeService.instance.themeModeStream,
      initialData: ThemeService.instance.themeModeInitialData,
      builder: (context, snapshot) {
        final ThemePacket packet = snapshot.data ?? ThemePacket.defaultTheme;
        return MaterialApp.router(
          routeInformationParser: _mainRouter.router.routeInformationParser,
          routerDelegate: _mainRouter.router.routerDelegate,
          debugShowCheckedModeBanner: false,
          themeMode: packet.themeMode,
          theme: snapshot.data?.lightMode.copyWith(
            textTheme: GoogleFonts.interTextTheme(),
          ),
          darkTheme: snapshot.data?.darkMode.copyWith(
            textTheme: GoogleFonts.interTextTheme(
                ThemeData(brightness: Brightness.dark).textTheme),
            pageTransitionsTheme: pageTransitionTheme,
          ),
        );
      },
    );
  }
}
