import 'package:flutter/material.dart';
import 'package:flutter_podcast/global_player/global_player.dart';
import 'package:flutter_podcast/home/home.dart';
import 'package:flutter_podcast/home/home_drawer.dart';
import 'package:flutter_podcast/home/home_navigation.dart';

const duration = Duration(milliseconds: 600);

class HomeMobile extends StatelessWidget {
  final HomeDrawer homeDrawer;
  final HomeIndexedStack homeIndexedStack;
  final HomeNavigation homeNavigation;
  final GlobalPlayer globalPlayer;
  const HomeMobile({
    Key? key,
    required this.homeDrawer,
    required this.homeIndexedStack,
    required this.homeNavigation,
    required this.globalPlayer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(
          homeNavigation: homeNavigation,
        ),
      ),
      drawer: homeDrawer,
      body: Column(
        children: [
          Expanded(child: homeIndexedStack),
          SizedBox(
            height: 1.5 * kToolbarHeight,
            child: globalPlayer,
          ),
        ],
      ),
    );
  }
}

class AppBarTitle extends StatelessWidget {
  final HomeNavigation homeNavigation;
  const AppBarTitle({Key? key, required this.homeNavigation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: homeNavigation.currentViewStream
          .map((event) => HomeNavigation.indexToTitle(event)),
      initialData:
          HomeNavigation.indexToTitle(homeNavigation.currentViewInitialData),
      builder: (context, snapshot) => AnimatedSwitcher(
        duration: duration,
        child: Text(
          snapshot.data ?? '',
          key: ValueKey<String>(snapshot.data ?? ''),
        ),
      ),
    );
  }
}
