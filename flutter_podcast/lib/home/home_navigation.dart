import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class HomeNavigation {
  static const kHome = '/';
  static const kFavorites = '/favorites';
  static const kTopPodcasts = '/top_podcasts';
  static const kSettings = '/settings';
  final String initialRoute = kHome;
  final _routeController = BehaviorSubject<String>();
  HomeNavigation() {
    _routeController.sink.add(initialRoute);
  }

  Stream<String> get currentRouteStream => _routeController.stream;
  String get currentRouteInitialData => _routeController.value;

  MaterialPageRoute? onGenerateRoute(RouteSettings settings) {
    _routeController.sink.add(settings.name ?? '');
    return MaterialPageRoute(builder: (context) {
      return Container(
        color: Colors.red,
      );
    });
  }
}
