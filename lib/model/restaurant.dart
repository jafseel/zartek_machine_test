class RestaurantResponse {
  late final String restaurantId, restaurantName;
  late final List<TableMenu>? menus;

  RestaurantResponse.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurant_id'];
    restaurantName = json['restaurant_name'];
    menus =
        (json['table_menu_list'] != null && json['table_menu_list'] is Iterable)
            ? (json['table_menu_list'] as Iterable)
                .map((e) => TableMenu.fromJson(e))
                .toList()
            : List.empty();
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['success'] = this.success;
  //   // data['data'] = this.data?.toJson();
  //   data['message'] = this.message;
  //   return data;
  // }
}

class TableMenu {
  late final String menuCategory;
  late final List<CategoryDish>? dishes;

  TableMenu.fromJson(Map<String, dynamic> json) {
    menuCategory = json['menu_category']?.toString() ?? "";
    dishes =
        (json['category_dishes'] != null && json['category_dishes'] is Iterable)
            ? (json['category_dishes'] as Iterable)
                .map((e) => CategoryDish.fromJson(e))
                .toList()
            : List.empty();
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['success'] = this.success;
  //   // data['data'] = this.data?.toJson();
  //   data['message'] = this.message;
  //   return data;
  // }
}

class CategoryDish {
  late final String dishName, price, description, dishId;
  late final String? _dishType, image, calories;
  late final List<Addon>? addons;
  int cartQuantity = 0;

  bool get isVeg => _dishType == "1";
  String get total =>
      ((double.tryParse(price) ?? 0) * cartQuantity).toStringAsFixed(2);

  CategoryDish.fromJson(Map<String, dynamic> json) {
    dishName = json['dish_name'];
    dishId = json['dish_id'].toString();
    price = json['dish_price']?.toString() ?? "";
    image = json['dish_image']?.toString() ?? "";
    calories = json['dish_calories']?.toString() ?? "";
    description = json['dish_description']?.toString() ?? "";
    _dishType = json['dish_Type']?.toString().trim() ?? "";
    cartQuantity = json['cart_quantity'] ?? 0;
    addons = (json['addonCat'] != null && json['addonCat'] is Iterable)
        ? (json['addonCat'] as Iterable).map((e) => Addon.fromJson(e)).toList()
        : List.empty();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dish_name'] = dishName;
    data['dish_id'] = dishId;
    data['dish_price'] = price;
    data['dish_image'] = image;
    data['dish_calories'] = calories;
    data['dish_Type'] = _dishType;
    data['cart_quantity'] = cartQuantity;
    return data;
  }
}

class Addon {
  late final String category;

  Addon.fromJson(Map<String, dynamic> json) {
    category = json['addon_category']?.toString() ?? "";
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['success'] = this.success;
  //   // data['data'] = this.data?.toJson();
  //   data['message'] = this.message;
  //   return data;
  // }
}
