import 'package:flutter/material.dart';
import 'package:flutter_authentication/services/authServices.dart';
import 'package:flutter_authentication/utility/customSnackBar.dart';
import 'package:flutter_authentication/utility/tokenExpireDailogBox.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authprovider extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var token = ''.obs;

  void setEmail(String newEmail) {
    email.value = newEmail;
  }

  String get getEmail => email.value;

  void setPassword(String newPassword) {
    password.value = newPassword;
  }

  String get getPassword => password.value;

  Future<bool> sendOtp(String email, BuildContext context) async {
    final response = await AuthService.sendOtp(email);

    if (response['success']) {
      CustomSnackbar(
        text: response['message'] ?? "OTP sent successfully.",
        color: Colors.green,
      ).show(context);

      return true;
    } else {
      CustomSnackbar(
        text: response['message'] ?? "Failed to send OTP.",
        color: Colors.red,
      ).show(context);

      return false;
    }
  }

  Future<bool> verifyOtp(String email, String otp, BuildContext context) async {
    final response = await AuthService.verifyOtp(email, otp);

    if (response['success']) {
      // CustomSnackbar(
      //   text: response['message'] ?? "OTP verified successfully.",
      //   color: Colors.green,
      // ).show(context);

      return true;
    } else {
      CustomSnackbar(
        text: response['message'] ?? "Invalid OTP. Please try again.",
        color: Colors.red,
      ).show(context);

      return false;
    }
  }

  Future<bool> signupUser(
      String email, String password, BuildContext context) async {
    final response = await AuthService.signup(email, password);

    if (response['success']) {
      // CustomSnackbar(
      //   text: response['message'] ?? "User registered successfully.",
      //   color: Colors.green,
      // ).show(context);

      return true;
    } else {
      CustomSnackbar(
        text: response['message'] ?? "Failed to register user.",
        color: Colors.red,
      ).show(context);

      return false;
    }
  }

  // Login Function
  Future<bool> loginUser(
      String email, String password, BuildContext context) async {
    final response = await AuthService.loginUser(email, password);

    if (response['success']) {
      // CustomSnackbar(
      //   text: response['message'] ?? "Login successful.",
      //   color: Colors.green,
      // ).show(context);

      return true;
    } else {
      CustomSnackbar(
        text: response['message'] ?? "Login failed.",
        color: Colors.red,
      ).show(context);

      return false;
    }
  }

  // Logout Function
  Future<bool> logoutUser(BuildContext context) async {
    try {
      final response = await AuthService.logoutUser();

      if (response['success']) {
        CustomSnackbar(
          text: response['message'] ?? "Logged out successfully.",
          color: Colors.black,
        ).show(context);

        // Clear the token and other sensitive information from shared preferences
        await _clearUserData();

        return true;
      } else {
        print(response['message']);
        CustomSnackbar(
          text: response['message'] ?? "Logout failed.",
          color: Colors.red,
        ).show(context);

        if (response['message'] == "Invalid or expired token.") {
          SessionHelper.showSessionExpiredDialog(context);
        }

        return false;
      }
    } catch (e) {
      CustomSnackbar(
        text: "Something went wrong: $e",
        color: Colors.red,
      ).show(context);
      return false;
    }
  }

// Function to clear user data from shared preferences
  Future<void> _clearUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clears all data (can be customized)
  }

  // Forgot Password
  Future<bool> forgotPassword(String email, BuildContext context) async {
    final response = await AuthService.forgotPassword(email);

    if (response['success']) {
      CustomSnackbar(
        text: response['message'] ?? "OTP sent successfully.",
        color: Colors.green,
      ).show(context);

      return true;
    } else {
      CustomSnackbar(
        text: response['message'] ?? "Failed to send OTP.",
        color: Colors.red,
      ).show(context);

      return false;
    }
  }

  Future<bool> resetPassword(
      String email, String password, BuildContext context) async {
    final response = await AuthService.resetPassword(email, password);

    if (response['success']) {
      CustomSnackbar(
        text: response['message'] ?? "Password Updated successfully.",
        color: Colors.green,
      ).show(context);

      return true;
    } else {
      CustomSnackbar(
        text: response['message'] ?? "Failed to update password.",
        color: Colors.red,
      ).show(context);

      return false;
    }
  }

  Future<bool> changePassword(String email, String oldPassword,
      String newPassword, BuildContext context) async {
    final response =
        await AuthService.changePassword(email, oldPassword, newPassword);

    if (response['success']) {
      CustomSnackbar(
        text: response['message'] ?? "Password Updated successfully.",
        color: Colors.green,
      ).show(context);

      return true;
    } else {
      CustomSnackbar(
        text: response['message'] ?? "Failed to update password.",
        color: Colors.red,
      ).show(context);

      if (response['message'] == "Invalid or expired token.") {
        SessionHelper.showSessionExpiredDialog(context);
      }

      return false;
    }
  }

  // Delete Account
  Future<bool> deleteAccount(String email, BuildContext context) async {
    final response = await AuthService.deleteAccount(email);

    if (response['success']) {
      CustomSnackbar(
        text: response['message'] ?? "Account Deleted successfully.",
        color: Colors.red,
      ).show(context);

      return true;
    } else {
      CustomSnackbar(
        text: response['message'] ?? "Failed to Delete Account.",
        color: Colors.red,
      ).show(context);

      if (response['message'] == "Invalid or expired token.") {
        SessionHelper.showSessionExpiredDialog(context);
      }

      return false;
    }
  }
}
