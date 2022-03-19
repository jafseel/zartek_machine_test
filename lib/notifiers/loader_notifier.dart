import 'package:flutter/foundation.dart';

abstract class LoadingNotifer extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void reset({bool loading = false}) {
    _isLoading = loading;
  }
}

class LoginLoadingNotifier extends LoadingNotifer {}

class OtpLoadingNotifier extends LoadingNotifer {}
