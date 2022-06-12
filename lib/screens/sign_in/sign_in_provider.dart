import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInProvider with ChangeNotifier {
  bool isSigningIn = false;

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    isSigningIn = true;
    notifyListeners();

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount == null) {
      isSigningIn = false;
      notifyListeners();
      return null;
    }

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    try {
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

      user = userCredential.user;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome ${user?.displayName}.'.tr())));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Invalid credentials.'.tr())));
        // handle the error here
      } else if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Invalid credentials.'.tr())));
        // handle the error here
      }
    } catch (e) {
      // handle the error here
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Something went wrong.'.tr())));
    } finally {
      isSigningIn = false;
      notifyListeners();
    }

    return user;
  }

  Future<UserCredential?> signInAnonymously(BuildContext context) async {
    isSigningIn = true;
    notifyListeners();

    try {
      return await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error. ${e.code} ${e.message}");
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Something went wrong.'.tr())));
      return null;
    } finally {
      isSigningIn = false;
      notifyListeners();
    }
  }
}
