import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zartek_machine_test/network/api_service.dart';
import 'package:zartek_machine_test/notifiers/cart_provider.dart';
import 'package:zartek_machine_test/routes.dart';
import 'package:zartek_machine_test/utils/app_constant.dart';
import 'package:zartek_machine_test/widgets/home/food_veg.dart';
import 'package:zartek_machine_test/widgets/home/qunatity_picker.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key, this.primaryColor = const Color(0xFF1A3F14)})
      : super(key: key);

  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.grey),
          title: const Text(
            'Order Summary',
            style: TextStyle(color: Colors.grey),
          )),
      body: Consumer<CartProvider>(
        builder: (context, value, child) => value.cartList.isEmpty
            ? const Center(child: Text("No data found!"))
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Card(
                        margin: const EdgeInsets.all(15),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: [
                            Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  '${value.cartList.length} Dishes - ${value.totalItems} Items',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                )),
                            const SizedBox(height: 10),
                            ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final product = value.cartList[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FoodVegOrNot(isVeg: product.isVeg),
                                        const SizedBox(width: 5),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.dishName,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                                '${Constants.CURRENCY} ${product.price}',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            const SizedBox(width: 5),
                                            Text(
                                                '${product.calories?.replaceAll('.0', '')} Calories',
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w300)),
                                          ],
                                        )),
                                        const SizedBox(width: 5),
                                        QuantityPicker(
                                          width: 120,
                                          backgroundColor: primaryColor,
                                          initValue: product.cartQuantity,
                                          quantittyChanged: (qty, action) =>
                                              value.updateCart(product, qty,
                                                  isNotify: false),
                                        ),
                                        const SizedBox(width: 7),
                                        Text(
                                            '${Constants.CURRENCY} ${product.total}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400)),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemCount: value.cartList.length),
                            const Divider(),
                            const SizedBox(height: 3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total Amount',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 16)),
                                Text(
                                  '${Constants.CURRENCY} ${value.totalAmout}',
                                  style: const TextStyle(
                                      color: Colors.green, fontSize: 16),
                                )
                              ],
                            ),
                            const SizedBox(height: 8)
                          ]
                              // ..addAll(List.generate(
                              //     10, (index) => ListTile(title: Text('data')))),
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0))),
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => WillPopScope(
                                onWillPop: () async => false,
                                child: AlertDialog(
                                  title: const Text("Success"),
                                  content:
                                      const Text('Order successfully placed'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          value.clearCartList(isNotify: true);
                                          // Navigator.of(context)
                                          //     .pushNamedAndRemoveUntil(
                                          //         Routes.HOME,
                                          //         (route) => false);

                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'))
                                  ],
                                ),
                              ),
                            );
                          },
                          child: const Text('Place Order')))
                ],
              ),
      ),
    ));
  }
}
