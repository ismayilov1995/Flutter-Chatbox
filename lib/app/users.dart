import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_chatbox/models/user.dart';
import 'package:flutter_chatbox/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<AppUser> _users;
  bool _isLoading = false;
  bool _hasMore = true;
  int _limit = 10;
  AppUser _lastUser;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      getUsers();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position != 0) {
          getUsers();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Users"),
        ),
        body: _users == null
            ? Center(child: CircularProgressIndicator())
            : _generateUsersList());
  }

  void getUsers() async {
    final _userVM = Provider.of<UserViewmodel>(context, listen: false);
    if (!_hasMore) return;
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    List<AppUser> users = await _userVM.getPaginatedUsers(_lastUser, _limit);
    if (_lastUser == null) {
      _users = [];
      _users.addAll(users);
    } else {
      _users.addAll(users);
    }
    if (users.length < _limit) _hasMore = false;
    _lastUser = _users.last;
    setState(() {
      _isLoading = false;
    });
  }

  Widget _generateUsersList() {
    if (_users.length <= 1)
      return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("No one use this app, you're first 🙃", style: Theme.of(context).textTheme.headline6,),
              SizedBox(height: 16,),
              FlatButton.icon(
                  onPressed: _onRefresh,
                  icon: Icon(Icons.refresh),
                  label: Text('Refresh'))
            ],
          ));
    final _userVM = Provider.of<UserViewmodel>(context, listen: false);
    int userIndex =
        _users.indexWhere((element) => element.userID == _userVM.user.userID);
    if (userIndex >= 0) _users.removeAt(userIndex);
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
          controller: _scrollController,
          itemCount: _users.length,
          itemBuilder: (context, index) {
            AppUser user = _users[index];
            if (index == _users.length - 1) return _loadingIndicator();
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.profileUrl),
              ),
              title: Text(user.username),
              subtitle: Text(user.email),
              trailing: Icon(Icons.arrow_right),
            );
          }),
    );
  }

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
    _lastUser = null;
    _hasMore = true;
    getUsers();
    await Future.delayed(Duration(seconds: 1));
    return;
  }
}

/*
Center(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: FutureBuilder<List<AppUser>>(
            future: _userVM.getUsers(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              if (snap.hasData) {
                var users = snap.data;
                if (snap.data.length <= 1)
                  return Center(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("No one use this app, you're first 🙃", style: Theme.of(context).textTheme.headline6,),
                      SizedBox(height: 16,),
                      FlatButton.icon(
                          onPressed: _onRefresh,
                          icon: Icon(Icons.refresh),
                          label: Text('Refresh'))
                    ],
                  ));
                int index = users.indexWhere(
                    (element) => element.userID == _userVM.user.userID);
                users.removeAt(index);
                return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      AppUser user = users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.profileUrl),
                        ),
                        title: Text(user.username),
                        subtitle: Text(user.email),
                        trailing: Icon(Icons.arrow_right),
                        onTap: () => Navigator.of(context, rootNavigator: true)
                            .push(CupertinoPageRoute(
                                builder: (context) => ChatPage(
                                      sender: _userVM.user,
                                      receiver: user,
                                    ))),
                      );
                    });
              } else if (snap.hasError) {
                print(snap.error.toString());
                return Text('Get an error');
              } else {
                return Text("User not found");
              }
            },
          ),
        ),
      )


        Future<void> _onRefresh() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1));
    return;
  }
 */
