import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_podcast/theme_service/theme_service.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EdgeInsets edgeInsets;
    return ResponsiveBuilder(builder: (context, info) {
      if (info.isTablet) {
        edgeInsets = const EdgeInsets.symmetric(horizontal: 30);
      } else if (info.isDesktop) {
        edgeInsets = const EdgeInsets.symmetric(horizontal: 30, vertical: 10);
      } else {
        edgeInsets = const EdgeInsets.all(0);
      }
      return ListView(
        children: [
          Padding(
            padding: edgeInsets,
            child: const SizedBox(
              height: kToolbarHeight,
              child: Align(
                alignment: Alignment.topRight,
                child: ListTile(
                  title: Text('Pedro Celis'),
                  subtitle: Text('Love Programming, eating, and gunpla!'),
                  trailing: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
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
                        Text('Categories'),
                        TextButton(
                          onPressed: () {},
                          child: Text('See all'),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      scrollDirection: Axis.horizontal,
                      controller: PageController(viewportFraction: 1),
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
          )
        ],
      );
    });
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [Colors.pinkAccent, Colors.cyanAccent],
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
