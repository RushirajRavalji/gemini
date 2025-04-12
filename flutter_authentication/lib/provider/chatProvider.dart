import 'package:flutter/material.dart';
import 'package:flutter_authentication/model/chatModel.dart';
import 'package:flutter_authentication/services/chatServices.dart';
import 'package:flutter_authentication/utility/customSnackBar.dart';
import 'package:flutter_authentication/utility/tokenExpireDailogBox.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ChatProvider extends GetxController {
  List<Chat> _chats = []; // Private list to store chats

  // Setter to update the chat list
  void setChats(List<Chat> chatList) {
    _chats = chatList;
  }

  // Getter to retrieve the chat list
  List<Chat> get chats => _chats;

  Future<String?> addChat(
      String email, String message, String role, BuildContext context) async {
    final response = await ChatService.insertChat(email, message, role);
    String chatId;
    if (response['success']) {
      chatId = response['chatId'];
      return chatId;
    } else {
      CustomSnackbar(
        text: response['message'] ?? "Can't Send Message.",
        color: Colors.red,
      ).show(context);

      if (response['message'] == "Invalid or expired token.") {
        SessionHelper.showSessionExpiredDialog(context);
      }

      return null;
    }
  }

  Future<bool> updateChat(
      String message, String role, String chatId, BuildContext context) async {
    final response = await ChatService.updateChat(message, role, chatId);
    if (response['success']) {
      return true;
    } else {
      CustomSnackbar(
        text: response['message'] ?? "Can't Send Message.",
        color: Colors.red,
      ).show(context);

      if (response['message'] == "Invalid or expired token.") {
        SessionHelper.showSessionExpiredDialog(context);
      }

      return false;
    }
  }

  Future<List<Chat>?> getChatsByEmail(
      String email, BuildContext context) async {
    final response = await ChatService.getChatByEmail(email);

    if (response['success']) {
      // Assuming response['data'] contains a list of chat objects
      List<Chat> chats = List<Chat>.from(
        response['data'].map((chatData) => Chat.fromJson(chatData)),
      );
      return chats; // Return the list of chats
    } else {
      CustomSnackbar(
        text: response['message'] ?? "Can't get chats.",
        color: Colors.red,
      ).show(context);

      if (response['message'] == "Invalid or expired token.") {
        SessionHelper.showSessionExpiredDialog(context);
      }
      return null;
    }
  }

  Future<bool> deleteChat(String chatId, BuildContext context) async {
    final response = await ChatService.deleteChat(chatId);
    if (response['success']) {
      return true;
    } else {
      CustomSnackbar(
        text: response['message'] ?? "Can't Delete Chat.",
        color: Colors.red,
      ).show(context);

      if (response['message'] == "Invalid or expired token.") {
        SessionHelper.showSessionExpiredDialog(context);
      }

      return false;
    }
  }
}
