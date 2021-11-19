import 'package:flutter/material.dart';
import 'package:flutter_podcast/utils/constants.dart';
import 'package:flutter_podcast/widgets/global_player.dart';

import '../home.dart';
import '../home_drawer.dart';
import '../home_navigation.dart';

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
        duration: duration600ms,
        child: Text(
          snapshot.data ?? '',
          key: ValueKey<String>(snapshot.data ?? ''),
        ),
      ),
    );
  }
}
