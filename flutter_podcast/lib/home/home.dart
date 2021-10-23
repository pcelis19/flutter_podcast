import 'package:flutter/material.dart';
import 'package:flutter_podcast/home/home_navigation.dart';
import 'package:flutter_podcast/home/layouts/desktop.dart';
import 'package:flutter_podcast/home/layouts/mobile.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'layouts/home_tablet.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key) {
    homeIndexedStack = HomeIndexedStack(homeNavigation: homeNavigation);
  }
  late final HomeIndexedStack homeIndexedStack;

  final homeNavigation = HomeNavigation();
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        switch (info.deviceScreenType) {
          case DeviceScreenType.mobile:
            return HomeMobile();
          case DeviceScreenType.tablet:
            return HomeTablet();
          case DeviceScreenType.desktop:
            return HomeDesktop(
              homeIndexedStack: homeIndexedStack,
              homeNavigation: homeNavigation,
            );

          default:
            return HomeMobile();
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
