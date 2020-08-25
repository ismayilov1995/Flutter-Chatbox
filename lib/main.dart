import 'package:flutter/material.dart';
import 'package:flutter_chatbox/sign_in_page.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Chatbox",
      theme: ThemeData(primarySwatch: Colors.purple),
      home: SignInPage(),
    );
  }
}
