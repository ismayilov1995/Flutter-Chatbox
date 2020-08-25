import 'package:flutter_chatbox/models/user_model.dart';
import 'package:flutter_chatbox/services/auth_base.dart';

class FirebaseAuthService implements AuthBase {
  @override
  Future<AppUser> currentUser() {
    throw UnimplementedError();
  }

  @override
  Future<AppUser> signInAnonymous() {
    throw UnimplementedError();
  }

  @override
  Future<bool> signOut() {
    throw UnimplementedError();
  }
}
