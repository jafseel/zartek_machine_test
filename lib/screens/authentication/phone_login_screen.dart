import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zartek_machine_test/notifiers/loader_notifier.dart';
import 'package:zartek_machine_test/routes.dart';
import 'package:zartek_machine_test/utils/mask_text_input_formatter.dart';
import 'package:zartek_machine_test/utils/extension_functions.dart'
    show ScreenLoader;

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({Key? key}) : super(key: key);

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _otpSentNotifier = _OtpSentNotifier();
  FirebaseAuth _auth = FirebaseAuth.instance;

  final _phoneController = TextEditingController();

  final _passController = TextEditingController();
  late final OtpLoadingNotifier _otpLoadingNotifier;

  @override
  void initState() {
    _otpLoadingNotifier =
        Provider.of<OtpLoadingNotifier>(context, listen: false);
    _otpLoadingNotifier.reset();
    super.initState();
  }

  String? _verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(30),
      child: Form(
        key: _formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Login",
              style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 30,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            TextFormField(
              inputFormatters: [
                MaskTextInputFormatter(
                    mask: "###-###-####", filter: {"#": RegExp(r'[0-9]')})
              ],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  prefix: Text('+91 '),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Colors.grey.shade200)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Colors.grey.shade300)),
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintText: "Phone Number"),
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return "* Required";
              //   } else if (value.length < 12) {
              //     return "Inavalid Phone Number";
              //   } else
              //     return null;
              // },
              controller: _phoneController,
            ),
            const SizedBox(height: 5),
            Align(
                alignment: Alignment.centerRight,
                child: ChangeNotifierProvider<_OtpSentNotifier>.value(
                  value: _otpSentNotifier,
                  child: Builder(builder: (context) {
                    final _provider = context.watch<_OtpSentNotifier>();
                    return TextButton(
                        onPressed: _provider._otpSent
                            ? null
                            : () {
                                final phone = _phoneController.text.trim();
                                if (phone.length == 12) {
                                  // debugPrint('mjm phone: $phone');
                                  _registerUser('+91 $phone', context);
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                        "Please enter a valid phone number"),
                                  ));
                                }
                              },
                        child: const Text('Get OTP'));
                  }),
                )),
            const SizedBox(height: 5),
            TextFormField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 6,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Colors.grey.shade200)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Colors.grey.shade300)),
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintText: "OTP"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "* Required";
                } else if (value.length < 6) {
                  return "Inavalid OTP";
                } else
                  return null;
              },
              controller: _passController,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  child: const Text("Cancel",
                      style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                      side: const BorderSide(
                        width: 1,
                        color: Colors.blue,
                      ),
                      primary: Colors.white,
                      padding: const EdgeInsets.all(16)),
                  onPressed: () => Navigator.of(context).pop(),
                )),
                const SizedBox(width: 15),
                Expanded(
                  child: ChangeNotifierProvider<_OtpSentNotifier>.value(
                      value: _otpSentNotifier,
                      child: Builder(builder: (context) {
                        final _provider = context.watch<_OtpSentNotifier>();
                        return ElevatedButton(
                          child: const Text("Login",
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              padding: const EdgeInsets.all(16)),
                          onPressed: _provider.otpSent
                              ? () {
                                  //code for sign in
                                  if (_formkey.currentState?.validate() ==
                                          true &&
                                      _verificationId != null) {
                                    _verifyOtp(PhoneAuthProvider.credential(
                                        verificationId: _verificationId!,
                                        smsCode: _passController.text.trim()));
                                  } else {
                                    debugPrint("Not Validated");
                                  }
                                }
                              : null,
                        );
                      })),
                )
              ],
            )
          ],
        ),
      ),
    ).setScreenLoader<OtpLoadingNotifier>());
  }

  void _registerUser(String mobile, BuildContext context) async {
    _otpLoadingNotifier.isLoading = true;

    await _auth.verifyPhoneNumber(
        phoneNumber: mobile,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (authCredential) async {
          debugPrint("verification completed ${authCredential.smsCode}");
          _verifyOtp(authCredential);
        },
        verificationFailed: (exception) {
          _closeProgress();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(exception.message ?? 'Something went wrong!')));
          debugPrint(
              "verificationFailed exception : ${exception.message}  ${exception.phoneNumber}");
          exception.stackTrace;
        },
        codeSent: (verificationId, resendToken) async {
          _verificationId = verificationId;
          _closeProgress();
          _otpSentNotifier.otpSent = true;
          debugPrint(
              "codeSent completed verificationId: $verificationId  resendToken: $resendToken");
        },
        codeAutoRetrievalTimeout: (verificationId) {});
  }

  void _closeProgress() {
    _otpLoadingNotifier.isLoading = false;
  }

  void _verifyOtp(PhoneAuthCredential credential) async {
    _otpLoadingNotifier.isLoading = true;
    // // Sign the user in (or link) with the credential
    try {
      await _auth.signInWithCredential(credential);
    } catch (e) {}
    _closeProgress();
    final user = _auth.currentUser;
    if (user != null) {
      debugPrint('User is signed in!');
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.HOME, (route) => false);
    }
  }

  @override
  void dispose() {
    _otpSentNotifier.dispose();
    super.dispose();
  }
}

class _OtpSentNotifier extends ChangeNotifier {
  bool _otpSent = false;

  bool get otpSent => _otpSent;
  set otpSent(newValue) {
    if (_otpSent != newValue) {
      _otpSent = newValue;
      notifyListeners();
    }
  }

  void reset() {
    _otpSent = false;
  }
}
