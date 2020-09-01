import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatbox/models/message.dart';
import 'package:flutter_chatbox/models/user.dart';
import 'package:flutter_chatbox/viewmodel/user_model.dart';
import 'package:intl/intl.dart';
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
    ScrollController _scrollCtrl = ScrollController();
    final _userVM = Provider.of<UserViewmodel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(_receiver.profileUrl),
            ),
            SizedBox(width: 16),
            Text(widget.receiver.username),
          ],
        ),
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
                      reverse: true,
                      controller: _scrollCtrl,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return _singleMessageView(messages[index]);
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
                    if (isSend) {
                      _messageCtrl.clear();
                      _scrollCtrl.animateTo(0.0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _singleMessageView(Message message) {
    Color _msgColorFrom = Colors.blue[100];
    Color _msgColorTo = Colors.orange[100];
    var createdAt = _timestampToTime(message.createdAt ?? Timestamp.now());
    bool _fromMe = message.fromMe;
    if (_fromMe) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: _msgColorFrom, borderRadius: BorderRadius.circular(16)),
            child: Text(message.message),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Text(createdAt),
          )
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: _msgColorTo, borderRadius: BorderRadius.circular(16)),
            child: Text(message.message),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(createdAt),
          )
        ],
      );
    }
  }

  String _timestampToTime(Timestamp createdAt) {
    var _formatter = DateFormat.Hm();
    return _formatter.format(createdAt.toDate());
  }
}
