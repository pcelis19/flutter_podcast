import 'package:podcast_search/podcast_search.dart';
import 'package:rxdart/subjects.dart';

class FilteredListBloc {
  static const kPopular = '🔥  Popular';
  static const kRecent = 'Recent';

  final filteredListController = BehaviorSubject<List<String>>();
  FilteredListBloc() {
    _init();
  }
  void _init() {
    filteredListController.sink.add(_defaultItems);
    // TODO need fetch from the users storage
  }

  /// given a [Podcast] this will append the genres from the podcast
  /// to the users history
  void updateLists(Podcast podcast) {}
  Stream<List<String>> get filteredListStream => filteredListController.stream;
  List<String> get filteredListInitialData =>
      filteredListController.valueOrNull ?? _defaultItems;

  List<String> get _defaultItems => [kPopular, kRecent];
}
