import 'package:flutter/material.dart';
import 'package:flutter_podcast/home/home.dart';
import 'package:flutter_podcast/home/home_drawer.dart';
import 'package:flutter_podcast/home/home_navigation.dart';

const duration = Duration(milliseconds: 600);

class HomeMobile extends StatelessWidget {
  final HomeDrawer homeDrawer;
  final HomeIndexedStack homeIndexedStack;
  final HomeNavigation homeNavigation;
  const HomeMobile({
    Key? key,
    required this.homeDrawer,
    required this.homeIndexedStack,
    required this.homeNavigation,
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
      body: homeIndexedStack,
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
