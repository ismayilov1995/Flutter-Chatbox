import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatbox/common_widget/responsive_alertdialog.dart';
import 'package:flutter_chatbox/common_widget/social_login_button.dart';
import 'package:flutter_chatbox/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _usernameCtrl;

  @override
  void initState() {
    super.initState();
    _usernameCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserViewmodel _userVM = Provider.of<UserViewmodel>(context);
    _usernameCtrl.text = _userVM.user.username;
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Stack(children: [
                  CircleAvatar(
                    radius: 75.0,
                    backgroundImage: NetworkImage(_userVM.user.profileUrl),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.photo_camera),
                        iconSize: 36,
                        onPressed: () {},
                      ))
                ]),
              ),
              Text(
                _usernameCtrl.text,
                style: Theme.of(context).textTheme.headline4,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  initialValue: _userVM.user.email,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: "Email", border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
                child: TextFormField(
                  controller: _usernameCtrl,
                  decoration: InputDecoration(
                      labelText: "Username", border: OutlineInputBorder()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
                child: SocialLoginButton(
                  buttonText: "Save changes",
                  onPressed: () {
                    _updateUsername(context, _userVM);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _signOut(BuildContext context) async {
    final _userVM = Provider.of<UserViewmodel>(context, listen: false);
    await _userVM.signOut();
  }

  void _confirmSignOut(BuildContext context) async {
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

  void _updateUsername(BuildContext context, UserViewmodel _userModel) async {
    if (_userModel.user.username != _usernameCtrl.text) {
      if (await _userModel.updateUserName(
          _userModel.user.userID, _usernameCtrl.text)) {
        _userModel.user.username = _usernameCtrl.text;
      } else {
        ResponsiveAlertDialog(
          title: "Warning",
          content: "Username already in use, try with difference",
          allowBtn: "Ok",
        ).show(context);
      }
    } else {
      ResponsiveAlertDialog(
        title: "Warning",
        content: "You not change anything",
        allowBtn: "Ok",
      ).show(context);
    }
  }
}
