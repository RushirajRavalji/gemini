import 'dart:typed_data';
import 'package:flutter_authentication/model/chatModel.dart';
import 'package:share_plus/share_plus.dart';

class ShareChat {
  // Function to generate and share chat data as an HTML file
  static Future<void> shareChats(List<ChatMessage> chats) async {
    try {
      // Generate HTML content for the chats
      final chatHtml = _generateChatHtml(chats);

      // Convert the HTML string to bytes
      final bytes = Uint8List.fromList(chatHtml.codeUnits);

      // Share the HTML file
      await Share.shareXFiles(
        [
          XFile.fromData(
            bytes,
            name: 'chats.html', // Name of the file
            mimeType: 'text/html', // MIME type for HTML
          ),
        ],
        text: 'Here are the chats:',
      );
    } catch (e) {
      print('Error while sharing chats: $e');
    }
  }

  // Function to generate HTML content with proper formatting
  static String _generateChatHtml(List<ChatMessage> chats) {
    final buffer = StringBuffer();

    buffer.write('''
<!DOCTYPE html>
<html>
<head>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 16px;
      background-color: #f5f5f5;
    }
    .chat-container {
      display: flex;
      flex-direction: column;
      gap: 16px;
    }
    .chat-message {
      padding: 12px;
      border-radius: 12px;
      max-width: 70%;
      font-size: 16px;
      line-height: 1.6;
      white-space: pre-wrap; /* Preserve spaces and line breaks */
    }
    .question {
      align-self: flex-end;
      background-color: black;
      color: white;
      width: 70%;
    }
    .answer {
      align-self: flex-start;
      background-color: #d3d3d3;
      color: black;
      width: 70%;
    }
  </style>
</head>
<body>
  <div class="chat-container">
''');

    // Add chats to the HTML content
    for (var chat in chats) {
      buffer.write(
          '''<div class="chat-message ${chat.role == 'user' ? 'question' : 'answer'}">${chat.message}</div>''');
    }

    buffer.write('''
  </div>
</body>
</html>
''');

    return buffer.toString();
  }
}
