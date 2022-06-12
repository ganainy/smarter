import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:smarter/customization/theme.dart';
import 'package:smarter/layouts/home/home.dart';
import 'package:smarter/providers/audio_provider.dart';
import 'package:smarter/providers/settings_provider.dart';
import 'package:smarter/screens/events/events_provider.dart';
import 'package:smarter/screens/podcast/podcast_provider.dart';
import 'package:smarter/screens/sign_in/sign_in.dart';
import 'package:smarter/screens/sign_in/sign_in_provider.dart';
import 'package:smarter/services/database/subscriptions.dart';
import 'package:smarter/services/service_locator.dart';
import 'package:smarter/shared/mini_player.dart';

import 'firebase_options.dart';
import 'layouts/home/home_provider.dart';
import 'navigation/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  //Hive db
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  final database = Directory('${appDocumentDirectory.path}/database');
  Hive.init(database.path);
  Hive.registerAdapter(SubscriptionAdapter());
  await Hive.openBox('subscriptionsBox');
  await Hive.openBox('generalBox');
  await Hive.openBox('historyBox');
  await setupServiceLocator();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('de', 'DE')],
        path:
            'assets/translations', // <-- change the path of the translation files
        fallbackLocale: const Locale('en', 'US'),
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 2160),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => SettingsProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => HomeProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => PodcastProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => AudioProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => SignInProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => EventsProvider(),
            ),
          ],
          child: Consumer<SettingsProvider>(
            builder: (context, settingsProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Podcastle',
                theme: settingsProvider.isDarkMode
                    ? MyTheme.darkTheme
                    : MyTheme.lightTheme,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                initialRoute: getInitialRoute(settingsProvider, context),
                onGenerateRoute: (route) => getRoute(route),
                builder: (context, child) {
                  //to show the mini player over the whole app
                  Provider.of<AudioProvider>(context, listen: false)..init();
                  return Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      child!,
                      SizedBox(height: 110, child: MiniPlayer()),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  /// routing */
  String getInitialRoute(
      SettingsProvider settingsProvider, BuildContext context) {
    if (settingsProvider.getIsAlreadyLoggedIn(context)) {
      return AppRoutes.home;
    } else {
      return AppRoutes.sign_in;
    }
  }

  Route? getRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.sign_in:
        return buildRoute(SignInScreen(), settings: settings);
      case AppRoutes.home:
        return buildRoute(HomeLayout(), settings: settings);
      default:
        return null /*buildRoute(const UnknownRouteScreen(), settings: settings)*/;
    }
  }

  MaterialPageRoute buildRoute(Widget child, {RouteSettings? settings}) =>
      MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => child,
      );
}
