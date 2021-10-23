import 'package:flutter/material.dart';
import 'package:flutter_podcast/dashboard/dashboard.dart';
import 'package:flutter_podcast/favorite_podcasts/favorite_podcasts.dart';
import 'package:flutter_podcast/settings/settings.dart';
import 'package:flutter_podcast/top_podcasts/top_podcasts.dart';
import 'package:rxdart/rxdart.dart';

class HomeNavigation {
  final _currentViewController = BehaviorSubject<int>();
  final List<Widget> views = const [
    Dashboard(),
    TopPodcasts(),
    FavoritePodcasts(),
    Settings(),
  ];
  HomeNavigation() {
    _currentViewController.sink.add(0);
  }

  /// will set the current of the avaialble views, see [this.views], if
  /// index is out of index, then will throw
  void setCurrentView(int nextViewIndex) {
    if (nextViewIndex < views.length) {
      _currentViewController.sink.add(nextViewIndex);
    } else {
      throw 'invalid nextViewIndex';
    }
  }

  Stream<int> get currentViewStream => _currentViewController.stream;
  int get currentViewInitialData => _currentViewController.value;
}
