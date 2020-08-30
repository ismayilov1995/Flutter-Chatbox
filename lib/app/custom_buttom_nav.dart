import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatbox/app/tab_items.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation(
      {Key key, @required this.currentTab, @required this.onSelectedTab, @required this.pageBuilder})
      : super(key: key);
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> pageBuilder;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _createNavItem(TabItem.AllUsers),
          _createNavItem(TabItem.Profile),
        ],
        onTap: (index) => onSelectedTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final showItem = TabItem.values[index];
        return CupertinoTabView(
          builder: (context) {
            return pageBuilder[showItem];
          },
        );
      },
    );
  }

  BottomNavigationBarItem _createNavItem(TabItem tabItem) {
    final createdTab = TabItemData.allTabs[tabItem];
    return BottomNavigationBarItem(
        icon: Icon(createdTab.icon), title: Text(createdTab.title));
  }
}
