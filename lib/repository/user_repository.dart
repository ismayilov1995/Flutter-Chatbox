import 'dart:io';

import 'package:flutter_chatbox/locator.dart';
import 'package:flutter_chatbox/models/message.dart';
import 'package:flutter_chatbox/models/user.dart';
import 'package:flutter_chatbox/services/auth_base.dart';
import 'package:flutter_chatbox/services/fake_auth_service.dart';
import 'package:flutter_chatbox/services/firebase_auth_service.dart';
import 'package:flutter_chatbox/services/firebase_storage_service.dart';
import 'package:flutter_chatbox/services/firestore_db_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  FirestoreDbService _dbService = locator<FirestoreDbService>();
  FirebaseStorageService _storageService = locator<FirebaseStorageService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<AppUser> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      AppUser _user = await _firebaseAuthService.currentUser();
      return await _dbService.getUser(_user.userID);
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
      return await _dbService.getUsers();
    }
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
}
