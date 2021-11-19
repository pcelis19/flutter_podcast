import 'package:podcast_search/podcast_search.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerHandlerService {
  final _currentPlayController = BehaviorSubject<FullPodcastEpisodeInfo?>()
    ..sink.add(null);
  Stream<FullPodcastEpisodeInfo?> get currentEpisodeStream =>
      _currentPlayController;
  FullPodcastEpisodeInfo? get currentEpisodeInitialData =>
      _currentPlayController.valueOrNull;
  dispose() => _currentPlayController.close();

  void playNextEpisode(FullPodcastEpisodeInfo fullPodcastEpisodeInfo) =>
      _currentPlayController.sink.add(fullPodcastEpisodeInfo);
}

class FullPodcastEpisodeInfo {
  final Item podcastResult;
  final Podcast podcast;
  final Episode episode;

  const FullPodcastEpisodeInfo(this.podcastResult, this.podcast, this.episode);
}
