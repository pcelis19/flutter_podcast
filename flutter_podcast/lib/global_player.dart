import 'package:flutter/material.dart';
import 'package:flutter_podcast/audio_player_handler.dart';

class GlobalPlayer extends StatelessWidget {
  final AudioPlayerHandler audioPlayer;
  const GlobalPlayer({Key? key, required this.audioPlayer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Theme.of(context).accentColor.withOpacity(.2),
            Theme.of(context).primaryColor.withOpacity(.2),
          ],
        ),
      ),
      child: StreamBuilder<FullPodcastEpisodeInfo?>(
          stream: audioPlayer.currentEpisodeStream,
          initialData: audioPlayer.currentEpisodeInitialData,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: Text('Explore, and listen! 🎧'),
              );
            }
            final FullPodcastEpisodeInfo fullInfo = snapshot.data!;
            return Center(
              child: ListTile(
                leading: CircleAvatar(
                  child: Image.network(fullInfo.episode.imageUrl ??
                      fullInfo.podcastResult.artworkUrl100 ??
                      ''),
                ),
                title: Text(
                  fullInfo.episode.title,
                ),
                trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow),
                ),
              ),
            );
          }),
    );
  }
}
