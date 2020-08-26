import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chatbox/models/user_model.dart';
import 'package:flutter_chatbox/services/auth_base.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print('XETA: $e');
      return false;
    }
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
      if (_googleUser != null) {
        GoogleSignInAuthentication _googleAuth =
            await _googleUser.authentication;
        if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
          UserCredential result = await _firebaseAuth.signInWithCredential(
              GoogleAuthProvider.credential(
                  idToken: _googleAuth.idToken,
                  accessToken: _googleAuth.accessToken));
          User _user = result.user;
          return _userFromFirebase(_user);
        }
      }
      return null;
    } catch (e) {
      print("Xeta fs: $e");
      return null;
    }
  }
}
