// Function to show session expired dialog and force login
import 'package:flutter/material.dart';
import 'package:flutter_authentication/auth/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionHelper {
  static void showSessionExpiredDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from dismissing dialog
      builder: (context) => AlertDialog(
        title: Text("Session Expired", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
        content: Text("Your session has expired. Please login again."),
        actions: [
          TextButton(
            onPressed: () async {
              await _clearUserData();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: const Text(
              "Ok",
              style: TextStyle(fontSize: 16, color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }
}

// Function to clear user data from shared preferences
Future<void> _clearUserData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final SharedPreferences prefsToken = await SharedPreferences.getInstance();
  await prefs.clear();
  await prefsToken.clear();
}
