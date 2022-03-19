import 'package:flutter/material.dart';
import 'package:zartek_machine_test/routes.dart';
import 'package:zartek_machine_test/widgets/authentication/login_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(
                    'assets/images/logo_firebase.png',
                    height: 200,
                    width: 200,
                    fit: BoxFit.contain,
                  ),
                )),
            Expanded(
                flex: 2,
                child: Column(
                  children: [
                    SocialLoginButton(
                      label: 'Google',
                      icon: Image.asset(
                        'assets/icons/ic_google.png',
                        height: 24,
                      ),
                      onTap: () => _signInWithGoogle(context),
                    ),
                    const SizedBox(height: 8),
                    SocialLoginButton(
                      label: 'Phone',
                      icon: const Icon(
                        Icons.phone,
                        size: 24,
                        color: Colors.white,
                      ),
                      onTap: () =>
                          Navigator.of(context).pushNamed(Routes.LOGIN_PHONE),
                      // _showDialog(context),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF7DD857),
                          Color(0xFF4CAF50),
                        ],
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  // Future<UserCredential> signInWithGoogle() async {
  void _signInWithGoogle(context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    var result = await FirebaseAuth.instance.signInWithCredential(credential);
    debugPrint('signInWithGoogle name: ${result.user?.displayName}');
    if (result.user != null) {
      Navigator.of(context).pushReplacementNamed(Routes.HOME);
    }
  }

  // void _showDialog(context) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) => Dialog(
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(12.0)), //this right here
  //             child: Container(
  //               padding: const EdgeInsets.all(10),
  //               height: 300.0,
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: <Widget>[
  //                   const Padding(
  //                     padding: EdgeInsets.all(15.0),
  //                     child: Text(
  //                       'Enter your phone Number',
  //                       style: TextStyle(color: Colors.red),
  //                     ),
  //                   ),
  //                   TextField(
  //                     onChanged: (text) {
  //                       debugPrint("onChanged text: $text");
  //                     },
  //                     textInputAction: TextInputAction.done,
  //                     keyboardType: TextInputType.number,
  //                     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  //                     autofocus: true,
  //                     decoration: InputDecoration(
  //                       labelText: "Enter Phone",
  //                       prefix: Text("+91 "),
  //                       isDense: true,
  //                       contentPadding: EdgeInsets.symmetric(
  //                           vertical: 15.0, horizontal: 10.0),
  //                       border: OutlineInputBorder(
  //                           borderSide:
  //                               BorderSide(color: Colors.grey, width: 3.0)),
  //                     ),
  //                   ),
  //                   const Padding(padding: EdgeInsets.only(top: 50.0)),
  //                   TextButton(
  //                       onPressed: () {
  //                         Navigator.of(context).pop();
  //                       },
  //                       child: const Text(
  //                         'Got It!',
  //                         style:
  //                             TextStyle(color: Colors.purple, fontSize: 18.0),
  //                       ))
  //                 ],
  //               ),
  //             ),
  //           ));
  // }
}
