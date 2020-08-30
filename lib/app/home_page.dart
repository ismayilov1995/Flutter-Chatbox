import 'package:flutter/material.dart';
import 'package:flutter_chatbox/viewmodel/user_model.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';

class HomePage extends StatelessWidget {
  final AppUser user;

  HomePage({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    final _userVM = Provider.of<UserViewmodel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => _signOut(context),
          )
        ],
      ),
      body: Center(
        child: Text("Welcome back: ${user.userID}"),
      ),
    );
  }

  void _signOut(BuildContext context) async {
    final _userVM = Provider.of<UserViewmodel>(context, listen: false);
    await _userVM.signOut();
  }
}
