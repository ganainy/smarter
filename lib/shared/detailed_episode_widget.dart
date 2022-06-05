import 'package:expandable/expandable.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';
import '../providers/audio_provider.dart';

class DetailedEpsiodeViewWidget extends StatefulWidget {
  DetailedEpsiodeViewWidget(
      {required this.episode, required this.podcastInfo, required this.index});

  final Episode episode;
  final int index;
  late Item podcastInfo;

  @override
  State<DetailedEpsiodeViewWidget> createState() =>
      _DetailedEpsiodeViewWidgetState();
}

class _DetailedEpsiodeViewWidgetState extends State<DetailedEpsiodeViewWidget> {
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
                widget.episode.season != null && widget.episode.episode != null
                    ? "Season ${widget.episode.season} Episode ${widget.episode.episode}"
                    : widget.episode.episode != null
                        ? "Episode ${widget.episode.episode}"
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
                "${widget.episode.duration?.inMinutes} minutes",
                style: const TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                DateFormat('yMMMd').format(widget.episode.publicationDate!),
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
                  widget.episode.title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              playPauseButton()
            ],
          ),
          ExpandablePanel(
            header: Text(
              " Episode ${widget.episode.episode ?? ''} description ",
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            collapsed: SizedBox(),
            expanded: Html(
              data: widget.episode.description,
            ),
          ),
        ],
      ),
    );
  }

  playPauseButton() {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, child) {
        return IconButton(
            onPressed: () async {
              audioProvider.playPauseAudio(
                newSong: Song(
                    url: widget.episode.contentUrl!,
                    icon: widget.podcastInfo.bestArtworkUrl!,
                    name: widget.episode.title,
                    duration: widget.episode.duration,
                    artist: "${widget.episode.author}",
                    album: "${widget.podcastInfo.collectionName}"),
              );
            },
            icon: (() {
              //if the song is not the currently playing song show play icon
              if (audioProvider.currentSongUrl != widget.episode.contentUrl) {
                return const Icon(
                  FeatherIcons.play,
                );

                //otherwise show icon based on state of playing song
              } else if (audioProvider.playState == PlayState.loading) {
                return const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                    ));
              } else if (audioProvider.playState == PlayState.playing) {
                return const Icon(
                  FeatherIcons.pause,
                );
              } else {
                return const Icon(
                  FeatherIcons.play,
                );
              }
            }()));
      },
    );
  }
}
