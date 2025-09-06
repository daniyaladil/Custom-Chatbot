import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Map<String,dynamic>> messages=[];
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller=TextEditingController();

  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance)=>dialogFlowtter=instance);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bosormon Bot"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //Messages from MessageScreen\


          //TextFormField
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14,vertical: 5),
            color: Colors.deepPurple,
            child: Row(
              children: [
                Expanded(child: TextField(
                  controller: _controller,
                  style: const TextStyle(
                    color: Colors.white
                  ),
                )),
                TextButton(onPressed: (){
                  SendMessage(_controller.text);
                  _controller.clear();
                }, child: Icon(Icons.send,color: Colors.white,))
              ],
            ),
          )
        ],
      ),
    );
  }

  SendMessage(String text) async{
    if(text.isEmpty){
      print("Empty");
    }else{
      setState(() {
        addMessage(Message(text: DialogText(text: [text])),true);
      });
    }
    DetectIntentResponse response=await dialogFlowtter.detectIntent(queryInput: QueryInput(text:TextInput(text: text)));
    if (response.message==null){
      return;
    }else{
      addMessage(Message(text: DialogText(text: [text])));
    }
  }

  addMessage(Message message,[bool isUserMessage= false]){
    messages.add({'message':message,'isUserMessage':isUserMessage});
  }
}
