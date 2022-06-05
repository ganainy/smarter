import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

import '../models/song.dart';

enum PlayState { initial, loading, playing, paused }

class AudioProvider with ChangeNotifier {
  var _audioPlayer = AudioPlayer();
  PlayState playState = PlayState.initial;
  String? currentSongUrl;
  Song? song;
  int playbackPosition = 0;
  int? playbackDuration;

  int id; //to differ between different providers
  AudioProvider(this.id);

  initAudio() {
    print("initAudio()");

    _audioPlayer
        .setAudioSource(ConcatenatingAudioSource(children: [
      AudioSource.uri(Uri.parse(currentSongUrl!)),
    ]))
        .catchError((error) {
      // catch load errors: 404, invalid url ...
      print("An error occured $error");
    });

    //change ui based on play state
    _audioPlayer.playerStateStream.listen((playerState) {
      var processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        playState = PlayState.loading;
      } else if (_audioPlayer.playing != true) {
        playState = PlayState.paused;
      } else if (processingState != ProcessingState.completed) {
        playState = PlayState.playing;
      } else {
        playState = PlayState.paused;
      }
      notifyListeners();
    });

    //get total duration of playback
    notifyListeners();
    _audioPlayer.durationStream.listen((event) {
      playbackDuration = event?.inSeconds;
      notifyListeners();
    });
    //listen to position to show progess of playback

    _audioPlayer.positionStream.listen((event) {
      playbackPosition = event.inSeconds;
      notifyListeners();
    });
  }

  void playPauseAudio({Song? newSong}) {
    //if the playing song is different than the new song, then play the new song from beginning
    if (newSong != null) {
      song = newSong;

      if (newSong.url != currentSongUrl) {
        currentSongUrl = newSong.url;
        notifyListeners();
        initAudio();
        _audioPlayer.play();
        return;
      }
    }
    //otherwise change the state of the current song

    var processingState = _audioPlayer.playerState.processingState;
    if (processingState == ProcessingState.loading ||
        processingState == ProcessingState.buffering) {
      //temporary state (loading,buffering)
    } else if (_audioPlayer.playing != true) {
      // paused or not started yet , call _audioPlayer.play
      _audioPlayer.play();
    } else if (processingState != ProcessingState.completed) {
      // player is playing music , call _audioPlayer.pause
      _audioPlayer.pause();
    } else {
      // all music list ended, play again from the start
      // _audioPlayer.seek(Duration.zero,index: _audioPlayer.effectiveIndices.first)
      _audioPlayer.seek(Duration.zero,
          index: _audioPlayer.effectiveIndices?.first);
    }
  }

  void rewindTenSeconds() {
    _audioPlayer.seek(Duration(seconds: playbackPosition - 10));
  }

  void seek(int seconds) {
    _audioPlayer.seek(Duration(seconds: seconds));
  }

  void stopPlayback() {
    _audioPlayer.stop();
  }

  void pausePlayback() {
    _audioPlayer.pause();
  }

  void fastForwardTenSeconds() {
    _audioPlayer.seek(Duration(seconds: playbackPosition + 10));
  }

  void resumePlayback() {
    _audioPlayer.play();
  }
}
