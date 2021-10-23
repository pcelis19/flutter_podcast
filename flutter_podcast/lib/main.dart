import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:rxdart/subjects.dart';

import 'home/home.dart';

void main() {
  runApp(FlutterPodcast());
}

class FlutterPodcast extends StatelessWidget {
  FlutterPodcast({Key? key}) : super(key: key);
  final globalRouter = GlobalRouter(GlobalRouter.kHome);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: globalRouter.initialRoute,
      onGenerateRoute: globalRouter.onGenerateRoute,
      builder: (_, child) => ResponsiveWrapper.builder(
        child,
        breakpoints: const [
          ResponsiveBreakpoint.resize(350, name: MOBILE),
          ResponsiveBreakpoint.autoScale(600, name: TABLET),
          ResponsiveBreakpoint.resize(800, name: DESKTOP),
        ],
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GlobalRouter {
  static const String kDefault = '/';
  static const String kHome = '/';

  /// the initial route of the global router
  final String initialRoute;

  /// keeps track of the current route
  final _currentRouteController = BehaviorSubject<String>();

  GlobalRouter(this.initialRoute) {
    _currentRouteController.sink.add(initialRoute);
  }

  /// Stream of the current route
  Stream<String> get currentRouteStream => _currentRouteController.stream;

  /// initial data for the current route
  String get currentRouteInitialData => _currentRouteController.value;

  dispose() => _currentRouteController.close();

  MaterialPageRoute onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case kHome:
        return MaterialPageRoute(builder: (_) => Home());
      default:
        return MaterialPageRoute(builder: (_) => Home());
    }
  }
}
