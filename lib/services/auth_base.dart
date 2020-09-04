import 'package:flutter_chatbox/models/user.dart';

abstract class AuthBase {
  Future<AppUser> currentUser();
  Future<AppUser> signInAnonymous();
  Future<bool> signOut(String userID);
  Future<AppUser> signInWithGoogle();
  Future<AppUser> signInWithFacebook();
  Future<AppUser> signInWithEmail(String email, String password);
  Future<AppUser> createWithEmail(String email, String password);
}
