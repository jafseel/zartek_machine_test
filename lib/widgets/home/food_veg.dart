import 'package:flutter/material.dart';

class FoodVegOrNot extends StatelessWidget {
  final bool isVeg;
  const FoodVegOrNot({Key? key, required this.isVeg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
          border: Border.all(color: isVeg ? Colors.green : Colors.red),
        ),
        padding: const EdgeInsets.all(3),
        child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: isVeg ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            )));
  }
}
