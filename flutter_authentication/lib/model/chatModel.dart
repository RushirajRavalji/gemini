import 'dart:convert';

class Chat {
  final String id;
  final String email;
  final List<ChatMessage> chats;
  final DateTime createdAt;
  final int version;

  Chat({
    required this.id,
    required this.email,
    required this.chats,
    required this.createdAt,
    required this.version,
  });

  // Factory method to create a Chat instance from JSON
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['_id'],
      email: json['email'],
      chats: (json['chats'] as List)
          .map((chat) => ChatMessage.fromJson(chat))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      version: json['__v'],
    );
  }

  // Convert the Chat instance to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'chats': chats.map((chat) => chat.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      '__v': version,
    };
  }
}

class ChatMessage {
  final String id;
  final String role;
  final String message;

  ChatMessage({
    required this.id,
    required this.role,
    required this.message,
  });

  // Factory method to create a ChatMessage instance from JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id'],
      role: json['role'],
      message: json['message'],
    );
  }

  // Convert the ChatMessage instance to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'role': role,
      'message': message,
    };
  }
}

// Function to parse JSON string to Chat object
Chat chatFromJson(String str) => Chat.fromJson(json.decode(str));

// Function to convert Chat object to JSON string
String chatToJson(Chat data) => json.encode(data.toJson());
