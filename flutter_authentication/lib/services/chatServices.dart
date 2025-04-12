import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  static const String baseUrl =
      "https://authentication-node-a97g.onrender.com/chats";

  static Future<Map<String, dynamic>> insertChat(
      String email, String message, String role) async {
    const String url = "$baseUrl/add-chat";
    final SharedPreferences prefsToken = await SharedPreferences.getInstance();
    String? token = prefsToken.getString('token') ?? '';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "email": email,
          "message": message,
          "role": role,
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // Parse the chat ID from the response and return it
        String chatId = responseData['data']['_id'];
        return {
          "success": true,
          "message": responseData['message'],
          "chatId": chatId
        };
      } else {
        return {"success": false, "message": responseData['message']};
      }
    } catch (error) {
      return {"success": false, "message": "An error occurred: $error"};
    }
  }

  // Method to update chat message
  static Future<Map<String, dynamic>> updateChat(
      String message, String role, String chatId) async {
    final String url = "$baseUrl/update-chat/$chatId";
    final SharedPreferences prefsToken = await SharedPreferences.getInstance();
    String? token = prefsToken.getString('token') ?? '';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "role": role,
          "message": message,
        }),
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

  // Method to fetch chat by email
  static Future<Map<String, dynamic>> getChatByEmail(String email) async {
    final String url = "$baseUrl/fetch-chat/$email";
    final SharedPreferences prefsToken = await SharedPreferences.getInstance();
    String? token = prefsToken.getString('token') ?? '';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Return the chat data
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

  // Method to delete chat by chatId
  static Future<Map<String, dynamic>> deleteChat(String chatId) async {
    final String url = "$baseUrl/delete-chat/$chatId";
    final SharedPreferences prefsToken = await SharedPreferences.getInstance();
    String? token = prefsToken.getString('token') ?? '';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

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
}
