import 'package:flutter/material.dart';
import 'package:flutter_chatbox/models/user.dart';

class ChatPage extends StatefulWidget {
  final AppUser sender, receiver;

  const ChatPage({@required this.sender, @required this.receiver});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiver.username),
      ),
      body: Column(
        children: [
          Text('sad'),
        ],
      ),
    );
  }
}
