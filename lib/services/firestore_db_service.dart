import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chatbox/models/user_model.dart';
import 'package:flutter_chatbox/services/database_base.dart';

class FirestoreDbService implements DbBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(AppUser user) async {
    print(user.userID);
    await _firestore.collection("users").doc(user.userID).set(user.toMap());
    return true;
  }
}
