import 'package:flutter/material.dart';
import 'package:flutter_chatbox/models/user_model.dart';
import 'package:flutter_chatbox/services/auth_base.dart';
import 'home_page.dart';
import 'sign_in_page.dart';

class LandingPage extends StatefulWidget {
  final AuthBase authService;

  const LandingPage({Key key, @required this.authService}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  AppUser _user;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInPage(
        authService: widget.authService,
        onSignIn: updateUser,
      );
    } else {
      return HomePage(
        authService: widget.authService,
        onSignOut: () => updateUser(null),
        user: _user,
      );
    }
  }

  void updateUser(AppUser user) {
    setState(() {
      _user = user;
    });
  }

  void _checkUser() async {
    _user = await widget.authService.currentUser();
  }
}
