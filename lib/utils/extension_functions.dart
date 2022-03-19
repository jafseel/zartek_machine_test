import '/notifiers/loader_notifier.dart' show LoadingNotifer;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension ScreenLoader on Widget {
  Widget setScreenLoader<T extends LoadingNotifer>() {
    return Stack(
      children: [
        this,
        Consumer<T>(
          builder: (context, value, child) {
            // print('ScreenLoader isLoading: ${value.isLoading}');
            return (value.isLoading)
                ? const InkWell(
                    child: Opacity(
                        opacity: 0.5,
                        child: Center(
                          child: CircularProgressIndicator(),
                        )),
                  )
                : const SizedBox();
          },
        ),
      ],
    );
  }
}

extension StringFunctions on String? {
  bool get isNullOrEmpty => this == null || this?.trim().isEmpty == true;
}
