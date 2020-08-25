import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'sign_in_page.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    debugPrint(_user.uid);
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInPage();
    } else {
      return HomePage(_user);
    }
  }
}
