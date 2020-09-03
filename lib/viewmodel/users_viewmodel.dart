import 'package:flutter/material.dart';
import 'package:flutter_chatbox/models/user.dart';
import 'package:flutter_chatbox/repository/user_repository.dart';

import '../locator.dart';

enum UsersViewState { IDLE, BUSY, ERROR, LOADED }

class UsersViewmodel with ChangeNotifier {
  List<AppUser> _users;
  UsersViewState _state = UsersViewState.IDLE;
  AppUser _lastUser;
  bool _hasMore = true;
  static final _limit = 10;

  UserRepository _userRepository = locator<UserRepository>();

  UsersViewmodel() {
    _users = [];
    _lastUser = null;
    getPaginatedUsers(_lastUser, _limit, true);
  }

  List<AppUser> get users => _users;

  UsersViewState get state => _state;

  bool get hasMoreLoading => _hasMore;

  set state(UsersViewState value) {
    _state = value;
    notifyListeners();
  }

  Future<void> getPaginatedUsers(
      AppUser lastUser, int limit, bool isFirstLoad) async {
    if (_users.length > 0) _lastUser = _users.last;
    if (isFirstLoad) state = UsersViewState.BUSY;
    var newList = await _userRepository.getPaginatedUsers(_lastUser, limit);
    if (newList.length < limit) _hasMore = false;
    _users.addAll(newList);
    state = UsersViewState.LOADED;
  }

  Future<void> getMoreUsers() async {
    if (_hasMore) await getPaginatedUsers(_lastUser, _limit, false);
  }

  Future<void> onRefresh() async {
    _lastUser = null;
    _hasMore = true;
    _users = [];
    getPaginatedUsers(_lastUser, _limit, false);
    await Future.delayed(Duration(seconds: 1));
    return;
  }
}
