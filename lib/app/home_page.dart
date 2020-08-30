import 'package:flutter/material.dart';
import 'package:flutter_chatbox/app/custom_buttom_nav.dart';
import 'package:flutter_chatbox/app/tab_items.dart';
import 'package:flutter_chatbox/viewmodel/user_model.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';

class HomePage extends StatefulWidget {
  final AppUser user;

  HomePage({Key key, @required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.AllUsers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => _signOut(context),
          )
        ],
      ),
      body: CustomBottomNavigation(
        currentTab: _currentTab,
        onSelectedTab: (selectedTab) => _currentTab = selectedTab,
      ),
    );
  }

  void _signOut(BuildContext context) async {
    final _userVM = Provider.of<UserViewmodel>(context, listen: false);
    await _userVM.signOut();
  }
}
