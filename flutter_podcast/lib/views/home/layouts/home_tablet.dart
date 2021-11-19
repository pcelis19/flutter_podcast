import 'package:flutter/material.dart';
import 'package:flutter_podcast/widgets/global_player.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../home.dart';
import '../home_drawer.dart';
import '../home_navigation.dart';
import 'desktop.dart';
import 'mobile.dart';

class HomeTablet extends StatelessWidget {
  final HomeDrawer homeDrawer;
  final HomeIndexedStack homeIndexedStack;
  final HomeNavigation homeNavigation;
  final GlobalPlayer globalPlayer;
  const HomeTablet({
    Key? key,
    required this.homeIndexedStack,
    required this.homeDrawer,
    required this.homeNavigation,
    required this.globalPlayer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationLayoutBuilder(
      portrait: (context) => HomeMobile(
        homeDrawer: homeDrawer,
        homeIndexedStack: homeIndexedStack,
        homeNavigation: homeNavigation,
        globalPlayer: globalPlayer,
      ),
      landscape: (context) => HomeDesktop(
        homeDrawer: homeDrawer,
        homeIndexedStack: homeIndexedStack,
        homeNavigation: homeNavigation,
        globalPlayer: globalPlayer,
      ),
    );
  }
}
