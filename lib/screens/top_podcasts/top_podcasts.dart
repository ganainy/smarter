import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:provider/provider.dart';

import '../../layouts/home/home_provider.dart';
import '../../shared/podcast_display_widget.dart';
import '../podcast/podcast.dart';

class TopPodcastsScreen extends StatelessWidget {
  const TopPodcastsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        top: 18.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer(builder: (context, HomeProvider homeProvider, child) {
            var _isLoading = homeProvider.isLoading;
            var _topPodcasts = homeProvider.topPodcasts;

            return _isLoading
                ? Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      strokeWidth: 1.0,
                    ),
                  )
                : _topPodcasts.isEmpty
                    ? Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.50,
                            alignment: Alignment.center,
                            child: Text(
                              "No Podcasts to show".tr(),
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      )
                    : buildTopPodcastsList(_topPodcasts, context);
          }),
        ],
      ),
    );
  }

  Widget buildTopPodcastsList(List<Item> _topPodcasts, BuildContext context) {
    //return SizedBox();

    return Expanded(
        child: GridView.count(
      shrinkWrap: true,
      childAspectRatio: 1 / 1.3,
      children: [
        ..._topPodcasts.map((podcast) {
          return Padding(
            padding: const EdgeInsets.only(
                top: 4.0, bottom: 4.0, left: 2.0, right: 2.0),
            child: InkWell(
              onTap: () {
                /*   Navigator.pushNamed(context, AppRoutes.podcast,);*/
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 500),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      final tween = Tween(begin: begin, end: end);
                      final curvedAnimation = CurvedAnimation(
                        parent: animation,
                        curve: curve,
                      );

                      return SlideTransition(
                        position: tween.animate(curvedAnimation),
                        child: child,
                      );
                    },
                    pageBuilder: (_, __, ___) => PodcastScreen(
                      podcastInfo: podcast,
                    ),
                  ),
                );
              },
              child: Hero(
                tag: 'logo${podcast.collectionId}',
                child: PodcastDisplayWidget(
                  name: podcast.collectionName ?? 'N/A',
                  posterUrl: podcast.bestArtworkUrl ?? '',
                  context: context,
                ),
              ),
            ),
          );
        })
      ].toList(),
      crossAxisCount: 3,
    ));
  }
}
