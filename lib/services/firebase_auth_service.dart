import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chatbox/models/user_model.dart';
import 'package:flutter_chatbox/services/auth_base.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<AppUser> currentUser() {
    try {
      User user = _firebaseAuth.currentUser;
      return Future.delayed(Duration.zero, () => _userFromFirebase(user));
    } catch (e) {
      print('XETA: $e');
      return null;
    }
  }

  AppUser _userFromFirebase(User user) {
    return user == null ? null : AppUser(userID: user.uid);
  }

  @override
  Future<AppUser> signInAnonymous() async {
    try {
      UserCredential result = await FirebaseAuth.instance.signInAnonymously();
      return _userFromFirebase(result.user);
    } catch (e) {
      print('XETA: $e');
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print('XETA: $e');
      return false;
    }
  }
}
