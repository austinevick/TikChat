import 'package:flutter/material.dart';

import '../common/utils.dart';

class LoadingDialog {
  static void show() => showDialog(
      context: navigatorKey.currentContext!,
      builder: (ctx) => Container(
            color: Colors.black87.withOpacity(0.1),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ));
  static void hide() => Navigator.of(navigatorKey.currentContext!).pop();
}
