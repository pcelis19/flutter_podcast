import 'package:flutter/material.dart';
import 'package:flutter_podcast/services/audio_player_handler.dart';
import 'package:flutter_podcast/services/auth_service.dart';
import 'package:flutter_podcast/views/dashboard.dart';
import 'package:flutter_podcast/views/favorite_podcasts.dart';
import 'package:flutter_podcast/views/settings.dart';
import 'package:flutter_podcast/views/top_podcasts.dart';
import 'package:rxdart/rxdart.dart';

class HomeNavigation {
  final _currentViewController = BehaviorSubject<int>();
  late final List<Widget> views;
  final FlutterPodcastUser user;
  HomeNavigation(AudioPlayerHandlerService audioPlayerHandler, this.user) {
    views = [
      Dashboard(
        user: user,
        audioPlayerHandler: audioPlayerHandler,
      ),
      const TopPodcasts(),
      const FavoritePodcasts(),
      const Settings(),
    ];
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

  /// stream of the curent index
  Stream<int> get currentViewStream => _currentViewController.stream;

  /// current initial data of the controller;

  int get currentViewInitialData => _currentViewController.value;

  /// util to convert the index to a Title
  static String indexToTitle(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Top Podcasts';
      case 2:
        return 'Favorites';
      case 3:
        return 'Settings';
      default:
        throw 'Unknown index';
    }
  }

  void dispose() {
    _currentViewController.close();
  }
}
