import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarter/providers/settings.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingsProvider>(context);

    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: Text('Settings'.tr(),
                style: Theme.of(context).textTheme.headline1),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.brightness_2_rounded),
            title: Text('Dark Mode'.tr()),
            trailing: Switch(
              value: settingsProvider.isDarkMode,
              onChanged: (bool value) {
                settingsProvider.toggleDarkMode();
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: ExpansionTile(
              title: Text('Language'.tr()),
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
        ],
      ),
    );
  }
}
