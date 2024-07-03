import 'package:flutter/material.dart';

extension SnackbarExtension on BuildContext {
  void showSnackbar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
