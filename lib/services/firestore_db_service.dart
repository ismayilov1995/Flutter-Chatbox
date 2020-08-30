import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chatbox/models/user.dart';
import 'package:flutter_chatbox/services/database_base.dart';

class FirestoreDbService implements DbBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(AppUser user) async {
    await _firestore.collection("users").doc(user.userID).set(user.toMap());
    return true;
  }

  @override
  Future<AppUser> getUser(String userId) async {
    DocumentSnapshot _userSnapshot =
        await _firestore.collection("users").doc(userId).get();
    return AppUser.mapFrom(_userSnapshot.data());
  }
}
