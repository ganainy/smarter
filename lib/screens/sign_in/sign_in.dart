import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarter/providers/sign_in_provider.dart';

import '../../shared/google_sign_in_button.dart';
import '../home/home.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Image.asset(
                        'assets/images/podcast.png',
                        height: 160,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Welcome to Podcastle'.tr(),
                      style: TextStyle(
                        fontSize: 40,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              GoogleSignInButton(),
              AnonymousSignInButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class AnonymousSignInButton extends StatelessWidget {
  const AnonymousSignInButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SignInProvider>(
      builder: (context, signInProvider, child) {
        return MaterialButton(
            child: Text('Continue as a guest'.tr()),
            onPressed: () async {
              var userCredential =
                  await signInProvider.signInAnonymously(context);
              if (userCredential != null) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              }
            });
      },
    );
  }
}