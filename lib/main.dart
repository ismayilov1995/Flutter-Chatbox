import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'landing_page.dart';
import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Chatbox",
      theme: ThemeData(primarySwatch: Colors.purple),
      home: LandingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
