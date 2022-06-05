import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarter/providers/audio_provider.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, AudioProvider audioProvider, child) {
        print('mini player consumer called ${audioProvider.currentSongUrl}');
        return audioProvider.currentSongUrl == null
            ? const SizedBox()
            : AnimatedContainer(
                // height: _height,
                duration: const Duration(milliseconds: 200),
                child: Material(
                  child: buildSmallPlayer(audioProvider),
                ));
      },
    );
  }

  Widget buildSmallPlayer(AudioProvider audioProvider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: ProgressBar(
            progress: Duration(seconds: audioProvider.playbackPosition),
            total: Duration(seconds: audioProvider.playbackDuration ??= 1),
            onSeek: (duration) {
              audioProvider.seek(duration.inSeconds);
            },
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
