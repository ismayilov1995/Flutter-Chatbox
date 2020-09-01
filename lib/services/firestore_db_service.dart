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
  Future<AppUser> getUser(String userID) async {
    DocumentSnapshot _userSnapshot =
        await _firestore.collection("users").doc(userID).get();
    return AppUser.mapFrom(_userSnapshot.data());
  }

  @override
  Future<bool> updateUsername(String userID, String username) async {
    QuerySnapshot _userSnapshot = await _firestore
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
    if (_userSnapshot.docs.length > 0) {
      return false;
    } else {
      await _firestore
          .collection("users")
          .doc(userID)
          .update({"username": username});
      return true;
    }
  }

  Future<bool> updateProfilePhoto(String userID, String photoUrl) async {
    await _firestore
        .collection("users")
        .doc(userID)
        .update({"profileUrl": photoUrl});
    return true;
  }

  @override
  Future<List<AppUser>> getUsers() async {
    List<AppUser> users = List<AppUser>();
    QuerySnapshot usersSnapshot = await _firestore.collection("users").get();
    // Method 1
      // for (DocumentSnapshot user in usersSnapshot.docs) {
      //   users.add(AppUser.mapFrom(user.data()));
      // }
    // Method 2
    users = usersSnapshot.docs.map((e) => AppUser.mapFrom(e.data())).toList();
    return users;
  }
}
