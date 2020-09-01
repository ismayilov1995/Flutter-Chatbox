import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatbox/chat_page.dart';
import 'package:flutter_chatbox/models/user.dart';
import 'package:flutter_chatbox/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserViewmodel _userVM = Provider.of<UserViewmodel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
      ),
      body: Center(
        child: FutureBuilder<List<AppUser>>(
          future: _userVM.getUsers(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            if (snap.hasData) {
              var users = snap.data;
              int index = users.indexWhere(
                  (element) => element.userID == _userVM.user.userID);
              users.removeAt(index);
              return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    AppUser user = users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.profileUrl),
                      ),
                      title: Text(user.username),
                      subtitle: Text(user.email),
                      trailing: Icon(Icons.arrow_right),
                      onTap: () => Navigator.of(context, rootNavigator: true)
                          .push(CupertinoPageRoute(
                              builder: (context) => ChatPage(
                                    sender: _userVM.user,
                                    receiver: user,
                                  ))),
                    );
                  });
            } else if (snap.hasError) {
              print(snap.error.toString());
              return Text('Get an error');
            } else {
              return Text("User not found");
            }
          },
        ),
      ),
    );
  }
}
