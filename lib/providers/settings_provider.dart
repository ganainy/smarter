import 'package:flutter/foundation.dart';

enum Languages { en, de }

class SettingsProvider with ChangeNotifier {
  bool isDarkMode = false;
  Languages? language;

  void toggleDarkMode() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  void changeLocale(Languages languages) {
    language = languages;
    notifyListeners();
  }
}
