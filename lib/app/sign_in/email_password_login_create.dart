import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatbox/app/error_handler.dart';
import 'package:flutter_chatbox/common_widget/social_login_button.dart';
import 'package:flutter_chatbox/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class EmailLoginPage extends StatefulWidget {
  @override
  _EmailLoginPageState createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<EmailLoginPage> {
  bool isLoginMode = true;
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  TextEditingController _passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _userVM = Provider.of<UserViewmodel>(context);
    _passCtrl.text = '7090698';

    if (_userVM.user != null) {
      Future.delayed(
          Duration(milliseconds: 20), () => Navigator.of(context).pop());
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(isLoginMode ? 'Login' : 'Register'),
        ),
        body: _userVM.state == ViewState.IDLE
            ? buildSingleChildScrollView(context, _userVM)
            : Center(child: CircularProgressIndicator()));
  }

  SingleChildScrollView buildSingleChildScrollView(
      BuildContext context, UserViewmodel userVM) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.fromLTRB(12, 16, 12, 0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Login',
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                initialValue: "ismayil@emre.com",
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail),
                    hintText: "Email",
                    labelText: "Email",
                    border: OutlineInputBorder()),
                validator: (val) {
                  return userVM.emailErrorMsg == null
                      ? null
                      : userVM.emailErrorMsg;
                },
                onSaved: (val) => _email = val,
              ),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                obscureText: true,
                controller: _passCtrl,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.security),
                    hintText: "Password",
                    labelText: "Password",
                    border: OutlineInputBorder()),
                validator: (val) {
                  return userVM.passwordErrorMsg == null
                      ? null
                      : userVM.passwordErrorMsg;
                },
                onSaved: (val) => _password = val,
              ),
              SizedBox(
                height: 16,
              ),
              if (!isLoginMode) ...[
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.security),
                      hintText: "Password confirm",
                      labelText: "Password confirm",
                      border: OutlineInputBorder()),
                  validator: (val) {
                    return val == _passCtrl.text
                        ? null
                        : 'Password not matched';
                  },
                ),
                SizedBox(
                  height: 16,
                )
              ],
              SocialLoginButton(
                radius: 4.0,
                buttonText: isLoginMode ? 'Login' : 'Create Account',
                buttonColor: Theme.of(context).primaryColor,
                onPressed: () => _onSubmit(),
              ),
              FlatButton(
                child: Text(
                  isLoginMode ? "Create Account" : 'Login exists account',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () => setState(() => isLoginMode = !isLoginMode),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmit() async {
    _formKey.currentState.save();
    _formKey.currentState.validate();
    UserViewmodel _userVM = Provider.of<UserViewmodel>(context, listen: false);
    if (isLoginMode) {
      try {
        await _userVM.signInWithEmail(_email, _password);
      } on FirebaseAuthException catch (e) {
        debugPrint("Error from widget" + AppErrors.show(e.code));
      }
    } else {
      try {
        await _userVM.createWithEmail(_email, _password);
      } on FirebaseAuthException catch (e) {
        debugPrint("Error from widget" + AppErrors.show(e.code));
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Auth register error"),
                  content: Text(AppErrors.show(e.code)),
                  actions: [
                    FlatButton(
                      child: Text("Ok"),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ));
      }
    }
  }
}
