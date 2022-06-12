import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/languages.dart';

class SettingsProvider with ChangeNotifier {
  bool isDarkMode = false;
  bool isAlreadyLoggedIn = false;
  Languages? language;

  void toggleDarkMode() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  void changeLocale(Languages languages) {
    language = languages;
    notifyListeners();
  }

  //this method will return false if logged in as anonymous or logged out
  //will return true only if logged in by google account
  bool getIsAlreadyLoggedIn(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    if (_auth.currentUser?.displayName != null) {
      isAlreadyLoggedIn = true;
      notifyListeners();
      return isAlreadyLoggedIn;
    } else {
      isAlreadyLoggedIn = false;
      notifyListeners();
      return isAlreadyLoggedIn;
    }
  }
}
