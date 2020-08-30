import 'package:flutter_chatbox/locator.dart';
import 'package:flutter_chatbox/models/user.dart';
import 'package:flutter_chatbox/services/auth_base.dart';
import 'package:flutter_chatbox/services/fake_auth_service.dart';
import 'package:flutter_chatbox/services/firebase_auth_service.dart';
import 'package:flutter_chatbox/services/firestore_db_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  FirestoreDbService _dbService = locator<FirestoreDbService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<AppUser> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      return await _firebaseAuthService.currentUser();
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
        return _user;
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
        return _user;
      else
        return null;
    }
  }

  @override
  Future<AppUser> signInWithEmail(String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithEmail(email, password);
    } else {
      return await _firebaseAuthService.signInWithEmail(email, password);
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
        return _user;
      else
        return null;
    }
  }
}
