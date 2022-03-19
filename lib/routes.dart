import 'package:flutter/material.dart';
import 'package:zartek_machine_test/screens/authentication/authentication_screen.dart';
import 'package:zartek_machine_test/screens/authentication/phone_login_screen.dart';
import 'package:zartek_machine_test/screens/cart_screen.dart';
import 'package:zartek_machine_test/screens/home_screen.dart';

class Routes {
  static const String HOME = "/home";
  static const String LOGIN = "/login";
  static const String LOGIN_PHONE = "/login-phone";
  static const String CART = "/cart";
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => _onRouteClass(settings));
    // switch (settings.name) {
    //   case HOME:
    //     return MaterialPageRoute(
    //         // builder: (_) => HomeScreen(id: settings.arguments as String?));
    //         builder: (_) => HomeScreen());
    //   case 'Login':
    //     return MaterialPageRoute(builder: (_) => AuthenticationScreen());
    // }
  }

  static dynamic? _onRouteClass(RouteSettings settings) {
    switch (settings.name) {
      case HOME:
        return const HomeScreen();
      case LOGIN:
        return const AuthenticationScreen();
      case LOGIN_PHONE:
        return const PhoneLoginScreen();
      case CART:
        return const CartScreen();
    }
  }
}
