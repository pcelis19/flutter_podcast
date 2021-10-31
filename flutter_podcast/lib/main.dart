import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_podcast/auth_service/auth_service.dart';
import 'package:flutter_podcast/sign_in/sign_in.dart';
import 'package:flutter_podcast/welcome/welcome.dart';
import 'package:go_router/go_router.dart';

import 'home/home.dart';
import 'services/theme_service.dart';
import 'sign_up/sign_up.dart';
import 'widgets/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
        final _mainRouter = FlutterPodcastMainRouter(currentUser);

        return MaterialApp.router(
          routeInformationParser: _mainRouter.routerInformationParser,
          routerDelegate: _mainRouter.routerDelegate,
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

class FlutterPodcastMainRouter {
  static const defaultRoute = '/';
  static const signUp = '/sign_up';
  static const signIn = '/sign_in';
  static const home = '/home';
  final FlutterPodcastUser? flutterPodcastUser;
  late GoRouter _router;
  FlutterPodcastMainRouter(this.flutterPodcastUser) {
    final routes = <GoRoute>[
      GoRoute(
        path: defaultRoute,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          child: const Welcome(),
        ),
      )
    ];

    if (flutterPodcastUser == null) {
      /// if user is null, then add sign up and sign in
      routes
        ..add(
          GoRoute(
            path: signUp,
            pageBuilder: (_, state) => MaterialPage(
              key: state.pageKey,
              child: const SignUp(),
            ),
          ),
        )
        ..add(
          GoRoute(
            path: signIn,
            pageBuilder: (_, state) => MaterialPage(
              key: state.pageKey,
              child: const SignIn(),
            ),
          ),
        );
    } else {
      /// else just Home on top of that
      routes.add(
        GoRoute(
          path: home,
          pageBuilder: (_, state) => MaterialPage(
            key: state.pageKey,
            child: const Home(),
          ),
        ),
      );
    }
    _router = GoRouter(
      routes: routes,
      errorPageBuilder: (_, __) => const MaterialPage(
        child: Center(
          child: Text((kIsWeb ? '(404): ' : '') + 'Page Not Found'),
        ),
      ),
    );
  }
  RouteInformationParser<Uri> get routerInformationParser =>
      _router.routeInformationParser;
  RouterDelegate<Uri> get routerDelegate => _router.routerDelegate;
}
