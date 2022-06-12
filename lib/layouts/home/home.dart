import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smarter/screens/top_podcasts/top_podcasts.dart';

import '../../models/languages.dart';
import '../../nav_bar.dart';
import '../../providers/settings_provider.dart';
import '../../screens/events/events.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({Key? key}) : super(key: key);

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

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: const SafeArea(
            child: TabBarView(
              children: [
                TopPodcastsScreen(),
                EventsScreen(),
              ],
            ),
          ),
          drawer: NavBar(),
          appBar: AppBar(
            title: Text(
              'Podcastle',
              style: GoogleFonts.pacifico(),
            ),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.podcasts)),
                Tab(icon: Icon(Icons.event)),
              ],
            ),
          ),
        ));
  }
}
