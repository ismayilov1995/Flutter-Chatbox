import 'package:flutter/material.dart';
import 'package:flutter_chatbox/common_widget/responsive_alertdialog.dart';
import 'package:flutter_chatbox/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => _confirmSignOut(context),
          )
        ],
      ),
      body: Center(
        child: Container(
          child: Text("Dil vuran istifadecinin profili " +
              Provider.of<UserViewmodel>(context).user.username),
        ),
      ),
    );
  }

  void _signOut(BuildContext context) async {
    final _userVM = Provider.of<UserViewmodel>(context, listen: false);
    await _userVM.signOut();
  }

  Future<bool> _confirmSignOut(BuildContext context) async {
    final allow = await ResponsiveAlertDialog(
      title: "Sure?",
      content: "Are you sure logout application?",
      allowBtn: "I'm sure",
      cancelBtn: "Cancel",
    ).show(context);
    if (allow) {
      _signOut(context);
    }
  }
}
