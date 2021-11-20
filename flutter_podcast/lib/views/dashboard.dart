import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_podcast/router.dart';
import 'package:flutter_podcast/services/audio_player_handler.dart';
import 'package:flutter_podcast/filtered_list_displayer/filtered_list_displayer.dart';
import 'package:flutter_podcast/services/auth_service.dart';
import 'package:flutter_podcast/utils/constants.dart';
import 'package:flutter_podcast/utils/theme_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';

const kFilterListTag = 'filter_list_tag';
const kFilterChoicesTag = 'filter_choices_tag';

class Dashboard extends StatefulWidget {
  final AudioPlayerHandlerService audioPlayerHandler;
  final FlutterPodcastUser user;
  const Dashboard(
      {Key? key, required this.audioPlayerHandler, required this.user})
      : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late final Widget filterChoices;
  late final Widget selectedFilteredItems;

  @override
  void initState() {
    super.initState();

    filterChoices = ListView(
      scrollDirection: Axis.horizontal,
      children: const [
        w16SizedBox,
        ListFilter(
          selected: true,
          label: '🔥  Popular',
        ),
        w16SizedBox,
        ListFilter(
          selected: false,
          label: 'Recent',
        ),
        w16SizedBox,
        ListFilter(
          selected: false,
          label: 'Music',
        ),
        w16SizedBox,
        ListFilter(
          selected: false,
          label: 'Design',
        ),
      ],
    );

    selectedFilteredItems = FilteredListDisplayer(
      audioPlayerHandler: widget.audioPlayerHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets edgeInsets;
    return ResponsiveBuilder(
      builder: (context, info) {
        if (info.isTablet) {
          edgeInsets = const EdgeInsets.symmetric(horizontal: 30);
        } else if (info.isDesktop) {
          edgeInsets = const EdgeInsets.symmetric(horizontal: 30, vertical: 10);
        } else {
          edgeInsets = const EdgeInsets.all(0);
        }
        return Column(
          children: [
            Padding(
              padding: edgeInsets,
              child: SizedBox(
                height: kToolbarHeight,
                child: Align(
                  alignment: Alignment.topRight,
                  child: ListTile(
                    onTap: () => context
                        .go(FlutterPodcastMainRouter.updateProfileDetailsRoute),
                    title: Text(
                      'Hello, ' + widget.user.userName,
                    ),
                    subtitle: const Text('Update your status!'),
                    trailing: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                  ),
                ),
              ),
            ),
            h32SizedBox,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                height: 300,
                child: Column(
                  children: [
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Categories'),
                          TextButton(
                            onPressed: () {},
                            child: const Text('See all'),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Material(
                        borderRadius: borderRadius40,
                        elevation: 16,
                        child: ClipRRect(
                          borderRadius: borderRadius40,
                          child: PageView(
                            scrollDirection: Axis.horizontal,
                            controller: PageController(
                                viewportFraction: .70, initialPage: 1),
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CategoryPlaylist(
                                  background: 'Music & Fun',
                                  foreground: 'Music & Fun',
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CategoryPlaylist(
                                  background: 'Life & Chill',
                                  foreground: 'Life & Chill',
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CategoryPlaylist(
                                  background: 'Programming',
                                  foreground: 'Programming',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            h32SizedBox,
            SizedBox(
              height: kToolbarHeight,
              child: Row(
                children: [
                  Expanded(
                    child: Hero(
                      tag: kFilterChoicesTag,
                      child: filterChoices,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            backgroundColor: Color.alphaBlend(
                              isLightMode(context)
                                  ? Colors.white38
                                  : Colors.black38,
                              Theme.of(context).scaffoldBackgroundColor,
                            ),
                            appBar: AppBar(),
                            body: Column(
                              children: [
                                h32SizedBox,
                                SizedBox(
                                  height: h32SizedBox.height,
                                  child: Hero(
                                    tag: kFilterChoicesTag,
                                    child: filterChoices,
                                  ),
                                ),
                                h32SizedBox,
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Hero(
                                      tag: kFilterListTag,
                                      child: selectedFilteredItems,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text('Expand'),
                  ),
                  w16SizedBox,
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Hero(
                  tag: kFilterListTag,
                  child: selectedFilteredItems,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ListFilter extends StatelessWidget {
  final bool selected;
  final String label;
  const ListFilter({
    Key? key,
    required this.selected,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Chip(
        elevation: selected ? 8 : null,
        backgroundColor: selected ? null : Colors.transparent,
        label: Text(label),
      ),
    );
  }
}

class CategoryPlaylist extends StatelessWidget {
  final String background;
  final String foreground;

  const CategoryPlaylist(
      {Key? key, required this.background, required this.foreground})
      : super(key: key);
  static Random random = Random();
  String get subtitle => "${random.nextInt(199) + 1} Podcast";
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: borderRadius20,
      elevation: 16,
      child: ClipRRect(
        borderRadius: borderRadius20,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Theme.of(context).accentColor,
                    Theme.of(context).primaryColor,
                  ],
                ),
              ),
              child: Center(
                child: Text(background),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 75,
                  color: isLightMode(context) ? Colors.white38 : Colors.black38,
                  child: ListTile(
                    title: Text(foreground),
                    subtitle: Text(subtitle),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
