import 'package:flutter/material.dart';

class EmailLoginPage extends StatefulWidget {
  @override
  _EmailLoginPageState createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<EmailLoginPage> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login and Register"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
            ],
          ),
        ),
      ),
    );
  }
}
