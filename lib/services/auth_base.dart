import 'package:flutter_chatbox/models/user_model.dart';

abstract class AuthBase {
  Future<AppUser> currentUser();
  Future<AppUser> signInAnonymous();
  Future<bool> signOut();
}
