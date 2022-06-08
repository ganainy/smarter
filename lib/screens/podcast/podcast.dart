import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:provider/provider.dart';
import 'package:smarter/shared/shimmer_widget.dart';

import '../../providers/podcast_provider.dart';
import '../../services/playlist_repository.dart';
import '../../services/service_locator.dart';
import '../../shared/episode_list_item.dart';
import '../../shared/episode_list_item_loading.dart';

class PodcastScreen extends StatefulWidget {
  final Item podcastInfo;
  PodcastScreen({Key? key, required this.podcastInfo}) : super(key: key);

  @override
  State<PodcastScreen> createState() => _PodcastScreenState();
}

class _PodcastScreenState extends State<PodcastScreen> {
  final TextEditingController episodeSearchController = TextEditingController();

  @override
  void initState() {
    //load episodes on screen open
    var podcastProvider = Provider.of<PodcastProvider>(context, listen: false);
    podcastProvider.loadPodcastEpisodes(widget.podcastInfo.feedUrl!, context);
    podcastProvider.loadSubscriptionState(widget.podcastInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<PodcastProvider>(
          builder: (context, podcastProvider, child) {
            return Column(
              children: [
                buildSearchRow(context),
                podcastProvider.isLoading
                    ? buildLoadingPodcastInfoWidget(context)
                    : buildPodcastInfoWidget(context),
                podcastProvider.isLoading
                    ? buildEpisodesListLoading()
                    : buildEpisodesList(podcastProvider),
              ],
            );
          },
        ),
      ),
    );
  }

  Expanded buildEpisodesList(PodcastProvider podcastProvider) {
    return Expanded(
        child: ListView.separated(
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Divider(
            color: Colors.grey,
          ),
        );
      },
      itemCount: podcastProvider.filteredEpisodes.length,
      itemBuilder: (context, index) {
        return EpisodeListItem(podcastProvider.filteredEpisodes,
            podcastProvider.filteredEpisodes[index], index);
      },
    ));
  }

  Widget buildSearchRow(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )),
          Expanded(
            child: Consumer(
              builder: (context, PodcastProvider podcastProvider, child) {
                // True --> new to old
                // False --> old to new

                // .epSortingIncr;
                if (podcastProvider.isLoading) {
                  return Container();
                }
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: episodeSearchController,
                        onChanged: (String s) {
                          podcastProvider.filterEpisodesWithQuery(s);
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            size: 20.0,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              episodeSearchController.clear();
                              podcastProvider.filterEpisodesWithQuery('');
                            },
                            icon: const Icon(
                              Icons.clear,
                              size: 20.0,
                            ),
                          ),
                          hintText: "Search Episodes",
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: IconButton(
                          onPressed: () {
                            showSortingModalSheet(context, podcastProvider);
                          },
                          icon: Icon(
                            Icons.more_vert,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        )),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void showSortingModalSheet(
      BuildContext context, PodcastProvider podcastProvider) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.2,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  /*    ref
                            .read(
                                podcastPageViewController(
                              podcast,
                            ).notifier)
                            .toggleEpisodesSort();*/
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      podcastProvider.episodesSort == EpisodeSort.newToOld
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                    ),
                    Text(
                      podcastProvider.episodesSort == EpisodeSort.newToOld
                          ? " Sort Episodes Newest to Oldest"
                          : " Sort Episodes Oldest to Newest",
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.70),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Icon(Icons.arrow_downward),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  /* ref
                            .read(
                                podcastPageViewController(
                              podcast,
                            ).notifier)
                            .toggleEpisodesSort();*/
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      podcastProvider.episodesSort == EpisodeSort.newToOld
                          ? Icons.check_box_outline_blank
                          : Icons.check_box,
                    ),
                    Text(
                      " Sort Episodes Oldest to Newest",
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.70),
                        fontFamily: 'Segoe',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Icon(Icons.arrow_upward),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildLoadingPodcastInfoWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                //podcast image
                child: Hero(
                  tag: 'logo${widget.podcastInfo.collectionId}',
                  child: Container(
                    width: 100.0,
                    height: 100.0,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Image.network(
                      widget.podcastInfo.bestArtworkUrl ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 16.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //podcast name
                  ShimmerWidget(
                    width: MediaQuery.of(context).size.width * 0.60,
                    height: 50,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8.0,
                      ),
                      //date country loading row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const ShimmerWidget(
                            width: 100,
                          ),
                          const SizedBox(
                            width: 18.0,
                          ),
                          const ShimmerWidget(
                            width: 50,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      //genre loading widget
                      ShimmerWidget(
                        width: MediaQuery.of(context).size.width * 0.60,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerWidget(
                width: MediaQuery.of(context).size.width * 0.30,
              ),
              ShimmerWidget(
                width: MediaQuery.of(context).size.width * 0.20,
              )
            ],
          ),
          const SizedBox(
            height: 12.0,
          ),
        ],
      ),
    );
  }

  Widget buildPodcastInfoWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                //podcast image
                child: Hero(
                  tag: 'logo${widget.podcastInfo.collectionId}',
                  child: Container(
                    width: 100.0,
                    height: 100.0,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Image.network(
                      widget.podcastInfo.bestArtworkUrl ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 16.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //podcast name
                  Container(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width * 0.60,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.podcastInfo.collectionName ?? 'N/A',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8.0,
                      ),
                      buildDateCountryRow(),
                      const SizedBox(
                        height: 4.0,
                      ),
                      buildGenreWidget(context),
                    ],
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Consumer(
                builder: (context, PodcastProvider podcastProvider, child) {
                  bool _isSubbed = podcastProvider.isSubscribedToPodcast;
                  bool _isLoading = podcastProvider.isLoading;
                  return _isLoading
                      ? SizedBox(
                          width: 110.0,
                          height: 1.0,
                          child: LinearProgressIndicator(
                            color: Theme.of(context).colorScheme.secondary,
                            backgroundColor: Theme.of(context).highlightColor,
                            minHeight: 1,
                          ),
                        )
                      : buildSubscribeWidget(_isSubbed, podcastProvider);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  children: [
                    Text(
                      "Content Advisory: ",
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${widget.podcastInfo.contentAdvisoryRating}",
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12.0,
          ),
          buildAboutWidget(context),
          const SizedBox(
            height: 12.0,
          ),
        ],
      ),
    );
  }

  Row buildDateCountryRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          DateFormat('yMMMd').format(widget.podcastInfo.releaseDate!),
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          width: 18.0,
        ),
        Text(
          widget.podcastInfo.country ?? '',
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  InkWell buildSubscribeWidget(
      bool _isSubbed, PodcastProvider podcastProvider) {
    return InkWell(
      onTap: () {
        _isSubbed
            ? podcastProvider.removeFromSubscriptionsAction(widget.podcastInfo)
            : podcastProvider.saveToSubscriptionsAction(widget.podcastInfo);
      },
      child: AnimatedContainer(
        constraints: BoxConstraints(
            minWidth: _isSubbed ? 360.w : 340.w,
            maxWidth: _isSubbed ? 360.w : 340.w),
        decoration: BoxDecoration(
          color: _isSubbed
              ? Colors.green.withOpacity(0.2)
              : Colors.orange.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.all(8.0),
        duration: const Duration(milliseconds: 500),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isSubbed ? 'Subscribed' : 'Subscribe',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: _isSubbed ? Colors.green : Colors.orange,
              ),
            ),
            const SizedBox(
              width: 12.0,
            ),
            Icon(
              _isSubbed ? FeatherIcons.checkCircle : FeatherIcons.plusCircle,
              color: _isSubbed ? Colors.green : Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Container buildAboutWidget(BuildContext context) {
    final playlistRepository = getIt<PlaylistRepository>();
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ExpandablePanel(
        header: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            "About Podcast".tr(),
            style: const TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        collapsed: Container(),
        expanded: Consumer(
          builder: (context, PodcastProvider podcastProvider, child) {
            String? _description = podcastProvider.podcast?.description;
            bool _isLoading = podcastProvider.isLoading;
            return _isLoading
                ? SizedBox(
                    width: 200.0,
                    height: 1.0,
                    child: LinearProgressIndicator(
                      backgroundColor: Theme.of(context).highlightColor,
                      minHeight: 1,
                    ),
                  )
                : Html(
                    data: _description,
                  );
          },
        ),
      ),
    );
  }

  Container buildGenreWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.60,
      child: Wrap(
        children: widget.podcastInfo.genre!.map(
          (i) {
            int x = widget.podcastInfo.genre!.indexOf(i);
            int l = widget.podcastInfo.genre!.length;
            String gName = i.name;
            if (x < l - 1) gName += ", ";
            return Text(
              gName,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  Expanded buildEpisodesListLoading() {
    return Expanded(
        child: ListView.separated(
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Divider(
            color: Colors.grey,
          ),
        );
      },
      itemCount: 10,
      itemBuilder: (context, index) {
        return DetailedEpsiodeViewLoadingWidget();
      },
    ));
  }
}
