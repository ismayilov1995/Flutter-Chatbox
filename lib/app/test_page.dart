import 'package:flutter/material.dart';
import 'package:flutter_chatbox/app/home_page.dart';
import 'package:flutter_chatbox/app/profile.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('data'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_balance_wallet),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          )
        ],
      ),
      body: Container(
        color: Colors.amber,
        child: Text("asaasasa"),
      ),
    );
  }
}
