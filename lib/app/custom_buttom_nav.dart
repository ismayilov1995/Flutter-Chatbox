import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatbox/app/tab_items.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation(
      {Key key, @required this.currentTab, @required this.onSelectedTab})
      : super(key: key);
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _createNavItem(TabItem.AllUsers),
          _createNavItem(TabItem.Profile),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) =>
              Container(
                child: Text('data'),
              ),
        );
      },
    );
  }

  BottomNavigationBarItem _createNavItem(TabItem tabItem) {
    final createdTab = TabItemData.allTabs[tabItem];
    return BottomNavigationBarItem(
        icon: Icon(createdTab.icon),
        title: Text(createdTab.title)
    );
  }
}
