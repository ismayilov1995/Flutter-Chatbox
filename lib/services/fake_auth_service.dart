import 'package:flutter_chatbox/models/user_model.dart';
import 'package:flutter_chatbox/services/auth_base.dart';

class FakeAuthService implements AuthBase {
  String userID = "I7sm5a504y8I09l6";

  @override
  Future<AppUser> currentUser() async {
    return await Future.value(AppUser(userID: userID));
  }

  @override
  Future<AppUser> signInAnonymous() async {
    return await Future.delayed(
        Duration(seconds: 2), () => AppUser(userID: userID));
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    return await Future.delayed(
        Duration(seconds: 2), () => AppUser(userID: userID + "with google"));
  }

  @override
  Future<AppUser> signInWithFacebook() async {
    return await Future.delayed(
        Duration(seconds: 2), () => AppUser(userID: userID + "with facebook"));
  }

  @override
  Future<AppUser> signInWithEmail(String email, String password) {
    // TODO: implement signInWithEmail
    throw UnimplementedError();
  }

  @override
  Future<AppUser> createWithEmail(String email, String password) {
    // TODO: implement createWithEmail
    throw UnimplementedError();
  }
}
