import 'package:flutter/material.dart';
import 'package:flutter_chatbox/common_widget/social_login_button.dart';
import 'package:flutter_chatbox/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class EmailLoginPage extends StatefulWidget {
  @override
  _EmailLoginPageState createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<EmailLoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login and Register"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(12, 16, 12, 0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon:  Icon(Icons.mail),
                    hintText: "Email",
                    labelText: "Email",
                    border: OutlineInputBorder()
                  ),
                  validator: (val) {
                    return val.contains('@') ? null : 'Input valid email format';
                  },
                  onSaved: (val) => _email = val,
                ),
                SizedBox(height: 16,),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                      prefixIcon:  Icon(Icons.security),
                      hintText: "Password",
                      labelText: "Password",
                      border: OutlineInputBorder()
                  ),
                  validator: (val) {
                    return val.length > 5 ? null : 'Minimum length 6';
                  },
                  onSaved: (val) => _password = val,
                ),
                SizedBox(height: 16,),
                SocialLoginButton(
                  radius: 4.0,
                  buttonText: "Login",
                  buttonColor: Theme.of(context).primaryColor,
                  onPressed: () => _onSubmit(context),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit(BuildContext context) async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      UserViewmodel _userVM = Provider.of<UserViewmodel>(context, listen: false);
      _userVM.signInWithEmail(_email, _password);
    }
  }
}
