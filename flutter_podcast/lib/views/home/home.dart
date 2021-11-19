import 'package:flutter/material.dart';
import 'package:flutter_podcast/services/audio_player_handler.dart';
import 'package:flutter_podcast/services/auth_service.dart';
import 'package:flutter_podcast/widgets/global_player.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'home_drawer.dart';
import 'home_navigation.dart';
import 'layouts/desktop.dart';
import 'layouts/home_tablet.dart';
import 'layouts/mobile.dart';

class Home extends StatefulWidget {
  final FlutterPodcastUser user;
  const Home({Key? key, required this.user}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final audioPlayer = AudioPlayerHandlerService();
  late final HomeNavigation homeNavigation;

  late final HomeIndexedStack homeIndexedStack;
  late final HomeDrawer homeDrawer;
  late final GlobalPlayer globalPlayer;

  @override
  void initState() {
    super.initState();
    homeNavigation = HomeNavigation(audioPlayer);
    homeIndexedStack = HomeIndexedStack(homeNavigation: homeNavigation);
    homeDrawer = HomeDrawer(
      homeNavigation: homeNavigation,
      user: widget.user,
    );
    globalPlayer = GlobalPlayer(
      audioPlayer: audioPlayer,
    );
  }

  @override
  void dispose() {
    homeNavigation.dispose();
    audioPlayer.dispose();

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
              globalPlayer: globalPlayer,
            );
          case DeviceScreenType.tablet:
            return HomeTablet(
              homeIndexedStack: homeIndexedStack,
              homeDrawer: homeDrawer,
              homeNavigation: homeNavigation,
              globalPlayer: globalPlayer,
            );
          case DeviceScreenType.desktop:
            return HomeDesktop(
              homeDrawer: homeDrawer,
              homeIndexedStack: homeIndexedStack,
              homeNavigation: homeNavigation,
              globalPlayer: globalPlayer,
            );

          default:
            return HomeMobile(
              homeDrawer: homeDrawer,
              homeIndexedStack: homeIndexedStack,
              homeNavigation: homeNavigation,
              globalPlayer: globalPlayer,
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
