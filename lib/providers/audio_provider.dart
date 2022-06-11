import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:provider/provider.dart';
import 'package:smarter/screens/podcast/podcast_provider.dart';

import '../services/audio_handler.dart';
import '../services/service_locator.dart';

class ProgressBarState {
  ProgressBarState(this.current, this.buffered, this.total);

  Duration? current;
  Duration? buffered;
  Duration? total;
}

enum ButtonState {
  paused,
  playing,
  loading,
}

class AudioProvider with ChangeNotifier {
  MediaItem? currentMediaItem;
  List<String> playlistNotifier = [];
  ProgressBarState? progressNotifier;
  bool isFirstSongNotifier = true;
  ButtonState playButtonNotifier = ButtonState.paused;
  bool isLastSongNotifier = true;
  final MyAudioHandler _audioHandler =
      (getIt.get<AudioHandler>() as MyAudioHandler);

  void init() {
    _listenToChangesInPlaylist();
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _listenToChangesInSong();
  }

  Future<void> loadPlaylist(List<Episode> playlist) async {
    final mediaItems = playlist
        .map((song) => MediaItem(
              id: song.guid,
              title: song.title,
              artUri: Uri.parse(song.imageUrl ?? ''),
              extras: {'url': song.contentUrl},
            ))
        .toList();
    _audioHandler.addQueueItems(mediaItems);
  }

  void _listenToChangesInPlaylist() {
    _audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) {
        playlistNotifier = [];
        currentMediaItem = null;
      } else {
        final newList = playlist.map((item) => item.title).toList();
        playlistNotifier = newList;
      }
      _updateSkipButtons();
      notifyListeners();
    });
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      print('_listenToPlaybackState ${playbackState.processingState}');
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        playButtonNotifier = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        playButtonNotifier = ButtonState.playing;
      } else {
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
      notifyListeners();
    });
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      final oldState = progressNotifier;
      progressNotifier = ProgressBarState(
        position,
        oldState?.buffered,
        oldState?.total,
      );
      notifyListeners();
    });
  }

  void _listenToBufferedPosition() {
    _audioHandler.playbackState.listen((playbackState) {
      final oldState = progressNotifier;
      progressNotifier = ProgressBarState(
        oldState?.current,
        playbackState.bufferedPosition,
        oldState?.total,
      );
      notifyListeners();
    });
  }

  void _listenToTotalDuration() {
    _audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier;
      progressNotifier = ProgressBarState(
        oldState?.current,
        oldState?.buffered,
        mediaItem?.duration ?? Duration.zero,
      );
      notifyListeners();
    });
  }

  void _listenToChangesInSong() {
    _audioHandler.mediaItem.listen((mediaItem) {
      currentMediaItem = mediaItem;
      _updateSkipButtons();
      notifyListeners();
    });
  }

  void _updateSkipButtons() {
    final mediaItem = _audioHandler.mediaItem.value;
    final playlist = _audioHandler.queue.value;
    if (playlist.length < 2 || mediaItem == null) {
      isFirstSongNotifier = true;
      isLastSongNotifier = true;
    } else {
      isFirstSongNotifier = playlist.first == mediaItem;
      isLastSongNotifier = playlist.last == mediaItem;
    }
    notifyListeners();
  }

  var podcastName;
  void play(BuildContext context, int listIndex) async {
    var podcastProvider = Provider.of<PodcastProvider>(context, listen: false);

    //only load each podcast playlist only once
    if (podcastProvider.podcast?.title != podcastName) {
      print('playlist is loaded again in player');
      var audioProvider = Provider.of<AudioProvider>(context, listen: false);
      audioProvider.loadPlaylist(podcastProvider.filteredEpisodes);
      podcastName = podcastProvider.podcast?.title;
    }

    await _audioHandler.skipToQueueItem(listIndex);

    _audioHandler.play();
  }

  void resume() => _audioHandler.play();

  void pause() => _audioHandler.pause();

  void seek(Duration position) => _audioHandler.seek(position);

  void previous() => _audioHandler.skipToPrevious();
  void next() => _audioHandler.skipToNext();

  void dispose() {
    _audioHandler.customAction('dispose');
  }

  void stop() {
    _audioHandler.stop();
  }
}
