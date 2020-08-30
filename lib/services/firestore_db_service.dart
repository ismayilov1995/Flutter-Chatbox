import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chatbox/models/user.dart';
import 'package:flutter_chatbox/services/database_base.dart';

class FirestoreDbService implements DbBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(AppUser user) async {
    await _firestore.collection("users").doc(user.userID).set(user.toMap());
    // DocumentSnapshot _fetchUser = await FirebaseFirestore.instance.doc("users/${user.userID}").get();
    // AppUser _pox = AppUser.mapFrom(_fetchUser.data());
    // print(_pox.toString());
    return true;
  }
}
