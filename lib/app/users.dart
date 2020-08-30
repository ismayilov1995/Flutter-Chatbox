import 'package:flutter/material.dart';
import 'package:flutter_chatbox/app/test_page.dart';

class UsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
        actions: [
          IconButton(
            icon: Icon(Icons.account_balance_wallet),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => TestPage()));
            },
          )
        ],
      ),
      body: Center(
        child: Container(
          child: Text("Dil vuran istifadeciler"),
        ),
      ),
    );
  }
}
