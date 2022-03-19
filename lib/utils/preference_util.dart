import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zartek_machine_test/model/restaurant.dart' show CategoryDish;

class SharedPreferenceUtil {
  SharedPreferenceUtil._();

  static final SharedPreferenceUtil _instance = SharedPreferenceUtil._();
  factory SharedPreferenceUtil() {
    return _instance;
  }

  late final SharedPreferences _prefs;
  void initPreference() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void saveCartList(List<CategoryDish>? carts) {
    _prefs.setStringList('carts',
        carts?.map((e) => jsonEncode(e.toJson())).toList() ?? List.empty());
  }

  List<CategoryDish> getCartList() {
    List<String> carts = [];
    if (_prefs.containsKey('carts')) {
      carts = _prefs.getStringList('carts') ?? List.empty();
    }
    final cartList =
        carts.map((e) => CategoryDish.fromJson(jsonDecode(e))).toList();
    return cartList;
  }
}
