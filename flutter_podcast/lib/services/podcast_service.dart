import 'package:flutter/foundation.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:quiver/collection.dart';
import 'package:rxdart/subjects.dart';

class PodcastService {
  PodcastService._();
  static final pastPodcastResults =
      LinkedLruHashMap<String, Future<Podcast>>(maximumSize: 4);
  static final _lastTopPodcastFetchController =
      BehaviorSubject<Future<List<Item>>>()..sink.add(_getTopPodcasts());
  static Future<Podcast> getPodcast(Item podcastResult) async {
    final String feedUrl = podcastResult.feedUrl ?? '';
    Future<Podcast>? result = pastPodcastResults[feedUrl];
    if (result != null) {
      return result;
    } else {
      result = compute<String, Podcast>(_loadFeed, feedUrl);
      pastPodcastResults[feedUrl] = result;
      return result;
    }
  }

  /// will refetch topPodcasts, and return that result
  static Future<List<Item>> forceRefetchTopPodcast({int resultSize = 30}) {
    var futureFetch = _getTopPodcasts()..then((value) => print('object'));
    _lastTopPodcastFetchController.sink.add(futureFetch);
    return futureFetch;
  }

  static Future<List<Item>> _getTopPodcasts({
    int resultSize = 30,
  }) async =>
      compute<int, List<Item>>(_topPodcasts, resultSize);

  /// will return the last time topPodcasts fetch, if that has not happened
  /// yet will it will instantiate a new future, and return that, for a recent
  /// result, user [forceRefetchTopPodcast]
  static Stream<Future<List<Item>>> get topPodcastsStream =>
      _lastTopPodcastFetchController.stream;
  static Future<List<Item>> get topPodcastsInitialData =>
      _lastTopPodcastFetchController.value;
}

Future<Podcast> _loadFeed(String url) => Podcast.loadFeed(url: url);
Future<List<Item>> _topPodcasts(int resultSize) async {
  final search = Search();
  final results = await search.charts(limit: resultSize);
  return results.items;
}
