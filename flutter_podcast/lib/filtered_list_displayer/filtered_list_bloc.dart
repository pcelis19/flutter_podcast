import 'package:podcast_search/podcast_search.dart';
import 'package:rxdart/subjects.dart';

/// keeps track of what the current filter list is
class FilteredListBloc {
  static const kPopular = '🔥  Popular';
  static const kRecent = 'Recent';

  final currentFilteredListController = BehaviorSubject<String>();
  FilteredListBloc() {
    _init();
  }
  void _init() {
    currentFilteredListController.sink.add(_defaultItems.first);
    // TODO need fetch from the users storage
  }

  /// given a [Podcast] this will append the genres from the podcast
  /// to the users history
  void updateLists(Podcast podcast) {
    /// todo update the users stats
    /// e.g. add to the recents to the top of the list
    /// update the stats like the things they listen to
    /// comedy, talk
  }
  Stream<String> get currentFilteredListStream =>
      currentFilteredListController.stream;
  String get currentFilteredListInitialData =>
      currentFilteredListController.valueOrNull ?? _defaultItems.first;

  List<String> get _defaultItems => [kPopular, kRecent];
}
