import 'package:flutter/material.dart';
import 'package:flutter_authentication/model/chatModel.dart';
import 'package:flutter_authentication/provider/authProvider.dart';
import 'package:flutter_authentication/provider/chatProvider.dart';
import 'package:flutter_authentication/theme/changeTheme.dart';
import 'package:flutter_authentication/utility/customSnackBar.dart';
import 'package:flutter_authentication/views/drawer.dart';
import 'package:flutter_authentication/widgets/message.widget.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final GenerativeModel _model;
  late ChatSession _chatSession;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  String? qText;

  final authProvider = Get.find<Authprovider>();
  final chatProvider = Get.find<ChatProvider>();
  @override
  void initState() {
    _model = GenerativeModel(
        model: 'gemini-1.5-pro',
        apiKey: "AIzaSyAakia-0m0mKxbDwodSwC9aVGO1DcZzt5g");
    _chatSession = _model.startChat();
    super.initState();
    _getCredentials();
  }

  String? email;
  String? password;

  Future<void> _getCredentials() async {
    email = authProvider.getEmail;
    password = authProvider.getPassword;
  }

  String? chatId;
  Chat? chats;
  onSelectedTab(Chat chat) {
    chatId = chat.id;
    _chatSession = _model.startChat(
        history: chat.chats.map((e) => Content.text(e.message)).toList());
  }

  clearHistory() {
    chatId = null;
    _chatSession = _model.startChat();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ThemeClass.isDarkMode(context);
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Gemini Plus",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0)),
          backgroundColor: Colors.transparent,
        ),
        drawer: CustomDrawer(
          email: email,
          password: password,
          onChatSelected: (chat) {
            onSelectedTab(chat);
          },
          clearHistory: () {
            clearHistory();
          },
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _chatSession.history.length + (isLoading ? 1 : 0),
                  reverse: true,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  itemBuilder: (context, index) {
                    if (isLoading && index == 0) {
                      return MessageWidget(
                        text: qText.toString(),
                        isFromUser: true,
                        isDark: isDark,
                      );
                    }

                    final Content content = _chatSession.history
                        .toList()
                        .reversed
                        .toList()[index - (isLoading ? 1 : 0)];
                    final text = content.parts
                        .whereType<TextPart>()
                        .map((e) => e.text)
                        .join('');
                    return MessageWidget(
                      text: text,
                      isFromUser: isLoading
                          ? index % 2 != 0
                              ? content.role == 'assistant'
                              : content.role == 'user'
                          : index % 2 == 0
                              ? content.role == 'assistant'
                              : content.role == 'user',
                      isDark: isDark,
                    );
                  },
                ),
              ),
              if (isLoading)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: width * 0.05, vertical: 8),
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.02, vertical: width * 0.015),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          color: isDark ? Colors.white : Colors.black,
                          size: width * 0.03,
                        ),
                        SizedBox(width: width * 0.015),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[600]!,
                          highlightColor: Colors.grey[50]!,
                          child: Row(
                            children: List.generate(
                              3,
                              (index) => Container(
                                margin: EdgeInsets.only(right: width * 0.01),
                                width: width * 0.01,
                                height: width * 0.01,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        cursorColor: isDark ? Colors.white : Colors.black,
                        controller: _textController,
                        focusNode: _focusNode,
                        decoration: textFiledDecoration(),
                      ),
                    ),
                    SizedBox(width: 4),
                    IconButton(
                      onPressed: () {
                        if (_textController.text.toString().isNotEmpty) {
                          _sendChatMessage(_textController.text.toString());
                        } else {
                          CustomSnackbar(
                                  text: 'Please! Type any question or query!',
                                  color: Colors.red)
                              .show(context);
                        }
                      },
                      icon: Icon(
                        Icons.send,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration textFiledDecoration() {
    return InputDecoration(
        contentPadding: const EdgeInsets.all(15),
        hintText: "Ask anything",
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Colors.grey,
            )));
  }

  Future<void> _sendChatMessage(String message) async {
    setState(() {
      isLoading = true;
      qText = _textController.text.toString();
      _textController.clear();
    });
    if (_chatSession.history.isEmpty) {
      final id = await ChatProvider().addChat(email!, message, 'user', context);
      if (id == null) {
        CustomSnackbar(text: "Can't Send Message.", color: Colors.red)
            .show(context);
        return;
      }
      chatProvider.chats.clear();

      chatId = id;
    } else {
      if (chatId != null) {
        bool isUpdated =
            await ChatProvider().updateChat(message, 'user', chatId!, context);
        if (!isUpdated) {
          _showError("Something want wrong. Please try again.");
        } else {
          chatProvider.chats.clear();
        }
      } else {
        _showError("Something want wrong. Please try again.");
      }
    }

    try {
      final response = await _chatSession.sendMessage(
        Content.text(message),
      );

      final text = response.text;

      if (text == null) {
        _showError('No Response From API');
        return;
      } else {
        setState(() {
          isLoading = false;
        });
      }

      if (chatId != null) {
        bool isUpdated = await ChatProvider()
            .updateChat(text.toString(), 'assistant', chatId!, context);
        if (!isUpdated) {
          _showError("Something want wrong. Please try again.");
        }
      } else {
        _showError("Something want wrong. Please try again.");
      }
    } catch (e) {
      _showError(e.toString());
      setState(() {
        isLoading = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
      _focusNode.requestFocus();
    }
  }

  // void _scrollDown() {
  //   WidgetsBinding.instance.addPostFrameCallback(
  //     (_) => _scrollController.animateTo(
  //       _scrollController.position.minScrollExtent,
  //       duration: const Duration(milliseconds: 1000),
  //       curve: Curves.easeInOut,
  //     ),
  //   );
  // }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('something went wrong'),
          content: SingleChildScrollView(
            child: SelectableText(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
