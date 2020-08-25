import 'package:flutter/material.dart';
import 'package:flutter_chatbox/common_widget/social_login_button.dart';

class SignInPage extends StatelessWidget {
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
              radius: 10.0,
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
