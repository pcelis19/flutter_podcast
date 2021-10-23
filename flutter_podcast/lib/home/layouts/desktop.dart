import 'package:flutter/material.dart';
import 'package:flutter_podcast/home/home.dart';
import 'package:flutter_podcast/home/home_drawer.dart';
import 'package:flutter_podcast/home/home_navigation.dart';

class HomeDesktop extends StatelessWidget {
  final HomeNavigation homeNavigation;
  final HomeIndexedStack homeIndexedStack;
  const HomeDesktop({
    Key? key,
    required this.homeNavigation,
    required this.homeIndexedStack,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 200,
          child: HomeDrawer(
            currentHomeRouteStream: homeNavigation.currentViewStream,
            currentHomeInitialData: homeNavigation.currentViewInitialData,
            homeNavigation: homeNavigation,
          ),
        ),
        Expanded(
          child: homeIndexedStack,
        )
      ],
    );
  }
}
