import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chatbox/locator.dart';
import 'package:flutter_chatbox/models/chat.dart';
import 'package:flutter_chatbox/models/message.dart';
import 'package:flutter_chatbox/models/user.dart';
import 'package:flutter_chatbox/repository/user_repository.dart';
import 'package:flutter_chatbox/services/auth_base.dart';

enum ViewState { IDLE, BUSY }

class UserViewmodel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.IDLE;
  UserRepository _userRepository = locator<UserRepository>();
  String emailErrorMsg, passwordErrorMsg;
  AppUser _user;

  ViewState get state => _state;

  AppUser get user => _user;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  UserViewmodel() {
    currentUser();
  }

  @override
  Future<AppUser> currentUser() async {
    try {
      state = ViewState.BUSY;
      _user = await _userRepository.currentUser();
      return _user;
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
    } finally {
      state = ViewState.IDLE;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.BUSY;
      _user = null;
      return await _userRepository.signOut();
    } finally {
      state = ViewState.IDLE;
    }
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    try {
      state = ViewState.BUSY;
      _user = await _userRepository.signInWithGoogle();
      if (_user != null) return _user;
      return null;
    } finally {
      state = ViewState.IDLE;
    }
  }

  @override
  Future<AppUser> signInWithFacebook() async {
    try {
      state = ViewState.BUSY;
      _user = await _userRepository.signInWithFacebook();
      return _user;
    } finally {
      state = ViewState.IDLE;
    }
  }

  @override
  Future<AppUser> signInWithEmail(String email, String password) async {
    try {
      if (_checkPasswordEmail(email, password)) {
        state = ViewState.BUSY;
        _user = await _userRepository.signInWithEmail(email, password);
        return _user;
      }
      return null;
    } finally {
      state = ViewState.IDLE;
    }
  }

  @override
  Future<AppUser> createWithEmail(String email, String password) async {
    try {
      if (_checkPasswordEmail(email, password)) {
        state = ViewState.BUSY;
        _user = await _userRepository.createWithEmail(email, password);
        return _user;
      } else {
        return null;
      }
    } finally {
      state = ViewState.IDLE;
    }
  }

  bool _checkPasswordEmail(String email, String password) {
    bool result = true;
    if (password.length < 6) {
      passwordErrorMsg = "Minimum 6 characters";
      result = false;
    } else
      passwordErrorMsg = null;
    if (!email.contains('@')) {
      emailErrorMsg = "Invalid email format";
      result = false;
    } else
      emailErrorMsg = null;
    return result;
  }

  Future<bool> updateUserName(String userID, String username) async {
    bool res = await _userRepository.updateUsername(userID, username);
    if (res) user.username = username;
    return res;
  }

  Future<String> uploadImage(String userID, String s, File profilePhoto) async {
    var url = await _userRepository.uploadImage(userID, s, profilePhoto);
    user.profileUrl = url;
    return url;
  }

  Future<List<AppUser>> getUsers() async {
    return await _userRepository.getUsers();
  }

  Future<List<Chat>> getConversations(String userID) async {
    return await _userRepository.getConversations(userID);
  }

  Stream<List<Message>> getChatMessages(String senderID, String receiverID) {
    return _userRepository.getChatMessages(senderID, receiverID);
  }

  Future<List<AppUser>> getPaginatedUsers(AppUser lastUser, int limit) async {
    return await _userRepository.getPaginatedUsers(lastUser, limit);
  }
}
