import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smarter/customization/theme.dart';
import 'package:smarter/providers/settings.dart';

import 'nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

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
          ],
          child: Consumer<SettingsProvider>(
            builder: (context, provider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: provider.isDarkMode
                    ? MyTheme.darkTheme
                    : MyTheme.lightTheme,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                home: const MyHomePage(),
                routes: {
                  //ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                },
              );
            },
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      appBar: AppBar(
        title: Text('Test'.tr()),
      ),
      drawer: NavBar(),
      body: Center(),
    );
  }
}
