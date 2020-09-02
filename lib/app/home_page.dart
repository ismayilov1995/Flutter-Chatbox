import 'package:flutter/material.dart';
import 'package:flutter_chatbox/app/custom_buttom_nav.dart';
import 'package:flutter_chatbox/app/profile.dart';
import 'package:flutter_chatbox/app/tab_items.dart';
import 'package:flutter_chatbox/app/users.dart';
import 'package:flutter_chatbox/models/user.dart';

import 'conversation_page.dart';

class HomePage extends StatefulWidget {
  final AppUser user;

  HomePage({Key key, @required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.AllUsers;
  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.AllUsers: GlobalKey<NavigatorState>(),
    TabItem.Chats: GlobalKey<NavigatorState>(),
    TabItem.Profile: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> allPages() {
    return {
      TabItem.AllUsers: UsersPage(),
      TabItem.Chats: ConversationPage(),
      TabItem.Profile: ProfilePage()};
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CustomBottomNavigation(
        currentTab: _currentTab,
        pageBuilder: allPages(),
        navigatorKeys: navigatorKeys,
        onSelectedTab: (selectedTab) {
          if (selectedTab == _currentTab) {
            navigatorKeys[selectedTab]
                .currentState
                .popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentTab = selectedTab;
            });
          }
        },
      ),
    );
  }
}
