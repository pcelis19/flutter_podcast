import 'package:flutter/material.dart';
import 'package:flutter_podcast/home/home_navigation.dart';
import 'package:flutter_podcast/home/layouts/desktop.dart';
import 'package:flutter_podcast/home/layouts/mobile.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  final homeNavigation = HomeNavigation();
  @override
  Widget build(BuildContext context) {
    final bool showDesktop =
        ResponsiveValue<bool>(context, defaultValue: false, valueWhen: const [
              Condition.largerThan(name: TABLET, value: true),
            ]).value ??
            false;

    if (showDesktop) {
      return HomeDesktop(
        homeNavigation: homeNavigation,
      );
    } else {
      return const HomeMobile();
    }
  }
}
