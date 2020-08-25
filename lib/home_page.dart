import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final User _user;
  final VoidCallback onSignOut;

  HomePage(this._user, {Key key, @required this.onSignOut}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              onSignOut();
            },
          )
        ],
      ),
      body: Center(
        child: Text("Welcome back: ${_user.uid}"),
      ),
    );
  }
}
