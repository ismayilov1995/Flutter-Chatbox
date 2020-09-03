import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_chatbox/models/message.dart';
import 'package:flutter_chatbox/models/user.dart';
import 'package:flutter_chatbox/viewmodel/chat_viewmodel.dart';
import 'package:flutter_chatbox/viewmodel/user_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isLoading = false;
  final _messageCtrl = TextEditingController();
  ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    final _chatVM = Provider.of<ChatViewmodel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(_chatVM.receiver.profileUrl),
            ),
            SizedBox(width: 16),
            Text(_chatVM.receiver.username),
          ],
        ),
      ),
      body: Column(
        children: [buildChatList(), buildSendForm(_chatVM)],
      ),
    );
  }

  // Center(child: Text("You send the first message 😍"));

  Widget buildChatList() {
    return Consumer<ChatViewmodel>(
      builder: (context, model, child) {
        return Expanded(
            child: model.state == ChatViewState.BUSY
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    reverse: true,
                    controller: _scrollCtrl,
                    itemCount: model.messages.length,
                    itemBuilder: (context, index) {
                      if (model.hasMore && model.messages.length - 1 == index) {
                        return _loadingIndicator();
                      }
                      return _singleMessageView(model.messages[index]);
                    }));
      },
    );
  }

  Padding _loadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: SizedBox(
        child: CircularProgressIndicator(),
        height: 20,
        width: 20,
      )),
    );
  }

  Widget buildSendForm(ChatViewmodel chatVM) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
              child: TextFormField(
            controller: _messageCtrl,
            decoration: InputDecoration(
              hintText: "Type message...",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
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
                  from: chatVM.sender.userID,
                  to: chatVM.receiver.userID,
                  fromMe: true,
                  message: _messageCtrl.text);
              _messageCtrl.clear();
              var isSend = await chatVM.sendMessage(message);
              if (isSend) {
                _scrollCtrl.animateTo(0.0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              }
            },
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
            margin: EdgeInsets.fromLTRB(50,10,10,10),
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
            margin: EdgeInsets.fromLTRB(10,10,50,10),
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

  void _scrollListener() {
    if (_scrollCtrl.offset >= _scrollCtrl.position.maxScrollExtent &&
        !_scrollCtrl.position.outOfRange) {
      _loadOldMessages();
    }
  }

  void _loadOldMessages() async {
    if (!_isLoading) {
      _isLoading = true;
      final _chatVM = Provider.of<ChatViewmodel>(context, listen: false);
      await _chatVM.loadOldMessages();
      _isLoading = false;
    }
  }
}
