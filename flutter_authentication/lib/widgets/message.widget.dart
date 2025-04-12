import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_authentication/utility/customSnackBar.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget(
      {super.key,
      required this.text,
      required this.isFromUser,
      required this.isDark});
  final String text;
  final bool isFromUser;
  final bool isDark;

  // Extract code blocks from the markdown text
  List<String> _extractCodeBlocks(String markdownText) {
    final codeBlockPattern = RegExp(r'```(.*?)```', dotAll: true);
    return codeBlockPattern
        .allMatches(markdownText)
        .map((match) => match.group(1) ?? '')
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final codeBlocks = _extractCodeBlocks(text);

    return Row(
      mainAxisAlignment:
          isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
            child: Container(
          padding: const EdgeInsets.all(10),
          margin: EdgeInsets.only(
            top: 5,
            bottom: 5,
            left: isFromUser ? MediaQuery.sizeOf(context).width * 0.15 : 0,
          ),
          constraints:
              BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.85),
          decoration: BoxDecoration(
            color: isDark
                ? isFromUser
                    ? Colors.grey[800]
                    : Colors.black
                : isFromUser
                    ? Colors.grey[300]
                    : Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (codeBlocks.isNotEmpty)
                IconButton(
                  icon: Icon(
                    Icons.copy,
                    size: MediaQuery.sizeOf(context).width * 0.05,
                  ),
                  color: isDark ? Colors.white : Colors.black,
                  onPressed: () {
                    final codeToCopy = codeBlocks.join('\n\n');
                    Clipboard.setData(ClipboardData(text: codeToCopy));
                    CustomSnackbar(
                            text: 'Code copied to clipboard!',
                            color: Colors.black)
                        .show(context);
                  },
                ),
              MarkdownBody(
                data: text,
                styleSheet: MarkdownStyleSheet(
                  code: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontFamily: 'Courier',
                    backgroundColor:
                        isDark ? Colors.grey[700] : Colors.grey[200],
                  ),
                  codeblockDecoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ))
      ],
    );
  }
}
