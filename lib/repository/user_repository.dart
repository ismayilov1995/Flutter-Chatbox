import 'dart:io';

import 'package:flutter_chatbox/locator.dart';
import 'package:flutter_chatbox/models/chat.dart';
import 'package:flutter_chatbox/models/message.dart';
import 'package:flutter_chatbox/models/user.dart';
import 'package:flutter_chatbox/services/auth_base.dart';
import 'package:flutter_chatbox/services/fake_auth_service.dart';
import 'package:flutter_chatbox/services/firebase_auth_service.dart';
import 'package:flutter_chatbox/services/firebase_storage_service.dart';
import 'package:flutter_chatbox/services/firestore_db_service.dart';
import 'package:timeago/timeago.dart' as timeago;

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  FirestoreDbService _dbService = locator<FirestoreDbService>();
  FirebaseStorageService _storageService = locator<FirebaseStorageService>();

  AppMode appMode = AppMode.RELEASE;
  List<AppUser> allUsers = List<AppUser>();

  @override
  Future<AppUser> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      AppUser _user = await _firebaseAuthService.currentUser();
      if (_user != null) return await _dbService.getUser(_user.userID);
      return null;
    }
  }

  @override
  Future<AppUser> signInAnonymous() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInAnonymous();
    } else {
      return await _firebaseAuthService.signInAnonymous();
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithGoogle();
    } else {
      AppUser _user = await _firebaseAuthService.signInWithGoogle();
      bool res = await _dbService.saveUser(_user);
      if (res)
        return await _dbService.getUser(_user.userID);
      else
        return null;
    }
  }

  @override
  Future<AppUser> signInWithFacebook() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithFacebook();
    } else {
      AppUser _user = await _firebaseAuthService.signInWithFacebook();
      bool res = await _dbService.saveUser(_user);
      if (res)
        return await _dbService.getUser(_user.userID);
      else
        return null;
    }
  }

  @override
  Future<AppUser> signInWithEmail(String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithEmail(email, password);
    } else {
      AppUser _user =
          await _firebaseAuthService.signInWithEmail(email, password);
      return _dbService.getUser(_user.userID);
    }
  }

  @override
  Future<AppUser> createWithEmail(String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.createWithEmail(email, password);
    } else {
      AppUser _user =
          await _firebaseAuthService.createWithEmail(email, password);
      bool res = await _dbService.saveUser(_user);
      if (res)
        return await _dbService.getUser(_user.userID);
      else
        return null;
    }
  }

  Future<bool> updateUsername(String userID, String username) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.updateUsername(userID, username);
    } else {
      return await _dbService.updateUsername(userID, username);
    }
  }

  Future<String> uploadImage(String userID, String s, File profilePhoto) async {
    if (appMode == AppMode.DEBUG) {
      return await Future.value('');
    } else {
      String url = await _storageService.uploadImage(userID, s, profilePhoto);
      await _dbService.updateProfilePhoto(userID, url);
      return url;
    }
  }

  Future<List<AppUser>> getUsers() async {
    if (appMode == AppMode.DEBUG) {
      return await Future.value(List<AppUser>());
    } else {
      allUsers = await _dbService.getUsers();
      return allUsers;
    }
  }

  Future<List<Chat>> getConversations(String userID) async {
    if (appMode == AppMode.DEBUG) {
      return await Future.value(List<Chat>());
    } else {
      DateTime time = await _dbService.showTime(userID);
      var conversationList = await _dbService.getConversations(userID);
      for (var item in conversationList) {
        var userInUserlist = getUserFromList(item.talk);
        if (userInUserlist != null) {
          item.talkUsername = userInUserlist.username;
          item.talkProfilephoto = userInUserlist.profileUrl;
        } else {
          var userFromDb = await _dbService.getUser(item.talk);
          item.talkUsername = userFromDb.username;
          item.talkProfilephoto = userFromDb.profileUrl;
        }
        _calcTimeAgo(item, time);
      }
      return conversationList;
    }
  }

  AppUser getUserFromList(String userID) {
    for (int i = 0; i < allUsers.length; i++) {
      if (allUsers[i].userID == userID) {
        return allUsers[i];
      }
    }
    return null;
  }

  Stream<List<Message>> getChatMessages(String senderID, String receiverID) {
    if (appMode == AppMode.DEBUG) {
      return Stream.value(List<Message>());
    } else {
      return _dbService.getChatMessages(senderID, receiverID);
    }
  }

  Future<bool> sendMessage(Message message) async {
    if (appMode == AppMode.DEBUG) {
      return Future.value(true);
    } else {
      return await _dbService.sendMessage(message);
    }
  }

  void _calcTimeAgo(Chat item, DateTime time) {
    var duration = time.difference(item.createdAt.toDate());
    timeago.setLocaleMessages('az', timeago.AzMessages());
    item.timeDifference = timeago.format(time.subtract(duration), locale: 'az');
  }
}
