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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_podcast/views/sign_in_up.dart';
import 'package:flutter_podcast/views/welcome.dart';
import 'package:go_router/go_router.dart';

import 'services/auth_service.dart';
import 'views/home/home.dart';

class FlutterPodcastMainRouter {
  /// unauth routes
  static const _welcomeRoute = '/';

  static const _signUpRoute = 'sign_up';
  static const _signInRoute = 'sign_in';

  /// unauth names
  static const kWelcomeName = 'welcome';
  static const kSignUpName = 'sign up';
  static const kSignInName = 'sign in';

  /// auth routes
  static const _homeRoute = '/home';

  /// auth names
  static const kHomeName = 'home';

  /// router of application
  late final GoRouter router;

  /// auth service of the application
  final AuthService _authService;

  ///constructor
  FlutterPodcastMainRouter(AuthService authService)
      : _authService = authService {
    router = GoRouter(
      routes: [
        GoRoute(
          name: kHomeName,
          path: _homeRoute,
          pageBuilder: (_, state) => MaterialPage(
            key: state.pageKey,
            child: Home(
              user: authService.currentUser!,
            ),
          ),
        ),
        GoRoute(
          name: kWelcomeName,
          path: _welcomeRoute,
          pageBuilder: (_, state) => MaterialPage(
            key: state.pageKey,
            child: const Welcome(),
          ),
          routes: [
            GoRoute(
              name: kSignInName,
              path: _signInRoute,
              pageBuilder: (_, state) => MaterialPage(
                key: state.pageKey,
                child: const SignInOut(
                  signTypeScreen: SignTypeScreen.signIn,
                  showOtherSignScreen: true,
                ),
              ),
            ),
            GoRoute(
              name: kSignUpName,
              path: _signUpRoute,
              pageBuilder: (_, state) => MaterialPage(
                key: state.pageKey,
                child: const SignInOut(
                  signTypeScreen: SignTypeScreen.signUp,
                  showOtherSignScreen: true,
                ),
              ),
            ),
          ],
        ),
      ],
      redirect: (state) {
        bool isLoggedIn = authService.currentUser != null;
        bool isGoingToAuthRoute = _isAuthRoute(state.location);
        if (isLoggedIn && !isGoingToAuthRoute) {
          return _homeRoute;
        }
        if (!isLoggedIn && isGoingToAuthRoute) {
          return _welcomeRoute;
        }
      },
      refreshListenable: authService,
      initialLocation: _initialRoute(authService.currentUser),
      errorPageBuilder: (_, __) => const MaterialPage(
        child: PageNotFoundPage(),
      ),
    );
  }

  static String _initialRoute(FlutterPodcastUser? user) {
    if (user == null) {
      return _welcomeRoute;
    } else {
      return _homeRoute;
    }
  }

  static bool _isAuthRoute(String location) => [_homeRoute].contains(location);
}

class PageNotFoundPage extends StatelessWidget {
  final FlutterPodcastUser? user;
  const PageNotFoundPage({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SimpleDialog(
        title: Text(
          (kIsWeb ? '(404): ' : '') + 'Page Not Found',
          style: Theme.of(context).textTheme.headline1,
        ),
        children: [
          Center(
            child: TextButton(
                onPressed: () {
                  if (_isLoggedIn) {
                    context.goNamed(FlutterPodcastMainRouter.kHomeName);
                  } else {
                    context.goNamed(FlutterPodcastMainRouter.kWelcomeName);
                  }
                },
                child: Text(_isLoggedIn ? 'Go Home' : 'Go To Main Page')),
          )
        ],
      ),
    );
  }

  bool get _isLoggedIn => user != null;
}
