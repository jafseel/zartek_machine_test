import 'package:flutter/foundation.dart';
import 'package:zartek_machine_test/model/restaurant.dart' show CategoryDish;
import 'package:zartek_machine_test/utils/preference_util.dart';

class CartProvider extends ChangeNotifier {
  final List<CategoryDish> _cartList = [];
  List<CategoryDish> get cartList => _cartList;
  int _totalItems = 0;
  int get totalItems => _totalItems;

  void initCartList() {
    _cartList.clear();
    _cartList.addAll(SharedPreferenceUtil().getCartList());
    _setTotalItemCount();
  }

  void updateCart(CategoryDish dish, int qty, {bool isNotify = true}) {
    if (qty <= 0) {
      _cartList.removeWhere((element) => element.dishId == dish.dishId);
    } else {
      final index =
          _cartList.indexWhere((element) => element.dishId == dish.dishId);
      if (index >= 0 && _cartList.length > index) {
        _cartList[index].cartQuantity = qty;
      } else {
        dish.cartQuantity = qty;
        _cartList.add(dish);
      }
    }
    _setTotalItemCount();
    SharedPreferenceUtil().saveCartList(_cartList);
    // if (isNotify) {
    notifyListeners();
    // }
  }

  void clearCartList({bool isNotify = true}) {
    _cartList.clear();
    _setTotalItemCount();
    SharedPreferenceUtil().saveCartList(_cartList);
    if (isNotify) {
      notifyListeners();
    }
  }

  String get totalAmout {
    final double total = _cartList
        .map((e) => (double.tryParse(e.price) ?? 1) * e.cartQuantity)
        .fold(0.0, (previousValue, element) => previousValue + element);

    return total.toStringAsFixed(2);
  }

  void _setTotalItemCount() {
    _totalItems = _cartList
        .map((e) => e.cartQuantity)
        .fold(0, (previousValue, element) => previousValue + element);
  }
}
