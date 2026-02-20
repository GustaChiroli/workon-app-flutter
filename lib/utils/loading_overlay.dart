import 'package:flutter/material.dart';

class LoadingOverlay {
  static bool _isShown = false;

  static void show(BuildContext context) {
    if (_isShown) return;
    _isShown = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  static void hide(BuildContext context) {
    if (_isShown) {
      Navigator.of(context, rootNavigator: true).pop();
      _isShown = false;
    }
  }
}
