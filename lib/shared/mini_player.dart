import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarter/providers/audio_provider.dart';
// import 'package:intl/intl.dart';

const double _smallPlayerSize = 80.0;
const double _largePlayerSize = 380.0;

// Mini Player widget.  ( Having two states, one for small, one for large players);

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  // _height variable sets the height of the player.

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Consumer(
        builder: (context, AudioProvider audioProvider, child) {
          return audioProvider.currentSongUrl == null
              ? Container(
                  height: 0,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.red.withOpacity(0.2),
                )
              : AnimatedContainer(
                  // height: _height,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: const Radius.circular(16.0),
                      topLeft: Radius.circular(16.0),
                    ),
                  ),
                  duration: const Duration(milliseconds: 200),
                  child: Material(
                    color: Theme.of(context).highlightColor.withOpacity(0.3),
                    child: buildSmallPlayer(audioProvider),
                  ));
        },
      ),
    );
  }

  Widget buildSmallPlayer(AudioProvider audioProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                      child: Hero(
                    tag: 'albumArt',
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 60,
                      width: 60,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.0)),
                      child: Image.network(
                        audioProvider.song?.icon ?? '',
                      ),
                    ),
                  )),
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        audioProvider.song?.name ?? "  ",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.replay_10,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 32.0,
                      ),
                      onPressed: () {
                        audioProvider.rewindTenSeconds();
                      }),
                  Container(
                    child: Row(
                      children: [
                        IconButton(
                            icon: Icon(
                              audioProvider.playState == PlayState.playing
                                  ? FeatherIcons.pauseCircle
                                  : FeatherIcons.playCircle,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 32.0,
                            ),
                            onPressed: () {
                              audioProvider.playPauseAudio();
                            }),
                      ],
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.forward_10,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 32.0,
                      ),
                      onPressed: () {
                        audioProvider.fastForwardTenSeconds();
                      }),
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          height: 2.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ProgressBar(
              progress: Duration(seconds: audioProvider.playbackPosition),
              total: Duration(seconds: audioProvider.playbackDuration ??= 1),
              onSeek: (duration) {
                audioProvider.seek(duration.inSeconds);
              },
            ),
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
      ],
    );
  }
}

String _formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}
