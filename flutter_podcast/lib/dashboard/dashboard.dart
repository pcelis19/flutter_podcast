import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_podcast/theme_service/theme_service.dart';
import 'package:flutter_podcast/widgets/constants.dart';
import 'package:flutter_podcast/widgets/podcast_list_displyer.dart';
import 'package:responsive_builder/responsive_builder.dart';

const kFilterListTag = 'filter_list_tag';
const kFilterChoicesTag = 'filter_choices_tag';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

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
        wSizedBox,
        ListFilter(
          selected: true,
          label: '🔥  Popular',
        ),
        wSizedBox,
        ListFilter(
          selected: false,
          label: 'Recent',
        ),
        wSizedBox,
        ListFilter(
          selected: false,
          label: 'Music',
        ),
        wSizedBox,
        ListFilter(
          selected: false,
          label: 'Design',
        ),
      ],
    );

    selectedFilteredItems = ListView(
      children: const [
        PodcastTile(
          title: 'Ngobam',
          artist: 'Gofar Hilman',
          genre: 'Music & Fun',
          episodes: 32,
        ),
        h8SizedBox,
        PodcastTile(
          title: 'Ngobam',
          artist: 'Gofar Hilman',
          genre: 'Music & Fun',
          episodes: 32,
        ),
        h8SizedBox,
        PodcastTile(
          title: 'Ngobam',
          artist: 'Gofar Hilman',
          genre: 'Music & Fun',
          episodes: 32,
        ),
        h8SizedBox,
        PodcastTile(
          title: 'Ngobam',
          artist: 'Gofar Hilman',
          genre: 'Music & Fun',
          episodes: 32,
        ),
        h8SizedBox,
        PodcastTile(
          title: 'Ngobam',
          artist: 'Gofar Hilman',
          genre: 'Music & Fun',
          episodes: 32,
        ),
        h8SizedBox,
        PodcastTile(
          title: 'Ngobam',
          artist: 'Gofar Hilman',
          genre: 'Music & Fun',
          episodes: 32,
        ),
        h8SizedBox,
        PodcastTile(
          title: 'Ngobam',
          artist: 'Gofar Hilman',
          genre: 'Music & Fun',
          episodes: 32,
        ),
        h8SizedBox,
        PodcastTile(
          title: 'Ngobam',
          artist: 'Gofar Hilman',
          genre: 'Music & Fun',
          episodes: 32,
        ),
      ],
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
              child: const SizedBox(
                height: kToolbarHeight,
                child: Align(
                  alignment: Alignment.topRight,
                  child: ListTile(
                    title: Text('Guest'),
                    subtitle: Text('Sign in, and update your status!'),
                    trailing: CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                  ),
                ),
              ),
            ),
            hSizedBox,
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
                    )
                  ],
                ),
              ),
            ),
            hSizedBox,
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
                                hSizedBox,
                                SizedBox(
                                  height: hSizedBox.height,
                                  child: Hero(
                                    tag: kFilterChoicesTag,
                                    child: filterChoices,
                                  ),
                                ),
                                hSizedBox,
                                Expanded(
                                  child: Hero(
                                    tag: kFilterListTag,
                                    child: selectedFilteredItems,
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
                  wSizedBox,
                ],
              ),
            ),
            Expanded(
              child: Hero(
                tag: kFilterListTag,
                child: selectedFilteredItems,
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
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
    );
  }
}
