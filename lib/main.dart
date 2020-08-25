import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatbox/landing_page.dart';
import 'package:flutter_chatbox/services/firebase_auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Chatbox",
      theme: ThemeData(primarySwatch: Colors.purple),
      home: LandingPage(
        authService: FirebaseAuthService(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
