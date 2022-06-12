import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:smarter/providers/settings_provider.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('EventsScreen build called');
    bool isAlreadyLoggedIn =
        Provider.of<SettingsProvider>(context, listen: false)
            .getIsAlreadyLoggedIn(context);
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return !isAlreadyLoggedIn
            ? Text('Log in to access your subscriptions'.tr())
            : Text('Logged in '.tr());
      },
    );
  }
}
