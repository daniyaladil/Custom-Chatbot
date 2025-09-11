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
  late DialogFlowtter dialogFlowtter;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WaitFunction();
    DialogFlowtter.fromFile().then((instance) async {
      dialogFlowtter = instance;
      // warmup
      await dialogFlowtter.detectIntent(
        queryInput: QueryInput(text: TextInput(text: "hello")),
      );
    });
  }


  WaitFunction(){
    Timer(Duration(seconds: 3),(){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(25),
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(90),
                color: Color(0xff5A189A)
              ),
                child: Image.asset(
              "assets/logo.png",
            )),
          )
        ],
      ),
    );
  }
}
