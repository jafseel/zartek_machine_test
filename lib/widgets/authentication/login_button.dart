import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final GestureTapCallback? onTap;
  final String label;
  final Widget? icon;
  final Gradient? gradient;
  const SocialLoginButton(
      {Key? key, this.onTap, required this.label, this.icon, this.gradient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap!();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: gradient ??
              const LinearGradient(
                colors: [
                  Color(0xFF4286F5),
                  Color(0xFF4286F5),
                  Color(0xFF4286F5),
                ],
              ),
        ),
        child: Stack(
          children: [
            icon ?? const SizedBox(),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      height: 1.4,
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }
}
