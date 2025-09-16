import 'package:custom_chatbot/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Messages extends StatefulWidget {
  final List messages;
  final bool isTyping;
  const Messages({super.key, required this.messages, required this.isTyping});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final ScrollController _scrollController = ScrollController();

  final Map<int, bool> likes = {};
  final Map<int, bool> dislikes = {};

  @override
  void didUpdateWidget(covariant Messages oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return ListView.separated(
      controller: _scrollController,
      itemBuilder: (context, index) {
        if (index == widget.messages.length) {
          return widget.isTyping
              ? const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Chatbot is typing...",
              style: TextStyle(
                  color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          )
              : const SizedBox();
        }

        final isLike = likes[index] ?? false;
        final isDislike = dislikes[index] ?? false;

        return Container(
          margin: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: widget.messages[index]['isUserMessage']
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomRight: Radius.circular(
                        widget.messages[index]['isUserMessage'] ? 0 : 20),
                    topLeft: Radius.circular(
                        widget.messages[index]['isUserMessage'] ? 20 : 0),
                  ),
                  color: widget.messages[index]['isUserMessage']
                      ? const Color(0xffDEE2E6)
                      : AppColors.accentColor,
                ),
                constraints: BoxConstraints(maxWidth: w * 2 / 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //  Message text
                    Text(
                      widget.messages[index]['message'].text.text[0],
                      style: TextStyle(
                        color: widget.messages[index]['isUserMessage']
                            ? AppColors.textColor
                            : Colors.white,
                      ),
                    ),
                    if (!widget.messages[index]['isUserMessage'])SizedBox(height: 10,),

                    // Inline actions
                    if (!widget.messages[index]['isUserMessage'])
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Copy
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                    text: widget.messages[index]['message']
                                        .text.text[0]));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    duration: Duration(seconds: 1),
                                      content:
                                      Text("Copied to clipboard")),
                                );
                              },
                              child: const Icon(
                                Icons.copy,
                                size: 16,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(width: 15),

                            // Upvote
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isDislike) dislikes[index] = false;
                                  likes[index] = !isLike;
                                });
                              },
                              child: Icon(
                                isLike
                                    ? Icons.arrow_upward
                                    : Icons.arrow_upward_outlined,
                                size: 18,
                                color: isLike ? Colors.green : Colors.white70,
                              ),
                            ),
                            const SizedBox(width: 10),

                            // Downvote
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isLike) likes[index] = false;
                                  dislikes[index] = !isDislike;
                                });
                              },
                              child: Icon(
                                isDislike
                                    ? Icons.arrow_downward
                                    : Icons.arrow_downward_outlined,
                                size: 18,
                                color: isDislike ? Colors.red : Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (_, i) =>
      const Padding(padding: EdgeInsets.only(top: 10)),
      itemCount: widget.messages.length + 1,
    );
  }
}
