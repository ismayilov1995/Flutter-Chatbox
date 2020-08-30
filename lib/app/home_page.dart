import 'package:flutter/material.dart';
import 'package:flutter_chatbox/app/custom_buttom_nav.dart';
import 'package:flutter_chatbox/app/profile.dart';
import 'package:flutter_chatbox/app/tab_items.dart';
import 'package:flutter_chatbox/app/users.dart';
import 'package:flutter_chatbox/models/user_model.dart';

class HomePage extends StatefulWidget {
  final AppUser user;
  HomePage({Key key, @required this.user}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.AllUsers;
  Map<TabItem, Widget> allPages() {
    return {TabItem.AllUsers: UsersPage(), TabItem.Profile: ProfilePage()};
  }
  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigation(
      currentTab: _currentTab,
      pageBuilder: allPages(),
      onSelectedTab: (selectedTab) {
        setState(() {
          _currentTab = selectedTab;
        });
      },
    );
  }
}
