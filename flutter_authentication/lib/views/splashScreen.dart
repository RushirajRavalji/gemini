import 'package:flutter/material.dart';
import 'package:flutter_authentication/provider/authProvider.dart';
import 'package:flutter_authentication/views/homeScreen.dart';
import 'package:flutter_authentication/views/optionScreen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final authProvider = Get.find<Authprovider>();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');
    final String? password = prefs.getString('password');

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        if (email != null &&
            password != null &&
            email.isNotEmpty &&
            password.isNotEmpty) {
          // Redirect to HomeScreen if credentials exist
          authProvider.setEmail(email);
          authProvider.setPassword(password);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          // Redirect to LoginScreen if credentials are not found
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OptionScreen()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Image.asset(
                "assets/gemini.png",
                width: width * 0.25,
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 40.0),
                child: Text(
                  "Gemini Plus",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
