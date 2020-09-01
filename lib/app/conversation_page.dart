import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatbox/models/chat.dart';
import 'package:flutter_chatbox/models/user.dart';
import 'package:flutter_chatbox/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

import 'chat_page.dart';

class ConversationPage extends StatefulWidget {
  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  @override
  Widget build(BuildContext context) {
    UserViewmodel _userVM = Provider.of<UserViewmodel>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Chats"),
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: FutureBuilder<List<Chat>>(
            future: _userVM.getConversations(_userVM.user.userID),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              if (snap.hasData) {
                if (snap.data.length <= 0)
                  return Center(child: Text("You haven't conversation yet 😶"));
                return ListView.builder(
                    itemCount: snap.data.length,
                    itemBuilder: (context, index) {
                      Chat chat = snap.data[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(chat.talkProfilephoto),
                        ),
                        title: Text(chat.talkUsername),
                        subtitle: Text(chat.lastMessage),
                        onTap: () => Navigator.of(context, rootNavigator: true)
                            .push(CupertinoPageRoute(
                                builder: (context) => ChatPage(
                                    sender: _userVM.user,
                                    receiver: AppUser.idAndImage(
                                        userID: chat.talk,
                                        username: chat.talkUsername,
                                        profileUrl: chat.talkProfilephoto)))),
                      );
                    });
              } else {
                return Flexible(
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text("Get an error")),
                );
              }
            },
          ),
        ));
  }

  Future<void> _onRefresh() async {
    setState(() {});
    // Future.delayed(Duration(seconds: 1)); Indicator ne qeder firlansin
    return;
  }
}
