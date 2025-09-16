import 'dart:async';
import 'package:custom_chatbot/Home/home_screen.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late DialogFlowtter funnyBot;
  late DialogFlowtter rudeBot;

  @override
  void initState() {
    super.initState();
    _initializeBots();
  }

  Future<void> _initializeBots() async {
    final futures = await Future.wait([
      DialogFlowtter.fromFile(path: "assets/dialog_flow_funny.json"),
      DialogFlowtter.fromFile(path: "assets/dialog_flow_rude.json"),
    ]);

    funnyBot = futures[0];
    rudeBot = futures[1];

    // Warmup both bots
    await Future.wait([
      funnyBot.detectIntent(
        queryInput: QueryInput(text: TextInput(text: "hello")),
      ),
      rudeBot.detectIntent(
        queryInput: QueryInput(text: TextInput(text: "hi")),
      ),
    ]);

    // Navigate immediately after warmup
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          funnyBot: funnyBot,
          rudeBot: rudeBot,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(25),
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(90),
            color: const Color(0xff5A189A),
          ),
          child: Image.asset("assets/logo.png"),
        ),
      ),
    );
  }
}
