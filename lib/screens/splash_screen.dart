import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zartek_machine_test/routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      final user = FirebaseAuth.instance.currentUser;
      final String routeName;
      if (user == null) {
        routeName = Routes.LOGIN;
        debugPrint('User is currently signed out!');
      } else {
        routeName = Routes.HOME;
        // routeName = Routes.LOGIN;
        debugPrint('User is signed in!');
      }
      Navigator.of(context).pushReplacementNamed(routeName);
    });

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image.asset(
            'assets/images/img_logo.png',
            height: 50,
          ),
        ),
      ),
    );
  }
}
