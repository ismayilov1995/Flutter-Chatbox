import 'package:flutter/material.dart';
import 'package:flutter_chatbox/models/user.dart';
import 'package:flutter_chatbox/repository/user_repository.dart';

import '../locator.dart';

enum UsersViewState { IDLE, BUSY, ERROR, LOADED }

class UsersViewmodel with ChangeNotifier {
  List<AppUser> _users;
  UsersViewState _state = UsersViewState.IDLE;
  AppUser _lastUser;
  static final _limit = 10;

  UserRepository _userRepository = locator<UserRepository>();

  UsersViewmodel() {
    _users = [];
    _lastUser = null;
    getPaginatedUsers(_lastUser, _limit);
  }

  List<AppUser> get users => _users;

  UsersViewState get state => _state;

  set state(UsersViewState value) {
    _state = value;
    notifyListeners();
  }

  Future<List<AppUser>> getPaginatedUsers(AppUser lastUser, int limit) async {
    state = UsersViewState.BUSY;
    _users = await _userRepository.getPaginatedUsers(lastUser, limit);
    state = UsersViewState.LOADED;
    return _users;
  }


}
