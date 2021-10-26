import 'package:flutter/material.dart';
import 'package:flutter_podcast/audio_player/audio_player_handler.dart';
import 'package:flutter_podcast/services/podcast_service.dart';
import 'package:flutter_podcast/widgets/podcast_list_displyer.dart';
import 'package:podcast_search/podcast_search.dart';

class FilteredListDisplayer extends StatelessWidget {
  // final FilteredListBloc filteredListBloc;
  final AudioPlayerHandler audioPlayerHandler;
  const FilteredListDisplayer({
    Key? key,
    required this.audioPlayerHandler,
    // required this.filteredListBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Future<List<Item>>>(
      stream: PodcastService.topPodcastsStream,
      initialData: PodcastService.topPodcastsInitialData,
      builder: (context, snapshot) {
        return RefreshIndicator(
          onRefresh: PodcastService.forceRefetchTopPodcast,
          child: FutureBuilder<List<Item>>(
            future: snapshot.data,
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.error.toString(),
                  ),
                );
              } else if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return PodcastListDisplayer(
                  audioPlayerHandler: audioPlayerHandler,
                  podcastResults: snapshot.data ?? <Item>[],
                );
              }
            },
          ),
        );
      },
    );
  }
}
