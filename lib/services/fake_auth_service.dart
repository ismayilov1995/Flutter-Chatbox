import 'package:flutter_chatbox/models/user_model.dart';
import 'package:flutter_chatbox/services/auth_base.dart';

class FakeAuthService implements AuthBase {
  @override
  Future<AppUser> currentUser() {
    // TODO: implement currentUser
    throw UnimplementedError();
  }

  @override
  Future<AppUser> signInAnonymous() {
    // TODO: implement signInAnonymous
    throw UnimplementedError();
  }

  @override
  Future<bool> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
