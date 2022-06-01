import 'package:flutter/foundation.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:smarter/providers/settings_provider.dart';

class HomeProvider with ChangeNotifier {
  List<Item> topPodcasts = [];
  bool isLoading = false;
  Country _topPodcastsCountry = Country.UNITED_KINGDOM;

  HomeProvider() {
    getTopPodcasts();
  }

  getTopPodcasts() async {
    try {
      isLoading = true;
      topPodcasts = [];

      notifyListeners();

      SearchResult charts = await Search().charts(
        limit: 24,
        country: _topPodcastsCountry,
      );
      print(" top pods called : ${charts.items.length}");
      for (var i in charts.items) {
        topPodcasts.add(i);
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print(" error in getting top pods: $e ");
    }
  }

  void changeTopPodcastsLanguage(Languages lng) {
    if (lng == Languages.en && _topPodcastsCountry == Country.UNITED_KINGDOM) {
      return;
    }
    if (lng == Languages.de && _topPodcastsCountry == Country.GERMANY) {
      return;
    }

    switch (lng) {
      case Languages.en:
        _topPodcastsCountry = Country.UNITED_KINGDOM;
        break;
      case Languages.de:
        _topPodcastsCountry = Country.GERMANY;
        break;
    }
    getTopPodcasts();
  }
}
