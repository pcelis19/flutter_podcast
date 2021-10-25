import 'package:flutter/foundation.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:quiver/collection.dart';

class PodcastService {
  PodcastService._();
  static final pastPodcastResults =
      LinkedLruHashMap<String, Future<Podcast>>(maximumSize: 4);
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
}

Future<Podcast> _loadFeed(String url) => Podcast.loadFeed(url: url);
