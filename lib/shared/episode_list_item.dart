import 'package:expandable/expandable.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:podcast_search/src/model/episode.dart';
import 'package:provider/provider.dart';

import '../providers/audio_provider.dart';

class EpisodeListItem extends StatefulWidget {
  late Episode selectedEpisode;
  late List<Episode> episodes;
  late int listIndex;

  EpisodeListItem(this.episodes, this.selectedEpisode, this.listIndex);

  @override
  State<EpisodeListItem> createState() => _EpisodeListItemState();
}

class _EpisodeListItemState extends State<EpisodeListItem> {
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                widget.selectedEpisode.season != null &&
                        widget.selectedEpisode.episode != null
                    ? "Season ${widget.selectedEpisode.season} Episode ${widget.selectedEpisode.episode}"
                    : widget.selectedEpisode.episode != null
                        ? "Episode ${widget.selectedEpisode.episode}"
                        : '',
                style: const TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "${widget.selectedEpisode.duration?.inMinutes} minutes",
                style: const TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                DateFormat('yMMMd').format(
                    widget.selectedEpisode.publicationDate ?? DateTime.now()),
                style: const TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.selectedEpisode.title ?? '',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Consumer<AudioProvider>(
                builder: (context, audioProvider, child) {
                  return audioProvider.playButtonNotifier ==
                              ButtonState.paused ||
                          audioProvider.currentMediaItem?.title !=
                              widget.selectedEpisode.title
                      ? playButton(audioProvider, context, widget.listIndex)
                      : audioProvider.playButtonNotifier == ButtonState.loading
                          ? loadingButton()
                          : pauseButton(audioProvider);
                },
              )
            ],
          ),
          ExpandablePanel(
            header: Text(
              " Episode ${widget.selectedEpisode.episode ?? ''} description ",
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            collapsed: SizedBox(),
            expanded: Html(
              data: widget.selectedEpisode.description,
            ),
          ),
        ],
      ),
    );
  }

  playButton(AudioProvider audioProvider, BuildContext context, int listIndex) {
    return IconButton(
        onPressed: () async {
          audioProvider.play(context, listIndex);
        },
        icon: const Icon(
          FeatherIcons.play,
        ));
  }

  pauseButton(AudioProvider audioProvider) {
    return IconButton(
        onPressed: () async {
          audioProvider.pause();
        },
        icon: const Icon(
          FeatherIcons.pause,
        ));
  }

  loadingButton() {
    return const SizedBox(
        width: 25, height: 25, child: CircularProgressIndicator());
  }
}
