import 'package:flutter/material.dart';
import 'package:flutter_chatbox/models/message.dart';
import 'package:flutter_chatbox/models/user.dart';
import 'package:flutter_chatbox/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

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
    AppUser _sender = widget.sender;
    AppUser _receiver = widget.receiver;
    final _userVM = Provider.of<UserViewmodel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiver.username),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _userVM.getChatMessages(_sender.userID, _receiver.userID),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                if (snap.hasData) {
                  List<Message> messages = snap.data;
                  if (messages.length <= 0)
                    return Center(child: Text("You send the first message 😍"));
                  return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        Message message = messages[index];
                        return ListTile(
                          title: Text(message.message),
                        );
                      });
                } else {
                  return Text('Got an error');
                }
              },
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
                  onPressed: () async {
                    if (_messageCtrl.text.trim().length == 0) return;
                    Message message = Message(
                        from: _sender.userID,
                        to: _receiver.userID,
                        fromMe: true,
                        message: _messageCtrl.text);
                    var isSend = await _userVM.sendMessage(message);
                    if (isSend) _messageCtrl.clear();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
