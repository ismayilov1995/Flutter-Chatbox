import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatbox/app/sign_in/email_password_login_create.dart';
import 'package:flutter_chatbox/common_widget/responsive_alertdialog.dart';
import 'package:flutter_chatbox/viewmodel/user_model.dart';
import 'package:provider/provider.dart';
import '../../common_widget/social_login_button.dart';
import '../error_handler.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        elevation: 0,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                onPressed: () => _loginWithGoogle(context),
              ),
              SocialLoginButton(
                buttonText: "Login with Facebook",
                buttonIcon: Image.asset("images/facebook-logo.png"),
                buttonColor: Colors.indigo,
                onPressed: () => _loginWithFacebook(context),
              ),
              SocialLoginButton(
                buttonText: "Login with Email and Password",
                buttonIcon: Icon(
                  Icons.email,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () => _loginWithEmail(context),
              ),
              SocialLoginButton(
                buttonText: "Guest mode",
                buttonColor: Colors.pinkAccent,
                buttonIcon: Icon(
                  Icons.face,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () => _guestMode(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _guestMode(BuildContext context) async {
    UserViewmodel _userVM = Provider.of<UserViewmodel>(context, listen: false);
    await _userVM.signInAnonymous();
  }

  void _loginWithGoogle(BuildContext context) async {
    UserViewmodel _userVM = Provider.of<UserViewmodel>(context, listen: false);
    try {
      await _userVM.signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      _showAlertDialog(e.code, context);
    }
  }

  void _loginWithFacebook(BuildContext context) async {
    UserViewmodel _userVM = Provider.of<UserViewmodel>(context, listen: false);
    try {
      await _userVM.signInWithFacebook();
    } on FirebaseAuthException catch (e) {
      _showAlertDialog(e.code, context);
    }
  }

  void _loginWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true, builder: (context) => EmailLoginPage()));
  }

  _showAlertDialog(String message, context) {
    ResponsiveAlertDialog(
      title: "Auth Error",
      content: AppErrors.show(message),
      allowBtn: "Understand",
    ).show(context);
  }
}
