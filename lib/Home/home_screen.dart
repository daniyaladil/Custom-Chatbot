import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Constants/colors.dart';
import '../Constants/fonts.dart';
import 'message_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  late DialogFlowtter funnyBot; // default agent
  late DialogFlowtter rudeBot;  // rude agent

  List<Map<String, dynamic>> messages = [];

  bool isTyping = false;

  bool isFunny = true;
  bool isRude = false;



  @override
  void initState() {
    // Load both agents from different credential files
    DialogFlowtter.fromFile(path: "assets/dialog_flow_funny.json")
        .then((instance) => funnyBot = instance);

    DialogFlowtter.fromFile(path: "assets/dialog_flow_rude.json")
        .then((instance) => rudeBot = instance);
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
                      Text("   |   ",style: TextStyle(fontSize: 14),),
                      Text(
                        isFunny?"Funny" :"Rude",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: AppColors.accentColor,
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setModalState) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Select Personality",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),

                              // Funny option
                              ListTile(
                                leading: Icon(Icons.emoji_emotions),
                                title: Text("Funny"),
                                trailing: isFunny
                                    ? Icon(Icons.check_box,
                                        color: Colors.white, size: 28)
                                    : null, // null = no trailing icon
                                onTap: () {
                                  setModalState(() {
                                    isFunny = true;
                                    isRude = false;
                                  });
                                  setState(() {
                                    // also update parent
                                    isFunny = true;
                                    isRude = false;
                                  });
                                },
                              ),

                              // Rude option
                              ListTile(
                                leading: Icon(Icons.sentiment_dissatisfied),
                                title: Text("Rude"),
                                trailing: isRude
                                    ? Icon(Icons.check_box,
                                        color: Colors.white, size: 28)
                                    : null,
                                onTap: () {
                                  setModalState(() {
                                    isFunny = false;
                                    isRude = true;
                                  });
                                  setState(() {
                                    // also update parent
                                    isFunny = false;
                                    isRude = true;
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
              child: Icon(Icons.settings, color: Colors.white),
            ),
            SizedBox(
              width: 10,
            )
          ],
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.accentColor,
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
          child: Column(
            children: [
              Expanded(
                  child: Messages(
                messages: messages,
                isTyping: isTyping,
              )),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xffE8EBF0),
                  borderRadius:
                      BorderRadius.circular(10), // rounded bubble look
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
                        if (_controller.text.trim().isNotEmpty) {
                          sendMessage(_controller.text.trim());
                          _controller.clear();
                        }
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
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
        ));
  }

  sendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() {
      _addMessage(Message(text: DialogText(text: [text])), true);
      isTyping = true;
    });

    // Choose which bot to use
    DialogFlowtter activeBot = isFunny ? funnyBot : rudeBot;

    DetectIntentResponse response = await activeBot.detectIntent(
      queryInput: QueryInput(text: TextInput(text: text)),
    );

    if (response.message == null) {
      setState(() => isTyping = false);
      return;
    }

    setState(() {
      _addMessage(response.message!);
      isTyping = false;
    });
  }

  _addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }

}
