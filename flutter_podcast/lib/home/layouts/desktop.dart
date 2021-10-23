import 'package:flutter/material.dart';
import 'package:flutter_podcast/home/home.dart';
import 'package:flutter_podcast/home/home_drawer.dart';
import 'package:flutter_podcast/home/home_navigation.dart';
import 'package:flutter_podcast/home/layouts/home_tablet.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomeDesktop extends StatelessWidget {
  final HomeDrawer homeDrawer;
  final HomeIndexedStack homeIndexedStack;
  final HomeNavigation homeNavigation;
  const HomeDesktop({
    Key? key,
    required this.homeDrawer,
    required this.homeIndexedStack,
    required this.homeNavigation,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OrientationLayoutBuilder(
      portrait: (cotext) => HomeTablet(
        homeIndexedStack: homeIndexedStack,
        homeDrawer: homeDrawer,
        homeNavigation: homeNavigation,
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
