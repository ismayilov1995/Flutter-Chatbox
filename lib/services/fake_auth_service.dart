import 'package:flutter_chatbox/models/user.dart';
import 'package:flutter_chatbox/services/auth_base.dart';

class FakeAuthService implements AuthBase {
  String userID = "I7sm5a504y8I09l6";

  @override
  Future<AppUser> currentUser() async {
    return await Future.value(AppUser(userID: userID, email: 'fake@fake.com'));
  }

  @override
  Future<AppUser> signInAnonymous() async {
    return await Future.delayed(Duration(seconds: 2),
        () => AppUser(userID: userID, email: 'fake@fake.com'));
  }

  @override
  Future<bool> signOut(String userID) {
    return Future.value(true);
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    return await Future.delayed(Duration(seconds: 2),
        () => AppUser(userID: userID + "with google", email: 'fake@fake.com'));
  }

  @override
  Future<AppUser> signInWithFacebook() async {
    return await Future.delayed(
        Duration(seconds: 2),
        () =>
            AppUser(userID: userID + "with facebook", email: 'fake@fake.com'));
  }

  @override
  Future<AppUser> signInWithEmail(String email, String password) async {
    final String _fakeEmail = "test@test.com";
    final String _fakePass = "7090698";
    if (email != _fakeEmail && password != _fakePass) return null;
    return await Future.delayed(
        Duration(seconds: 2),
        () => AppUser(
            userID: userID + "logined" + _fakeEmail, email: 'fake@fake.com'));
  }

  @override
  Future<AppUser> createWithEmail(String email, String password) async {
    return await Future.delayed(
        Duration(seconds: 2),
        () => AppUser(
            userID: userID + "registered" + email, email: 'fake@fake.com'));
  }

  Future<bool> updateUsername(String userID, String username) {
    return Future.value(true);
  }
}
