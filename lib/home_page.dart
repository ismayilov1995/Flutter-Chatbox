import 'package:flutter/material.dart';
import 'package:flutter_chatbox/repository/user_repository.dart';
import 'models/user_model.dart';
import 'services/auth_base.dart';

class HomePage extends StatelessWidget {
  final AuthBase _authService = UserRepository();
  final VoidCallback onSignOut;
  final AppUser user;

  HomePage({Key key, @required this.onSignOut, @required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _signOut,
          )
        ],
      ),
      body: Center(
        child: Text("Welcome back: ${user.userID}"),
      ),
    );
  }

  Future<bool> _signOut() async {
    bool res = await _authService.signOut();
    onSignOut();
    return res;
  }
}
