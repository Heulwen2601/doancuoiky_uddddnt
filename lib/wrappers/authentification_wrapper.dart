import 'package:do_an_ck_uddddnt/screens/home/home_screen.dart';
import 'package:do_an_ck_uddddnt/screens/sign_in/sign_in_screen.dart';
import 'package:do_an_ck_uddddnt/services/authentification/authentification_service.dart';
import 'package:flutter/material.dart';

class AuthentificationWrapper extends StatelessWidget {
  static const String routeName = "/authentification_wrapper";
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthentificationService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomeScreen();
        } else {
          return SignInScreen();
        }
      },
    );
  }
}
