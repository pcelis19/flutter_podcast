import 'package:flutter/material.dart';
import 'package:flutter_podcast/home/home_drawer.dart';
import 'package:flutter_podcast/home/home_navigation.dart';

class HomeDesktop extends StatelessWidget {
  final HomeNavigation homeNavigation;
  const HomeDesktop({
    Key? key,
    required this.homeNavigation,
  }) : super(key: key);
  static final navigatorStateKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 200,
          child: HomeDrawer(
            currentHomeRouteStream: homeNavigation.currentRouteStream,
            currentHomeInitialData: homeNavigation.currentRouteInitialData,
            navigatorStateKey: navigatorStateKey,
          ),
        ),
        Expanded(
          child: Navigator(
            key: navigatorStateKey,
            initialRoute: homeNavigation.initialRoute,
            onGenerateRoute: homeNavigation.onGenerateRoute,
          ),
        )
      ],
    );
  }
}
