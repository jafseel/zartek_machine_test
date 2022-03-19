import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:zartek_machine_test/custom/custom_tabview.dart';
import 'package:zartek_machine_test/model/restaurant.dart';
import 'package:zartek_machine_test/network/api_service.dart';
import 'package:zartek_machine_test/notifiers/cart_provider.dart';
import 'package:zartek_machine_test/routes.dart';
import 'package:zartek_machine_test/utils/app_constant.dart';
import 'package:zartek_machine_test/utils/extension_functions.dart'
    show StringFunctions;
import 'package:zartek_machine_test/widgets/home/food_veg.dart';
import 'package:zartek_machine_test/widgets/home/qunatity_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    Provider.of<CartProvider>(context, listen: false).initCartList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: const Icon(Icons.menu)),
        actions: [
          Center(
            child: InkWell(
              onTap: () {},
              child: Stack(children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () => Navigator.of(context).pushNamed(Routes.CART),
                ),
                Positioned(
                  right: 8,
                  top: 5,
                  child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(239, 83, 80, 1),
                          shape: BoxShape.circle),
                      child: Consumer<CartProvider>(
                        builder: (context, value, child) => Text(
                          '${value.cartList.length}',
                          style: const TextStyle(fontSize: 10),
                        ),
                      )),
                ),
              ]),
            ),
          )
        ],
      ),
      drawer: Drawer(
          child: Stack(
        children: [
          Container(color: const Color(0xFF4CB050), height: 70),
          ListView(
            children: [
              DrawerHeader(
                  margin: EdgeInsets.zero,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16)),
                      gradient: LinearGradient(
                          colors: [Color(0xFF4CB050), Color(0xFF7DD857)])),
                  child: Center(
                    //
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          child: ClipOval(
                            child: Image.network(
                              // 'https://via.placeholder.com/150',
                              'https://png.pngtree.com/png-clipart/20200224/original/pngtree-cartoon-color-simple-male-avatar-png-image_5230557.jpg',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(getName()),
                        const SizedBox(height: 8),
                        Text(_auth.currentUser?.uid ?? "")
                      ],
                    ),
                  )),
              ListTile(
                onTap: () async {
                  await _auth.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(Routes.LOGIN, (route) => false);
                },
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
              )
            ],
          ),
        ],
      )),
      body: FutureBuilder<List?>(
        future: ApiService().execute<List, RestaurantResponse>(
            '5dfccffc310000efc8d2c1ad',
            isGet: true,
            isThrowExc: true),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == null ||
                snapshot.data!.isEmpty ||
                snapshot.data?.first is! RestaurantResponse) {
              return const Center(
                  child: Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('No data found'),
              ));
            }
            final List<TableMenu> productsWithCat =
                snapshot.data?.first.menus ?? List.empty();
            debugPrint('products size: ${productsWithCat.length}');
            return Stack(
              children: [
                Container(
                    height: 2,
                    color: Colors.grey.shade300,
                    margin: const EdgeInsets.only(top: 28)),
                CustomTabView(
                  initPosition: 0,
                  itemCount: productsWithCat.length,
                  tabBuilder: (context, index) =>
                      Tab(text: productsWithCat[index].menuCategory),
                  pageBuilder: (context, index) => ListView.separated(
                    separatorBuilder: (context, postion) => const Divider(),
                    itemCount: productsWithCat[index].dishes?.length ?? 0,
                    itemBuilder: (context, childIndex) {
                      final product =
                          productsWithCat[index].dishes![childIndex];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FoodVegOrNot(isVeg: product.isVeg),
                            const SizedBox(width: 5),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.dishName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '${Constants.CURRENCY} ${product.price}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500)),
                                    Text(
                                        '${product.calories?.replaceAll('.0', '')} Calories',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  product.description,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                      color: Colors.grey),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 7),
                                Consumer<CartProvider>(
                                    builder: (context, value, child) {
                                  final CategoryDish cartItem = value.cartList
                                      .firstWhere(
                                          (element) =>
                                              element.dishId == product.dishId,
                                          orElse: () => product);
                                  return QuantityPicker(
                                    width: 120,
                                    initValue: cartItem.cartQuantity,
                                    quantittyChanged: (qty, action) =>
                                        value.updateCart(cartItem, qty),
                                  );
                                }),
                                const SizedBox(height: 5),
                                product.addons != null &&
                                        product.addons!.isNotEmpty
                                    ? const Text(
                                        'Customizations available',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12,
                                            color: Colors.red),
                                      )
                                    : const SizedBox(),
                              ],
                            )),
                            const SizedBox(width: 5),
                            FadeInImage.assetNetwork(
                              placeholder: Constants.PLACEHOLDER,
                              image: product.image ?? "",
                              fit: BoxFit.cover,
                              width: 85,
                              imageErrorBuilder: (c, o, s) => Image.asset(
                                  Constants.PLACEHOLDER,
                                  width: 85,
                                  fit: BoxFit.cover),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // _listview(productsWithCat[index].products),
                  onPositionChange: (index) {
                    debugPrint('current position: $index');
                    // initPosition = index;
                  },
                  onScroll: (position) => debugPrint('$position'),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  )
                ],
              ),
            );
          } else {
            return const InkWell(
              child: SafeArea(
                child: Center(
                  child: SizedBox(
                    child: CircularProgressIndicator(),
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  String getName() {
    final user = _auth.currentUser;
    if (user?.displayName?.isNullOrEmpty == false) {
      return user!.displayName!;
    } else if (user?.email?.isNullOrEmpty == false) {
      return user!.email!;
    } else if (user?.phoneNumber?.isNullOrEmpty == false) {
      return user!.phoneNumber!;
    } else {
      return "User";
    }
  }
}
