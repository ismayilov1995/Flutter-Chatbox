import 'package:flutter/material.dart';
import 'models/user_model.dart';
import 'services/auth_base.dart';
import 'services/firebase_auth_service.dart';
import 'home_page.dart';
import 'locator.dart';
import 'sign_in_page.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  AuthBase _authService = locator<FirebaseAuthService>();
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
        onSignIn: updateUser,
      );
    } else {
      return HomePage(
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
    _user = await _authService.currentUser();
  }
}
