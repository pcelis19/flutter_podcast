import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  final Stream<String> currentHomeRouteStream;
  final String currentHomeInitialData;
  final HomeNavigation homeNavigation;
  const HomeDrawer(
      {Key? key,
      required this.currentHomeRouteStream,
      required this.currentHomeInitialData})
      : super(key: key);

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
                    children: [ListTil],
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
        });
  }
}
