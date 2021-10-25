import 'package:flutter/material.dart';
import 'package:flutter_podcast/services/theme_service.dart';

import 'home_navigation.dart';

class HomeDrawer extends StatelessWidget {
  final HomeNavigation homeNavigation;
  const HomeDrawer({
    Key? key,
    required this.homeNavigation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 16,
      child: StreamBuilder<int>(
        initialData: homeNavigation.currentViewInitialData,
        stream: homeNavigation.currentViewStream,
        builder: (_, snapshot) {
          int currentRoute = snapshot.data ?? -1;
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const DrawerHeader(
                      child: Center(
                        child: Text(
                          'Flutter Podcast',
                        ),
                      ),
                    ),
                    ListTile(
                      title: TextField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.search),
                          hintText: 'Search Podcast',
                          border: UnderlineInputBorder(),
                        ),
                        onSubmitted: (value) {
                          homeNavigation.setCurrentView(0);
                        },
                      ),
                    ),
                    HomeNavItem(
                      iconData: Icons.home,
                      label: 'Dashboard',
                      currentRoute: currentRoute,
                      routeTo: 0,
                      homeNavigation: homeNavigation,
                    ),
                    HomeNavItem(
                      iconData: Icons.arrow_circle_up_rounded,
                      label: 'Top Podcasts',
                      routeTo: 1,
                      currentRoute: currentRoute,
                      homeNavigation: homeNavigation,
                    ),
                    HomeNavItem(
                      iconData: Icons.arrow_circle_up_rounded,
                      label: 'Favorites',
                      routeTo: 2,
                      currentRoute: currentRoute,
                      homeNavigation: homeNavigation,
                    ),
                    HomeNavItem(
                      iconData: Icons.settings,
                      label: 'Settings',
                      routeTo: 3,
                      currentRoute: currentRoute,
                      homeNavigation: homeNavigation,
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(
                  isLightMode(context)
                      ? Icons.brightness_5
                      : Icons.brightness_3,
                ),
                title:
                    Text(isLightMode(context) ? 'Lights off?' : 'Lights on?'),
                onTap: () {
                  if (isLightMode(context)) {
                    ThemeService.enableDarkTheme();
                  } else {
                    ThemeService.enableLightTheme();
                  }
                },
              ),
              ListTile(
                title: Text(
                  'Built with Flutter',
                  style: Theme.of(context).textTheme.overline,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class HomeNavItem extends StatelessWidget {
  final IconData iconData;
  final String label;
  final int routeTo;
  final int currentRoute;
  final HomeNavigation homeNavigation;
  const HomeNavItem({
    Key? key,
    required this.iconData,
    required this.label,
    required this.routeTo,
    required this.currentRoute,
    required this.homeNavigation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(iconData),
      title: Text(label),
      selected: currentRoute == routeTo,
      onTap: currentRoute == routeTo
          ? null
          : () => homeNavigation.setCurrentView(routeTo),
    );
  }
}
