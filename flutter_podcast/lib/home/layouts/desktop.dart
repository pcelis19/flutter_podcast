import 'package:flutter/material.dart';
import 'package:flutter_podcast/global_player/global_player.dart';
import 'package:flutter_podcast/home/home.dart';
import 'package:flutter_podcast/home/home_drawer.dart';
import 'package:flutter_podcast/home/home_navigation.dart';
import 'package:flutter_podcast/home/layouts/home_tablet.dart';
import 'package:responsive_builder/responsive_builder.dart';

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
      portrait: (cotext) => HomeTablet(
        homeIndexedStack: homeIndexedStack,
        homeDrawer: homeDrawer,
        homeNavigation: homeNavigation,
        globalPlayer: globalPlayer,
      ),
      landscape: (context) => Row(
        children: [
          SizedBox(
            width: 200,
            child: homeDrawer,
          ),
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
