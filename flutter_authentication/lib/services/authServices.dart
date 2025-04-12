import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl =
      "https://authentication-node-a97g.onrender.com/auth";

  // Method to send OTP
  static Future<Map<String, dynamic>> sendOtp(String email) async {
    const String url = "$baseUrl/send-otp";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {"success": true, "message": responseData['message']};
      } else {
        return {"success": false, "message": responseData['message']};
      }
    } catch (error) {
      return {"success": false, "message": "An error occurred: $error"};
    }
  }

  static Future<Map<String, dynamic>> verifyOtp(
      String email, String otp) async {
    const String url = "$baseUrl/verify-otp";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "otp": otp}),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {"success": true, "message": responseData['message']};
      } else {
        return {"success": false, "message": responseData['message']};
      }
    } catch (error) {
      return {"success": false, "message": "An error occurred: $error"};
    }
  }

  static Future<Map<String, dynamic>> signup(
      String email, String password) async {
    const String url = "$baseUrl/signup";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
            String token = responseData['token'];
        final SharedPreferences prefsToken =
            await SharedPreferences.getInstance();
        await prefsToken.setString('token', token);
        return {
          "success": true,
          "message": responseData['message'],
          "data": responseData['data'],
          "token": responseData['token'],
        };
      } else {
        return {"success": false, "message": responseData['message']};
      }
    } catch (error) {
      return {"success": false, "message": "An error occurred: $error"};
    }
  }

  // Login User
  static Future<Map<String, dynamic>> loginUser(
      String email, String password) async {
    const String url = "$baseUrl/login";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        String token = responseData['token'];
        final SharedPreferences prefsToken =
            await SharedPreferences.getInstance();
        await prefsToken.setString('token', token);

        return {
          "success": true,
          "message": responseData['message'],
          "token": responseData['token'],
        };
      } else {
        return {
          "success": false,
          "message": responseData['message'] ?? 'Login failed.',
        };
      }
    } catch (error) {
      return {
        "success": false,
        "message": "An error occurred: $error",
      };
    }
  }

  // Logout User
  static Future<Map<String, dynamic>> logoutUser() async {
    const String url = "$baseUrl/logout";
    final SharedPreferences prefsToken = await SharedPreferences.getInstance();
    String? token = prefsToken.getString('token') ?? '';
    print("Token :- " + token);
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        prefsToken.clear();
        return {
          "success": true,
          "message": responseData['message'] ?? "Logged out successfully.",
        };
      } else {
        return {
          "success": false,
          "message": responseData['message'] ?? 'Logout failed.',
        };
      }
    } catch (error) {
      print("Error during logout: $error");
      return {
        "success": false,
        "message": "An error occurred: $error",
      };
    }
  }

  // Method to send OTP After Forgot password
  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    const String url = "$baseUrl/forgot-password";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {"success": true, "message": responseData['message']};
      } else {
        return {"success": false, "message": responseData['message']};
      }
    } catch (error) {
      return {"success": false, "message": "An error occurred: $error"};
    }
  }

  // Method to send OTP After Reset password
  static Future<Map<String, dynamic>> resetPassword(
      String email, String password) async {
    const String url = "$baseUrl/reset-password";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "newPassword": password}),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(response.statusCode);
      print(responseData['token']);
      if (response.statusCode == 200) {
        String token = responseData['token'];
        final SharedPreferences prefsToken =
            await SharedPreferences.getInstance();
        await prefsToken.setString('token', token);
        return {
          "success": true,
          "message": responseData['message'],
          "token": responseData['token'],
        };
      } else {
        return {"success": false, "message": responseData['message']};
      }
    } catch (error) {
      return {"success": false, "message": "An error occurred: $error"};
    }
  }

  // Method to send OTP After Reset password
  static Future<Map<String, dynamic>> changePassword(
      String email, String oldPassword, String newPassword) async {
    const String url = "$baseUrl/change-password";
    final SharedPreferences prefsToken = await SharedPreferences.getInstance();
    String? token = prefsToken.getString('token') ?? '';
    print("Token :- " + token);
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "email": email,
          "oldPassword": oldPassword,
          "newPassword": newPassword
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData['message']);
      if (response.statusCode == 200) {
        return {
          "success": true,
          "message": responseData['message'],
          "data": responseData['data']
        };
      } else {
        return {"success": false, "message": responseData['message']};
      }
    } catch (error) {
      return {"success": false, "message": "An error occurred: $error"};
    }
  }

  static Future<Map<String, dynamic>> deleteAccount(String email) async {
    const String url = "$baseUrl/delete-account";
    final SharedPreferences prefsToken = await SharedPreferences.getInstance();
    String? token = prefsToken.getString('token') ?? '';
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"email": email}),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData['message']);
      if (response.statusCode == 200) {
        return {"success": true, "message": responseData['message']};
      } else {
        return {"success": false, "message": responseData['message']};
      }
    } catch (error) {
      return {"success": false, "message": "An error occurred: $error"};
    }
  }
}
