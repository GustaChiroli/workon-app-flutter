import 'package:flutter/material.dart';

enum SnackType { success, error, info }

class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    SnackType type = SnackType.info,
  }) {
    Color backgroundColor;

    switch (type) {
      case SnackType.success:
        backgroundColor = const Color(0xFF166534); // verde dark
        break;
      case SnackType.error:
        backgroundColor = const Color(0xFFFF6900); // vermelho elegante
        break;
      case SnackType.info:
      default:
        backgroundColor = const Color(0xFF1E3A8A); // azul dark
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
