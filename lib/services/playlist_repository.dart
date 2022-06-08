import 'package:podcast_search/podcast_search.dart';

PlaylistRepository initRepository() {
  return PlaylistRepository();
}

class PlaylistRepository {
  Future<Podcast?> loadPodcast(String feedUrl) async {
    Podcast? podcast;
    try {
      podcast = await Podcast.loadFeed(url: feedUrl);
      return podcast;
    } on PodcastFailedException catch (_) {
      return null;
    }
  }
}
