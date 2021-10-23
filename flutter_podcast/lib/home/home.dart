import 'package:flutter/material.dart';
import 'package:flutter_podcast/home/home_drawer.dart';
import 'package:flutter_podcast/home/home_navigation.dart';
import 'package:flutter_podcast/home/layouts/desktop.dart';
import 'package:flutter_podcast/home/layouts/mobile.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'layouts/home_tablet.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final homeNavigation = HomeNavigation();

  late final HomeIndexedStack homeIndexedStack;
  late final HomeDrawer homeDrawer;

  @override
  void initState() {
    super.initState();
    homeIndexedStack = HomeIndexedStack(homeNavigation: homeNavigation);
    homeDrawer = HomeDrawer(homeNavigation: homeNavigation);
  }

  @override
  void dispose() {
    homeNavigation.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        switch (info.deviceScreenType) {
          case DeviceScreenType.mobile:
            return HomeMobile(
              homeIndexedStack: homeIndexedStack,
              homeDrawer: homeDrawer,
              homeNavigation: homeNavigation,
            );
          case DeviceScreenType.tablet:
            return HomeTablet(
              homeIndexedStack: homeIndexedStack,
              homeDrawer: homeDrawer,
              homeNavigation: homeNavigation,
            );
          case DeviceScreenType.desktop:
            return HomeDesktop(
              homeDrawer: homeDrawer,
              homeIndexedStack: homeIndexedStack,
              homeNavigation: homeNavigation,
            );

          default:
            return HomeMobile(
              homeDrawer: homeDrawer,
              homeIndexedStack: homeIndexedStack,
              homeNavigation: homeNavigation,
            );
        }
      },
    );
  }
}

class HomeIndexedStack extends StatelessWidget {
  final HomeNavigation homeNavigation;
  const HomeIndexedStack({Key? key, required this.homeNavigation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: homeNavigation.currentViewStream,
      initialData: homeNavigation.currentViewInitialData,
      builder: (context, snapshot) => IndexedStack(
        children: homeNavigation.views,
        index: snapshot.data,
      ),
    );
  }
}
