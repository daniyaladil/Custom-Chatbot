

import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Constants/colors.dart';
import '../Constants/fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  late DialogFlowtter dialogFlowtter;

  List<Map<String,dynamic>> messages=[];

  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance)=>dialogFlowtter=instance);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        title: Row(
          spacing: 10,
          children: [
            Image.asset(
              "assets/logo.png",
              width: 35,
              height: 35,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Chat Bot",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeights.boldFontW),
                ),
                Row(
                  spacing: 2,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 10,
                      color: Colors.green,
                    ),
                    Text(
                      "Online",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
        actions: [
          Icon(
            Icons.settings,
            color: Colors.white,
          ),
          SizedBox(
            width: 10,
          )
        ],
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.accentColor,
      ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xffE8EBF0),
                  borderRadius: BorderRadius.circular(10), // rounded bubble look
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
                        style: TextStyle(
                          color: AppColors.textColor,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Enter your message...",
                          border: InputBorder.none, // removes the line
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // handle send
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple, // send button color
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )

    );
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      print('Message is empty');
    } else {
      setState(() {
        _addMessage(Message(text: DialogText(text: [text])), true);
      });

      DetectIntentResponse response = await dialogFlowtter.detectIntent(
          queryInput: QueryInput(text: TextInput(text: text)));
      if (response.message == null) return;
      setState(() {
        _addMessage(response.message!);
      });
    }
  }

  _addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }
}
