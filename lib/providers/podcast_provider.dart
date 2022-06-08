import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:podcast_search/podcast_search.dart';

import '../services/database/db_service.dart';
import '../services/playlist_repository.dart';
import '../services/service_locator.dart';

//todo sort,lang, add firebase
enum EpisodeSort { newToOld, oldToNew }

class PodcastProvider with ChangeNotifier {
  final playListRepository = getIt.get<PlaylistRepository>();

  List<Episode> filteredEpisodes = []; //list of episodes after search
  List<Episode> _allEpisodes = []; //list of all episodes
  Podcast? podcast; //list of all episodes

  bool isLoading = false;
  bool isSubscribedToPodcast = false;
  EpisodeSort episodesSort = EpisodeSort.newToOld;

  loadPodcastEpisodes(String feedUrl, BuildContext context) async {
    isLoading = true;
    notifyListeners();

    playListRepository.loadPodcast(feedUrl).then((_podcast) {
      if (_podcast == null) {
        //error loading
        print(" error in getting pod eps");
        isLoading = false;
        notifyListeners();
        return;
      }

      podcast = _podcast;

      if (_podcast.episodes != null) {
        List<Episode> _episodes = [];
        for (var i in _podcast.episodes!) {
          _episodes.add(i);
        }
        _allEpisodes = _episodes;
        filteredEpisodes = _episodes;
      }
      isLoading = false;
      notifyListeners();
    });
  }

  removeFromSubscriptionsAction(Item podcast) async {
    bool _removed = await removePodcastFromSubs(podcast);
    if (_removed) {
      print(" podcast ${podcast.collectionName}  is removed from subs");
      isSubscribedToPodcast = false;
    } else {
      isSubscribedToPodcast = true;
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
      isSubscribedToPodcast = true;
      notifyListeners();
    } else {
      isLoading = false;
      isSubscribedToPodcast = false;
      notifyListeners();
    }
  }

  void filterEpisodesWithQuery(String query) {
    if (query.isEmpty) {
      filteredEpisodes = _allEpisodes;
    } else {
      filteredEpisodes = _allEpisodes
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

      filteredEpisodes
          .sort((a, b) => a.publicationDate!.compareTo(b.publicationDate!));

      //epSortingIncr: !state.epSortingIncr,

    } catch (e) {
      debugPrint(" cannot sort episodes  : $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  loadSubscriptionState(Item podcastInfo) async {
    isSubscribedToPodcast = await isPodcastSubbed(podcastInfo);
    notifyListeners();
  }
}
