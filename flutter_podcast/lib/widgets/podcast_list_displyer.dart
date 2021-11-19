import 'package:flutter/material.dart';
import 'package:flutter_podcast/audio_player_handler.dart';
import 'package:flutter_podcast/podcast_displayer.dart';
import 'package:flutter_podcast/services/podcast_service.dart';
import 'package:flutter_podcast/widgets/constants.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:simple_animations/simple_animations.dart' as animations;

/// given a List of podcasts, this widget will display them in a list
class PodcastListDisplayer extends StatelessWidget {
  final List<Item> podcastResults;
  final AudioPlayerHandler audioPlayerHandler;
  const PodcastListDisplayer({
    Key? key,
    required this.podcastResults,
    required this.audioPlayerHandler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (_, index) {
        final podcast = podcastResults[index];
        return PodcastTile(
          audioPlayerHandler: audioPlayerHandler,
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
  final AudioPlayerHandler audioPlayerHandler;

  const PodcastTile({
    Key? key,
    required this.title,
    required this.artist,
    required this.genre,
    required this.episodes,
    required this.imageUrl,
    required this.podcastResult,
    required this.audioPlayerHandler,
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
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return Scaffold(
                            appBar: AppBar(
                              title: Text(podcastResult.collectionName ??
                                  podcastResult.artistName ??
                                  ''),
                            ),
                            body: LayoutBuilder(
                              builder: (context, constraints) {
                                final imageHeight = constraints.maxWidth;
                                final leftOverSpace =
                                    constraints.maxHeight - imageHeight;
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: imageHeight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: ClipRRect(
                                            borderRadius: borderRadius20,
                                            child: Image.network(
                                              podcastResult.artworkUrl600 ?? '',
                                              loadingBuilder:
                                                  (_, child, imageChunk) {
                                                if (imageChunk == null) {
                                                  return child;
                                                } else {
                                                  return Stack(
                                                    children: [
                                                      Center(
                                                        child: Image.network(
                                                            podcastResult
                                                                    .artworkUrl100 ??
                                                                ''),
                                                      ),
                                                      CircularProgressIndicator(
                                                          value: imageChunk
                                                                      .expectedTotalBytes ==
                                                                  null
                                                              ? null
                                                              : imageChunk
                                                                      .cumulativeBytesLoaded /
                                                                  imageChunk
                                                                      .expectedTotalBytes!)
                                                    ],
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: FutureBuilder<Podcast>(
                                        future: PodcastService.getPodcast(
                                            podcastResult),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return Center(
                                              child: Text(
                                                snapshot.error.toString(),
                                              ),
                                            );
                                          } else if (!snapshot.hasData) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          } else {
                                            return PodcastDisplayer(
                                                audioPlayerHandler:
                                                    audioPlayerHandler,
                                                item: podcastResult,
                                                podcast: snapshot.data!);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(0),
                    leading: ClipRRect(
                      borderRadius: borderRadius10,
                      child: CircleAvatar(
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
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
                    ),
                    title: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$episodes Eps · $genre',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          artist,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
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
