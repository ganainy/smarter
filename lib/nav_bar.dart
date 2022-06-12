import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarter/providers/settings_provider.dart';

import 'layouts/home/home_provider.dart';
import 'models/languages.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);
    var homeProvider = Provider.of<HomeProvider>(context);

    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: Text('Settings'.tr(),
                style: Theme.of(context).textTheme.headline1),
          ),
          const Divider(),
          ListTile(
            title: Text('Dark Mode'.tr()),
            trailing: Switch(
              value: settingsProvider.isDarkMode,
              onChanged: (bool value) {
                settingsProvider.toggleDarkMode();
              },
            ),
          ),
          ListTile(
            title: ExpansionTile(
              title: Text('App language'.tr()),
              children: <Widget>[
                ListTile(
                    title: Text('English'.tr()),
                    onTap: () {
                      settingsProvider.changeLocale(Languages.en);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                    title: Text('German'.tr()),
                    onTap: () {
                      settingsProvider.changeLocale(Languages.de);
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          ),
          ListTile(
            title: ExpansionTile(
              title: Text('Top podcasts language'.tr()),
              children: <Widget>[
                ListTile(
                    title: Text('English'.tr()),
                    onTap: () {
                      homeProvider.changeTopPodcastsLanguage(Languages.en);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                    title: Text('German'.tr()),
                    onTap: () {
                      homeProvider.changeTopPodcastsLanguage(Languages.de);
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          ),
          const LogoutButton()
        ],
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Provider.of<SettingsProvider>(context, listen: false)
        .getIsAlreadyLoggedIn(context);
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return settingsProvider.isAlreadyLoggedIn
            ? Row(
                children: [
                  TextButton.icon(
                    icon: const Icon(
                      Icons.output,
                      color: Colors.black,
                    ), // Your icon here
                    label: Text(
                      'Sign out'.tr(),
                      style: const TextStyle(color: Colors.black),
                    ), // Your text here
                    onPressed: () {
                      Provider.of<HomeProvider>(context, listen: false)
                          .signOut(context: context);
                    },
                  ),
                ],
              )
            : Container();
      },
    );
  }
}
