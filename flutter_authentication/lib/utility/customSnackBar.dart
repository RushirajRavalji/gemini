import 'package:flutter/material.dart';

class CustomSnackbar {
  final String text;
  final Color color;

  CustomSnackbar({required this.text, required this.color});

  void show(BuildContext context) {
    final snackBar = SnackBar(
      margin: const EdgeInsets.all(10),
      content: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
