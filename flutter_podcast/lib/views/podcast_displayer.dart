import 'package:flutter/material.dart';
import 'package:flutter_podcast/services/audio_player_handler.dart';
import 'package:flutter_podcast/utils/constants.dart';
import 'package:flutter_podcast/utils/time_utils.dart';
import 'package:flutter_podcast/widgets/constants.dart';
import 'package:podcast_search/podcast_search.dart';

class PodcastDisplayer extends StatefulWidget {
  final Item item;
  final Podcast podcast;
  final AudioPlayerHandlerService audioPlayerHandler;
  const PodcastDisplayer({
    Key? key,
    required this.item,
    required this.podcast,
    required this.audioPlayerHandler,
  }) : super(key: key);

  @override
  State<PodcastDisplayer> createState() => _PodcastDisplayerState();
}

class _PodcastDisplayerState extends State<PodcastDisplayer> {
  /// minutes to seconds
  static Map<String, bool Function(Episode)> filterMatrix = {
    'Under 15 Minutes': (Episode episode) =>
        (episode.duration?.inSeconds ?? double.infinity) < 60 * 15,
    'Under 30 Minutes': (Episode episode) =>
        (episode.duration?.inSeconds ?? double.infinity) < 60 * 30,
    'Under 45 Minutes': (Episode episode) =>
        (episode.duration?.inSeconds ?? double.infinity) < 60 * 45,
    'Under an Hour': (Episode episode) =>
        (episode.duration?.inSeconds ?? double.infinity) < 60 * 60,
    'An Hour and Over': (Episode episode) =>
        (episode.duration?.inSeconds ?? 0) >= 60 * 60,
  };
  bool Function(Episode)? get filter => filterMatrix[filterName];
  String filterName = 'No Filter';
  String get episodeText {
    if (widget.podcast.episodes == null) {
      return '';
    }

    if (filter == null) {
      return '${widget.podcast.episodes!.length} episodes';
    }

    return '${widget.podcast.episodes!.where(
          (element) => filter!(element),
        ).length} episodes';
  }

  List<Episode> get filterList => widget.podcast.episodes!
      .where((element) => filter == null ? true : filter!(element))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            height: kToolbarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(episodeText),
                TextButton(
                  onPressed: () {
                    showGeneralDialog<String>(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: 'Choose a Primary Color',
                      pageBuilder: (_, animation, pageBuilderAnimation) {
                        final filters = filterMatrix.keys.toList();
                        filters.sort((s1, s2) {
                          final s1Amount = widget.podcast.episodes!
                              .where((element) => filterMatrix[s1]!(element))
                              .length;
                          final s2Amount = widget.podcast.episodes!
                              .where((element) => filterMatrix[s2]!(element))
                              .length;
                          return s2Amount.compareTo(s1Amount);
                        });
                        return FadeTransition(
                          opacity: animation,
                          child: AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Filters',
                                ),
                                Column(
                                  children: filters
                                      .map(
                                        (e) => ListTile(
                                          title: Text(e),
                                          subtitle: Text(
                                            "${widget.podcast.episodes!.where(
                                                  (element) =>
                                                      filterMatrix[e]!(element),
                                                ).length} episodes",
                                          ),
                                          onTap: () =>
                                              Navigator.pop<String>(context, e),
                                        ),
                                      )
                                      .toList(),
                                ),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text(
                                        'No Filter (${widget.podcast.episodes?.length} eps)'),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ).then((value) {
                      setState(() {
                        filterName = value ?? 'No Filter';
                      });
                    });
                  },
                  child: Text(filterName),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: widget.podcast.episodes == null
              ? const Center(
                  child: Text('WHOA! No Podcast Episodes Found!'),
                )
              : filterList.isEmpty
                  ? const Center(
                      child:
                          Text('No episodes under this filter\nTry an other?'),
                    )
                  : ListView(
                      children: filterList
                          .map(
                            (e) => StreamBuilder<FullPodcastEpisodeInfo?>(
                              stream: widget
                                  .audioPlayerHandler.currentEpisodeStream,
                              initialData: widget
                                  .audioPlayerHandler.currentEpisodeInitialData,
                              builder: (context, snapshot) {
                                bool isSelected;
                                final currentEpisode = snapshot.data;
                                if (currentEpisode == null) {
                                  isSelected = false;
                                } else {
                                  isSelected =
                                      currentEpisode.episode.contentUrl ==
                                          e.contentUrl;
                                }
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GradientBackground(
                                    borderRadius: borderRadius20,
                                    child: ListTile(
                                      leading: ClipRRect(
                                        borderRadius: borderRadius20,
                                        child: CircleAvatar(
                                          child: Image.network(
                                              widget.item.artworkUrl100 ?? ''),
                                        ),
                                      ),
                                      onTap: () {
                                        Scaffold.maybeOf(context)
                                            ?.showBottomSheet(
                                          (context) => ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                            child: GradientBackground(
                                              opacity: .4,
                                              child: Column(
                                                children: [
                                                  const Center(
                                                    child:
                                                        Icon(Icons.drag_handle),
                                                  ),
                                                  Text(
                                                    e.title,
                                                  ),
                                                  h8SizedBox,
                                                  Expanded(
                                                    child: SizedBox(
                                                      height: 300,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(32.0),
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Text(
                                                              e.description),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  h8SizedBox,
                                                  StreamBuilder<
                                                      FullPodcastEpisodeInfo?>(
                                                    stream: widget
                                                        .audioPlayerHandler
                                                        .currentEpisodeStream,
                                                    initialData: widget
                                                        .audioPlayerHandler
                                                        .currentEpisodeInitialData,
                                                    builder:
                                                        (context, snapshot) {
                                                      bool selected;
                                                      final currentEpisode =
                                                          snapshot.data;
                                                      if (currentEpisode ==
                                                          null) {
                                                        selected = false;
                                                      } else {
                                                        selected = currentEpisode
                                                                .episode
                                                                .contentUrl ==
                                                            e.contentUrl;
                                                      }

                                                      return IconButton(
                                                        onPressed: () {
                                                          if (!selected) {
                                                            widget
                                                                .audioPlayerHandler
                                                                .playNextEpisode(
                                                              FullPodcastEpisodeInfo(
                                                                  widget.item,
                                                                  widget
                                                                      .podcast,
                                                                  e),
                                                            );
                                                          }
                                                        },
                                                        icon: Icon(!selected
                                                            ? Icons.play_arrow
                                                            : Icons.pause),
                                                      );
                                                    },
                                                  ),
                                                  h8SizedBox,
                                                ],
                                              ),
                                            ),
                                          ),
                                          backgroundColor: Colors.transparent,
                                          constraints: BoxConstraints(
                                            maxHeight: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .5,
                                          ),
                                          elevation: 16,
                                        );
                                      },
                                      selected: isSelected,
                                      title: Text(e.title),
                                      subtitle: Text(
                                        e.duration == null
                                            ? ''
                                            : durationConverter(e.duration!),
                                      ),
                                      trailing: IconButton(
                                        onPressed: () {
                                          if (!isSelected) {
                                            widget.audioPlayerHandler
                                                .playNextEpisode(
                                                    FullPodcastEpisodeInfo(
                                                        widget.item,
                                                        widget.podcast,
                                                        e));
                                          }
                                        },
                                        icon: Icon(
                                          !isSelected
                                              ? Icons.play_arrow
                                              : Icons.pause,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                          .toList(),
                    ),
        ),
      ],
    );
  }
}
