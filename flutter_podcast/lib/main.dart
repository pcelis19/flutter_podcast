import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_podcast/auth_service/auth_service.dart';
import 'package:flutter_podcast/sign_in_out/sign_in_out.dart';
import 'package:flutter_podcast/welcome/welcome.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home/home.dart';
import 'services/theme_service.dart';
import 'widgets/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    StreamBuilder<FlutterPodcastMainRouter>(
      stream: AuthService.userStream
          .map((event) => FlutterPodcastMainRouter(event)),
      initialData: FlutterPodcastMainRouter(AuthService.user),
      builder: (context, snapshot) {
        final mainRouter = snapshot.data ?? FlutterPodcastMainRouter(null);
        return EntryPoint(
          mainRouter: mainRouter,
        );
      },
    ),
  );
}

class EntryPoint extends StatefulWidget {
  final FlutterPodcastMainRouter mainRouter;
  const EntryPoint({Key? key, required this.mainRouter}) : super(key: key);

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  late FlutterPodcastMainRouter _mainRouter;
  @override
  void initState() {
    super.initState();
    _mainRouter = widget.mainRouter;
  }

  @override
  void didUpdateWidget(covariant EntryPoint oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.mainRouter.flutterPodcastUser !=
        widget.mainRouter.flutterPodcastUser) {
      setState(() {
        _mainRouter = widget.mainRouter;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ThemePacket>(
      stream: ThemeService.themeModeStream,
      initialData: ThemeService.themeModeInitialData,
      builder: (context, snapshot) {
        final ThemePacket packet = snapshot.data ?? ThemePacket.defaultTheme;
        return MaterialApp.router(
          routeInformationParser: _mainRouter.routerInformationParser,
          routerDelegate: _mainRouter.routerDelegate,
          debugShowCheckedModeBanner: false,
          themeMode: packet.themeMode,
          theme: ThemeData.light().copyWith(
            textTheme: GoogleFonts.interTextTheme(),
            primaryColor: packet.primaryColor,
            accentColor: packet.accentColor,
            pageTransitionsTheme: pageTransitionTheme,
          ),
          darkTheme: ThemeData.dark().copyWith(
            textTheme: GoogleFonts.interTextTheme(),
            primaryColor: packet.primaryColor,
            accentColor: packet.accentColor,
            pageTransitionsTheme: pageTransitionTheme,
          ),
        );
      },
    );
  }
}

// class FlutterPodcast extends StatelessWidget {
//   const FlutterPodcast({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<ThemePacket>(
//       stream: ThemeService.themeModeStream,
//       initialData: ThemeService.themeModeInitialData,
//       builder: (context, snapshot) {
//         final ThemePacket packet = snapshot.data ?? ThemePacket.defaultTheme;
//         return MaterialApp(
//           home: const Home(),
//           debugShowCheckedModeBanner: false,
//           themeMode: packet.themeMode,
//           theme: ThemeData.light().copyWith(
//             primaryColor: packet.primaryColor,
//             accentColor: packet.accentColor,
//             pageTransitionsTheme: pageTransitionTheme,
//           ),
//           darkTheme: ThemeData.dark().copyWith(
//             primaryColor: packet.primaryColor,
//             accentColor: packet.accentColor,
//             pageTransitionsTheme: pageTransitionTheme,
//           ),
//         );
//       },
//     );
//   }
// }

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
              child: const SignInOut(
                signTypeScreen: SignTypeScreen.sign_up,
                showOtherSignScreen: true,
              ),
            ),
          ),
        )
        ..add(
          GoRoute(
            path: signIn,
            pageBuilder: (_, state) => MaterialPage(
              key: state.pageKey,
              child: const SignInOut(
                signTypeScreen: SignTypeScreen.sign_in,
                showOtherSignScreen: true,
              ),
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
      initialLocation: flutterPodcastUser == null ? defaultRoute : home,
      errorPageBuilder: (_, __) => const MaterialPage(
        child: Material(
          child: Center(
            child: Text((kIsWeb ? '(404): ' : '') + 'Page Not Found'),
          ),
        ),
      ),
    );
  }
  RouteInformationParser<Uri> get routerInformationParser =>
      _router.routeInformationParser;
  RouterDelegate<Uri> get routerDelegate => _router.routerDelegate;
}
/*
Some Discord Help
```dart
 // redirect to the login page if the user is not logged in
    redirect: (state) {
      final loggedIn = loginInfo.loggedIn;
      final goingToLogin = state.location == '/login';

      // the user is not logged in and not headed to /login, they need to login
      if (!loggedIn && !goingToLogin) return '/login';

      // the user is logged in and headed to /login, no need to login again
      if (loggedIn && goingToLogin) return '/';

      // no need to redirect at all
      return null;
    },
```
https://github.com/csells/go_router/#top-level-redirection
*/