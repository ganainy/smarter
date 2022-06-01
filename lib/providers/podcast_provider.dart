import 'package:flutter/foundation.dart';
import 'package:podcast_search/podcast_search.dart';

import '../services/database/db_service.dart';

enum EpisodeSort { newToOld, oldToNew }

class PodcastProvider with ChangeNotifier {
  PodcastProvider() {
    //loadPodcastEpisodes(podcastInfo?.feedUrl ?? '');
  }

  Item? podcastInfo;
  List<Episode> filteredEpisodes = [];
  List<Episode> _episodes = [];
  bool isLoading = false;
  bool isSubscribed = false;
  String? description;
  EpisodeSort episodesSort = EpisodeSort.newToOld;

  Future<void> loadPodcastEpisodes(String feedUrl) async {
    isLoading = true;
    notifyListeners();
    bool _isSubbed = await isPodcastSubbed(podcastInfo);
    Podcast _podcast;
    try {
      print("loadPodcastEpisodes feed url : $feedUrl");
      _podcast = await Podcast.loadFeed(url: feedUrl);

      if (_podcast.episodes != null) {
        _episodes.clear();
        for (var i in _podcast.episodes!) {
          _episodes.add(i);
        }
        filteredEpisodes = _episodes;
      }
      description = _podcast.description;
      isLoading = false;
      isSubscribed = _isSubbed;
      notifyListeners();
    } on PodcastFailedException catch (e) {
      print(" error in getting pod eps: ${e.toString()}");
      isLoading = false;
      isSubscribed = _isSubbed;
      notifyListeners();
    }
  }

  removeFromSubscriptionsAction(Item podcast) async {
    bool _removed = await removePodcastFromSubs(podcast);
    if (_removed) {
      print(" podcast ${podcast.collectionName}  is removed from subs");
      isSubscribed = false;
    } else {
      isSubscribed = true;
    }
    notifyListeners();
  }

  saveToSubscriptionsAction(Item podcast) async {
    isLoading = true;
    notifyListeners();
    bool _saved = await savePodcastToSubs(podcast);
    if (_saved) {
      print(" podcast ${podcast.collectionName}  is saved to subs");
      isLoading = false;
      isSubscribed = true;
      notifyListeners();
    } else {
      isLoading = false;
      isSubscribed = false;
      notifyListeners();
    }
  }

  void filterEpisodesWithQuery(String query) {
    if (query.isEmpty) {
      filteredEpisodes = _episodes;
    } else {
      filteredEpisodes = _episodes
          .where((episode) =>
              episode.title.toLowerCase().contains(query.toLowerCase().trim()))
          .toList();
    }
    notifyListeners();
  }

  void toggleEpisodesSort() async {
    try {
      isLoading = true;
      notifyListeners();

      _episodes
          .sort((a, b) => a.publicationDate!.compareTo(b.publicationDate!));
      filteredEpisodes = _episodes;

      //epSortingIncr: !state.epSortingIncr,

    } catch (e) {
      debugPrint(" cannot sort episodes  : $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
