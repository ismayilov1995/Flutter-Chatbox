import 'package:flutter_chatbox/models/user_model.dart';

abstract class AuthBase {
  Future<AppUser> currentUser();
  Future<AppUser> signInAnonymous();
  Future<bool> signOut();
  Future<AppUser> signInWithGoogle();
  Future<AppUser> signInWithFacebook();
  Future<AppUser> signInWithEmail(String email, String password);
  Future<AppUser> createWithEmail(String email, String password);
}
