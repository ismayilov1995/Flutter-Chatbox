import 'package:flutter/cupertino.dart';
import 'package:flutter_chatbox/locator.dart';
import 'package:flutter_chatbox/models/user_model.dart';
import 'package:flutter_chatbox/repository/user_repository.dart';
import 'package:flutter_chatbox/services/auth_base.dart';

enum ViewState { IDLE, BUSY }

class UserViewmodel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.IDLE;
  UserRepository _userRepository = locator<UserRepository>();
  AppUser _user;

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  @override
  Future<AppUser> currentUser() async {
    try {
      state = ViewState.BUSY;
      _user = await _userRepository.currentUser();
      return _user;
    } catch (e) {
      print("Xeta: $e");
      return null;
    } finally {
      state = ViewState.IDLE;
    }
  }

  @override
  Future<AppUser> signInAnonymous() async {
    try {
      state = ViewState.BUSY;
      _user = await _userRepository.signInAnonymous();
      return _user;
    } catch (e) {
      print("Xeta: $e");
      state = ViewState.BUSY;
      return null;
    } finally {
      state = ViewState.IDLE;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.BUSY;
      return await _userRepository.signOut();
    } catch (e) {
      print("Xeta: $e");
      return null;
    } finally {
      state = ViewState.IDLE;
    }
  }
}
