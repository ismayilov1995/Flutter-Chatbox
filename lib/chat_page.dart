import 'package:flutter/material.dart';
import 'package:flutter_chatbox/models/user.dart';

class ChatPage extends StatefulWidget {
  final AppUser sender, receiver;

  const ChatPage({@required this.sender, @required this.receiver});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiver.username),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [Text('message')],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: _messageCtrl,
                  decoration: InputDecoration(
                    hintText: "Type message...",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40)),
                  ),
                )),
                SizedBox(
                  width: 12,
                ),
                FloatingActionButton(
                  child: Icon(Icons.send),
                  onPressed: () {},
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
