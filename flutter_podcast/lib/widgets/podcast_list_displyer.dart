import 'package:flutter/material.dart';
import 'package:flutter_podcast/widgets/constants.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:simple_animations/simple_animations.dart' as animations;

/// given a List of podcasts, this widget will display them in a list
class PodcastListDisplayer extends StatelessWidget {
  final List<Item> podcastResults;
  const PodcastListDisplayer({
    Key? key,
    required this.podcastResults,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (_, index) {
        final podcast = podcastResults[index];
        return PodcastTile(
          imageUrl: podcast.artworkUrl100 ?? '',
          title: podcast.collectionName ?? '',
          artist: podcast.artistName ?? '',
          genre: (podcast.genre != null && podcast.genre!.isNotEmpty
              ? podcast.genre!.first.name
              : ''),
          episodes: podcast.trackCount ?? 0,
          podcastResult: podcast,
        );
      },
      separatorBuilder: (_, __) => h8SizedBox,
      itemCount: podcastResults.length,
    );
  }
}

class PodcastTile extends StatelessWidget {
  final String title;
  final String artist;
  final String genre;
  final int episodes;
  final String imageUrl;
  final Item podcastResult;

  const PodcastTile({
    Key? key,
    required this.title,
    required this.artist,
    required this.genre,
    required this.episodes,
    required this.imageUrl,
    required this.podcastResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Theme.of(context).accentColor.withOpacity(.2),
                Theme.of(context).primaryColor.withOpacity(.2)
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    leading: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                      child: Image.network(
                        imageUrl,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image),
                        loadingBuilder: (_, child, imageChunk) {
                          if (imageChunk == null) {
                            return child;
                          }
                          return animations.MirrorAnimation<double>(
                            tween: Tween(begin: 0, end: 1),
                            builder: (_, __, value) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context)
                                          .accentColor
                                          .withOpacity(value),
                                      Theme.of(context)
                                          .primaryColor
                                          .withOpacity(value)
                                    ],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    title: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$episodes Eps · $genre',
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          artist,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_forward_ios_rounded,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
