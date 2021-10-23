import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'home_navigation.dart';

class HomeDrawer extends StatelessWidget {
  final Stream<String> currentHomeRouteStream;
  final String currentHomeInitialData;
  final GlobalKey<NavigatorState> navigatorStateKey;
  const HomeDrawer({
    Key? key,
    required this.currentHomeRouteStream,
    required this.currentHomeInitialData,
    required this.navigatorStateKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      initialData: currentHomeInitialData,
      stream: currentHomeRouteStream,
      builder: (_, snapshot) {
        String currentRoute = snapshot.data ?? '';
        return Drawer(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.home),
                      title: const Text('Home'),
                      selected: currentRoute == HomeNavigation.kHome,
                      onTap: currentRoute == HomeNavigation.kHome
                          ? null
                          : () => navigatorStateKey.currentState?.popUntil(
                              (route) =>
                                  route.settings.name == HomeNavigation.kHome),
                    ),
                    ResponsiveVisibility(
                      hiddenWhen: const [
                        Condition.smallerThan(name: DESKTOP),
                      ],
                      child: HomeNavItem(
                        iconData: Icons.arrow_circle_up_rounded,
                        label: 'Top Podcasts',
                        routeTo: HomeNavigation.kTopPodcasts,
                        currentRoute: currentRoute,
                        navigatorStateKey: navigatorStateKey,
                      ),
                    ),
                    HomeNavItem(
                      iconData: Icons.settings,
                      label: 'Settings',
                      routeTo: HomeNavigation.kSettings,
                      currentRoute: currentRoute,
                      navigatorStateKey: navigatorStateKey,
                    ),
                  ],
                ),
              ),
              const Center(
                child: Text('Flutter Podcast'),
              ),
              const Center(
                child: Text('Built with Flutter'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class HomeNavItem extends StatelessWidget {
  final IconData iconData;
  final String label;
  final String routeTo;
  final String currentRoute;
  final GlobalKey<NavigatorState> navigatorStateKey;
  const HomeNavItem(
      {Key? key,
      required this.iconData,
      required this.label,
      required this.routeTo,
      required this.currentRoute,
      required this.navigatorStateKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(iconData),
      title: Text(label),
      selected: currentRoute == routeTo,
      onTap: currentRoute == routeTo
          ? null
          : () => navigatorStateKey.currentState?.pushNamed(routeTo),
    );
  }
}
