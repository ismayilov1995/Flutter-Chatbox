import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chatbox/models/user.dart';
import 'package:flutter_chatbox/services/auth_base.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<AppUser> currentUser() {
    User user = _firebaseAuth.currentUser;
    return Future.delayed(Duration.zero, () => _userFromFirebase(user));
  }

  AppUser _userFromFirebase(User user) {
    return user == null ? null : AppUser(userID: user.uid, email: user.email);
  }

  @override
  Future<AppUser> signInAnonymous() async {
    UserCredential result = await FirebaseAuth.instance.signInAnonymously();
    return _userFromFirebase(result.user);
  }

  @override
  Future<bool> signOut() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final _facebookLogin = FacebookLogin();

    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    await _facebookLogin.logOut();
    return true;
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
    if (_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
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
  }

  @override
  Future<AppUser> signInWithFacebook() async {
    final _facebookLogin = FacebookLogin();
    FacebookLoginResult _faceRes =
        await _facebookLogin.logIn(['public_profile', 'email']);
    switch (_faceRes.status) {
      case FacebookLoginStatus.loggedIn:
        print("Logged in");
        UserCredential _firebaseRes = await _firebaseAuth.signInWithCredential(
            FacebookAuthProvider.credential(_faceRes.accessToken.token));
        User _user = _firebaseRes.user;
        return _userFromFirebase(_user);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("Canceled by user");
        break;
      case FacebookLoginStatus.error:
        print("Xeta: " + _faceRes.errorMessage);
        break;
    }
    return null;
  }

  @override
  Future<AppUser> signInWithEmail(String email, String password) async {
    UserCredential result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(result.user);
  }

  @override
  Future<AppUser> createWithEmail(String email, String password) async {
    UserCredential result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(result.user);
  }
}
