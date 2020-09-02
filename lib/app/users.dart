import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatbox/app/chat_page.dart';
import 'package:flutter_chatbox/models/user.dart';
import 'package:flutter_chatbox/viewmodel/user_model.dart';
import 'package:flutter_chatbox/viewmodel/users_viewmodel.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.minScrollExtent &&
          !_scrollController.position.outOfRange) {
        loadMoreUsers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Users"),
        ),
        body: Consumer<UsersViewmodel>(
          builder: (context, model, child) {
            switch (model.state) {
              case UsersViewState.BUSY:
                return Center(child: CircularProgressIndicator());
              case UsersViewState.LOADED:
                return ListView.builder(
                    controller: _scrollController,
                    itemCount: model.users.length,
                    itemBuilder: (context, index) {
                      AppUser user = model.users[index];
                      // if (index == _users.length - 1) return _loadingIndicator();
                      return _userListItem(index);
                    });
              default:
                return Center(
                  child: Text('Error'),
                );
            }
          },
        ));
  }

  // void getUsers() async {
  //   final _userVM = Provider.of<UserViewmodel>(context, listen: false);
  //   if (!_hasMore) return;
  //   if (_isLoading) return;
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   List<AppUser> users = await _userVM.getPaginatedUsers(_lastUser, _limit);
  //   if (_lastUser == null) {
  //     _users = [];
  //     _users.addAll(users);
  //   } else {
  //     _users.addAll(users);
  //   }
  //   if (users.length < _limit) _hasMore = false;
  //   _lastUser = _users.last;
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  // Widget _generateUsersList() {
  //   if (_users.length <= 1)
  //     return Center(
  //         child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Text(
  //           "No one use this app, you're first 🙃",
  //           style: Theme.of(context).textTheme.headline6,
  //         ),
  //         SizedBox(
  //           height: 16,
  //         ),
  //         FlatButton.icon(
  //             onPressed: _onRefresh,
  //             icon: Icon(Icons.refresh),
  //             label: Text('Refresh'))
  //       ],
  //     ));
  //   final _userVM = Provider.of<UserViewmodel>(context, listen: false);
  //   int userIndex =
  //       _users.indexWhere((element) => element.userID == _userVM.user.userID);
  //   if (userIndex >= 0) _users.removeAt(userIndex);
  //   return RefreshIndicator(onRefresh: _onRefresh, child: null);
  // }

  Widget _loadingIndicator() {
    return _isLoading
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Opacity(
                  opacity: _isLoading ? 1 : 0,
                  child: CircularProgressIndicator()),
            ),
          )
        : null;
  }

  Future<void> _onRefresh() async {
    // _lastUser = null;
    // _hasMore = true;
    // getUsers();
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Widget _userListItem(int index) {
    final _userVM = Provider.of<UserViewmodel>(context, listen: false);
    final _usersVM = Provider.of<UsersViewmodel>(context, listen: false);
    AppUser user = _usersVM.users[index];
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.profileUrl),
      ),
      title: Text(user.username),
      subtitle: Text(user.email),
      trailing: Icon(Icons.arrow_right),
      onTap: () =>
          Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
              builder: (context) => ChatPage(
                    sender: _userVM.user,
                    receiver: user,
                  ))),
    );
  }

  void loadMoreUsers() async {
    final _usersVM = Provider.of<UsersViewmodel>(context, listen: false);
    if (!_isLoading) {
      _isLoading = true;
      await _usersVM.getMoreUsers();
      _isLoading = false;
    }
  }
}
