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
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, AudioProvider audioProvider, child) {
        return audioProvider.playlistNotifier.isEmpty
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
                        audioProvider.currentMediaItem?.artUri.toString() ?? '',
                      ),
                    ),
                  )),
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        audioProvider.currentMediaItem?.title ?? "  ",
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
                        audioProvider.seek(const Duration(seconds: -10));
                      }),
                  Container(
                    child: Row(
                      children: [
                        audioProvider.playButtonNotifier == ButtonState.playing
                            ? buildPlayingButton(audioProvider)
                            : audioProvider.playButtonNotifier ==
                                    ButtonState.loading
                                ? buildLoadingButton()
                                : buildPausedButton(audioProvider),
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
                        audioProvider.seek(const Duration(seconds: 10));
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
            progress: audioProvider.progressNotifier?.current ??
                const Duration(seconds: 0),
            buffered: audioProvider.progressNotifier?.buffered ??
                const Duration(seconds: 0),
            total: audioProvider.progressNotifier?.total ??
                const Duration(seconds: 0),
            onSeek: (duration) {
              audioProvider.seek(duration);
            },
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
      ],
    );
  }

  buildPlayingButton(AudioProvider audioProvider) {
    return IconButton(
        icon: Icon(
          FeatherIcons.pauseCircle,
          color: Theme.of(context).colorScheme.secondary,
          size: 32.0,
        ),
        onPressed: () {
          audioProvider.pause();
        });
  }

  buildPausedButton(AudioProvider audioProvider) {
    return IconButton(
        icon: Icon(
          FeatherIcons.playCircle,
          color: Theme.of(context).colorScheme.secondary,
          size: 32.0,
        ),
        onPressed: () {
          audioProvider.resume();
        });
  }

  buildLoadingButton() {
    return const SizedBox(
        width: 32, height: 32, child: CircularProgressIndicator());
  }
}

String _formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}
