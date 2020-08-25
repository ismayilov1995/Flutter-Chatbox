import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatbox/common_widget/social_login_button.dart';

class SignInPage extends StatelessWidget {
  final Function(User) onSignIn;

  const SignInPage({Key key, @required this.onSignIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Sign In",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            SocialLoginButton(
              buttonText: "Login with Google",
              buttonColor: Colors.white,
              textColor: Colors.black,
              buttonIcon: Image.asset("images/google-logo.png"),
              onPressed: () {},
            ),
            SocialLoginButton(
              buttonText: "Login with Facebook",
              buttonIcon: Image.asset("images/facebook-logo.png"),
              buttonColor: Colors.indigo,
              onPressed: () {},
            ),
            SocialLoginButton(
              buttonText: "Login with Email and Password",
              buttonIcon: Icon(
                Icons.email,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () {},
            ),
            SocialLoginButton(
              buttonText: "Guest mode",
              buttonColor: Colors.pinkAccent,
              buttonIcon: Icon(
                Icons.face,
                color: Colors.white,
                size: 32,
              ),
              onPressed: _guestMode,
            ),
          ],
        ),
      ),
    );
  }

  void _guestMode() async {
    UserCredential result = await FirebaseAuth.instance.signInAnonymously();
    onSignIn(result.user);
  }
}
