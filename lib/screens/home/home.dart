import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarter/providers/home_provider.dart';

import '../../nav_bar.dart';
import '../../providers/settings_provider.dart';
import '../../shared/podcast_display_widget.dart';
import '../podcast/podcast.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);

    switch (settingsProvider.language) {
      case Languages.en:
        context.setLocale(const Locale('en', 'US'));
        break;
      case Languages.de:
        context.setLocale(const Locale('de', 'DE'));
        break;
      default:
        break;
    }

    return Scaffold(
      drawer: NavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [TopPodcasts(context: context)],
          ),
        ),
      ),
    );
  }
}

class TopPodcasts extends StatelessWidget {
  const TopPodcasts({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Discover".tr(),
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Top podcasts today".tr(),
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.settings),
              )
            ],
          ),
          const SizedBox(
            height: 16.0,
          ),
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
                    : Wrap(
                        children: _topPodcasts.map((_item) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 4.0, bottom: 4.0, left: 2.0, right: 2.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(milliseconds: 500),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
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
                                    podcastInfo: _item,
                                  ),
                                ),
                              );
                            },
                            child: Hero(
                              tag: 'logo${_item.collectionId}',
                              child: PodcastDisplayWidget(
                                name: _item.collectionName ?? 'N/A',
                                posterUrl: _item.bestArtworkUrl ?? '',
                                context: context,
                              ),
                            ),
                          ),
                        );
                      }).toList());
          }),
        ],
      ),
    );
  }
}
