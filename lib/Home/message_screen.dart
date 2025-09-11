import 'package:custom_chatbot/Constants/colors.dart';
import 'package:custom_chatbot/Home/typing_indicator.dart';
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
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return ListView.separated(
      itemBuilder: (context, index) {
        if (index == widget.messages.length) {
          // typing indicator at end
          return widget.isTyping
              ? const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Chatbot is typing...",
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          )
              : const SizedBox();
        }

        // normal messages
        return Container(
          margin:  EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: widget.messages[index]['isUserMessage']
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Container(
                padding:  EdgeInsets.symmetric(vertical: 14, horizontal: 14),
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.messages[index]['message'].text.text[0],
                      style: TextStyle(
                        color: widget.messages[index]['isUserMessage']
                            ? AppColors.textColor
                            : Colors.white,
                      ),
                    ),
                    widget.messages[index]['isUserMessage']
                        ?SizedBox():Container(
                      margin: EdgeInsets.only(left: 5,top: 15),
                      height: 25,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xff7B2CBF)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.copy,size: 15,),
                          SizedBox(width: 25,),
                          Icon(Icons.thumb_up_alt_outlined,size: 15),
                          SizedBox(width: 5,),
                          Icon(Icons.thumb_down_alt_outlined,size: 15,),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (_, i) => const Padding(padding: EdgeInsets.only(top: 10)),
      itemCount: widget.messages.length + 1, // +1 for typing indicator
    );

  }

  void _copyToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copied to clipboard!")),
    );
  }

}
