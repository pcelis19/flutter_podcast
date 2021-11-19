import 'package:flutter/material.dart';
import 'package:flutter_podcast/widgets/global_player.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../home.dart';
import '../home_drawer.dart';
import '../home_navigation.dart';
import 'home_tablet.dart';

class HomeDesktop extends StatelessWidget {
  final HomeDrawer homeDrawer;
  final HomeIndexedStack homeIndexedStack;
  final HomeNavigation homeNavigation;
  final GlobalPlayer globalPlayer;
  const HomeDesktop({
    Key? key,
    required this.homeDrawer,
    required this.homeIndexedStack,
    required this.homeNavigation,
    required this.globalPlayer,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OrientationLayoutBuilder(
      portrait: (context) => HomeTablet(
        homeIndexedStack: homeIndexedStack,
        homeDrawer: homeDrawer,
        homeNavigation: homeNavigation,
        globalPlayer: globalPlayer,
      ),
      landscape: (context) => Row(
        children: [
          homeDrawer,
          Expanded(
            child: Scaffold(
              body: homeIndexedStack,
            ),
          )
        ],
      ),
    );
  }
}
