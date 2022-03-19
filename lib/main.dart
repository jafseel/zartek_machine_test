import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zartek_machine_test/network/api_service.dart';
import 'package:zartek_machine_test/notifiers/cart_provider.dart';
import 'package:zartek_machine_test/notifiers/loader_notifier.dart';
import 'package:zartek_machine_test/routes.dart';
import 'package:zartek_machine_test/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:zartek_machine_test/utils/preference_util.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => LoginLoadingNotifier()),
      ChangeNotifierProvider(create: (context) => OtpLoadingNotifier()),
      ChangeNotifierProvider(create: (context) => CartProvider())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  bool _isInitialized = false;
  initialzeFirebase() async {
    if (_isInitialized) {
      return;
    }
    SharedPreferenceUtil().initPreference();
    HttpOverrides.global = MyHttpOverrides();
    await Firebase.initializeApp();
    _isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    initialzeFirebase();
    ApiService().context = context;
    return MaterialApp(
      // color: Colors.white,
      title: 'Zartek Jafseel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: const AppBarTheme(
            color: Colors.white, iconTheme: IconThemeData(color: Colors.black)),
      ),
      onGenerateRoute: Routes.onGenerateRoute,
      home: const SplashScreen(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
