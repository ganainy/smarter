import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  bool isAlreadyLoggedIn(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return true;
    }
    return false;
  }
}
