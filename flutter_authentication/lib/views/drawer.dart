import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_authentication/auth/loginScreen.dart';
import 'package:flutter_authentication/auth/setNewPasswordScreen.dart';
import 'package:flutter_authentication/model/chatModel.dart';
import 'package:flutter_authentication/provider/authProvider.dart';
import 'package:flutter_authentication/provider/chatProvider.dart';
import 'package:flutter_authentication/services/shareChatService.dart';
import 'package:flutter_authentication/theme/changeTheme.dart';
import 'package:flutter_authentication/theme/easyLoading.dart';
import 'package:flutter_authentication/utility/customDailogBox.dart';
import 'package:flutter_authentication/utility/customSnackBar.dart';
import 'package:flutter_authentication/widgets/drawer.widget.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  final email;
  final password;
  final Function(Chat) onChatSelected;
  final Function() clearHistory;

  const CustomDrawer({
    super.key,
    required this.email,
    required this.password,
    required this.onChatSelected,
    required this.clearHistory,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  List<Chat> chats = [];
  final chatProvider = Get.find<ChatProvider>();

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  void _loadChats() async {
    if (chatProvider.chats.isEmpty) {
      List<Chat>? chatList =
          await ChatProvider().getChatsByEmail(widget.email, context);
      if (chatList != null) {
        chatProvider.setChats(chatList.reversed.toList());
        setState(() {
          chats = chatList.reversed.toList();
        });
        print("FromAPI");
      }
    } else {
      setState(() {
        chats = chatProvider.chats;
      });

      print("From Provider");
    }
  }

  String _getLimitedWords(String message, int wordLimit) {
    List<String> words = message.split(' '); // Split the message by spaces
    if (words.length > wordLimit) {
      return words.sublist(0, wordLimit).join(' ') + '...';
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = Get.find<Authprovider>();
    return Drawer(
      backgroundColor:
          ThemeClass.isDarkMode(context) ? Colors.grey[800] : Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            Container(
              color: Colors.transparent,
              padding:
                  EdgeInsets.symmetric(horizontal: width * 0.03, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.email.replaceAll('@gmail.com', ''),
                        style: const TextStyle(
                          fontSize: 15,   
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      ThemeClass.toggleTheme(context);
                    },
                    icon: Icon(
                      !isDark ? Icons.dark_mode : Icons.light_mode,
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                chatProvider.chats.clear();
                widget.clearHistory();
                Navigator.of(context).pop();
              },
              child: Container(
                height: 50,
                margin: EdgeInsets.symmetric(
                    horizontal: width * 0.03, vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ThemeClass.isDarkMode(context)
                      ? Colors.black26
                      : Colors.white,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "New Chat",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.chat_bubble_outline,
                    ),
                  ],
                ),
              ),
            ),
            chats.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            widget.onChatSelected(chats[index]);
                            Navigator.of(context).pop();
                          },
                          title: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, top: 0, bottom: 0, right: 0),
                            child: Text(
                              chats[index].chats.length > 1
                                  ? chats[index].chats[1].message
                                  : chats[index].chats[0].message,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          contentPadding: EdgeInsets.all(0),
                          trailing: PopupMenuButton<String>(
                            onSelected: (String value) async {
                              if (value == 'share') {
                                try {
                                  EasyLoading.show();
                                  await ShareChat.shareChats(
                                      chats[index].chats);
                                } catch (e) {
                                  CustomSnackbar(
                                          text:
                                              "Can't share this conversation.",
                                          color: Colors.red)
                                      .show(context);
                                } finally {
                                  EasyLoading.dismiss();
                                }
                                print("Share action selected");
                              } else if (value == 'delete') {
                                print("Delete action selected");
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return CustomDialogBox(
                                      description:
                                          "Are you sure you want to delete chat?",
                                      onConfirm: () async {
                                        EasyLoading.show();
                                        bool isDeleted = await ChatProvider()
                                            .deleteChat(
                                                chats[index].id.toString(),
                                                context);
                                        print(chats[index].id.toString());
                                        if (isDeleted) {
                                          chats.removeAt(index);
                                          Navigator.of(context).pop();
                                          _loadChats();
                                        }
                                        EasyLoading.dismiss();
                                      },
                                      onCancel: () {
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                );
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'share',
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.share, size: 20),
                                    SizedBox(width: 10),
                                    Text('Share'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.trash, size: 20),
                                    SizedBox(width: 10),
                                    Text('Delete'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }, 
                    ),
                  )
                : Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),
            CustomMenuItem(
              icon: Icons.lock_outline,
              title: "Change Password",
              onTap: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                final String? email = prefs.getString('email');
                final String? password = prefs.getString('password');

                if (email != null &&
                    password != null &&
                    email.isNotEmpty &&
                    password.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SetNewPassword(),
                    ),
                  );
                } else {
                  Navigator.of(context).pop();
                  CustomSnackbar(
                    text:
                        "You can only change the password after saving login details.",
                    color: Colors.amber, // Warning color
                  ).show(context);
                }
              },
            ),
            CustomMenuItem(
              icon: Icons.logout,
              title: "Logout",
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return CustomDialogBox(
                      description: "Are you sure you want to logout?",
                      onConfirm: () async {
                        try {
                          LoadingIndicator.show();
                          bool success = await authProvider.logoutUser(context);

                          if (success) {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.clear();
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          }
                        } catch (e) {
                          CustomSnackbar(
                            text: "Something went wrong: $e",
                            color: Colors.red,
                          ).show(context);
                        } finally {
                          LoadingIndicator.dismiss();
                        }
                      },
                      onCancel: () {
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              },
            ),
            CustomMenuItem(
              icon: Icons.delete_outlined,
              title: "Delete Account",
              onTap: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                final String? email = prefs.getString('email');
                final String? password = prefs.getString('password');

                if (email != null &&
                    password != null &&
                    email.isNotEmpty &&
                    password.isNotEmpty) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return CustomDialogBox(
                        description: "Are you sure you want to delete account?",
                        onConfirm: () async {
                          try {
                            LoadingIndicator.show();

                            final isDeleted = await Authprovider()
                                .deleteAccount(email, context);

                            if (isDeleted) {
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.clear();
                              Navigator.of(context).pop();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
                            }
                          } catch (e) {
                            CustomSnackbar(
                              text: "Something went wrong.",
                              color: Colors.red,
                            ).show(context);
                          } finally {
                            Navigator.of(context).pop();

                            LoadingIndicator.dismiss();
                          }
                        },
                        onCancel: () {
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                } else {
                  Navigator.of(context).pop();
                  CustomSnackbar(
                    text:
                        "You can only delete account after saving login details.",
                    color: Colors.amber, // Warning color
                  ).show(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
