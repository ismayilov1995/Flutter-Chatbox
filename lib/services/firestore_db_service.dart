import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chatbox/models/user_model.dart';
import 'package:flutter_chatbox/services/database_base.dart';

class FirestoreDbService implements DbBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(AppUser user) async {

    Map _addedUserMap = user.toMap();
    _addedUserMap['createdAt'] = FieldValue.serverTimestamp();
    _addedUserMap['updatedAt'] = FieldValue.serverTimestamp();

    await _firestore.collection("users").doc(user.userID).set(_addedUserMap);
    DocumentSnapshot _fetchUser = await FirebaseFirestore.instance.doc("users/${user.userID}").get();
    print(_fetchUser.data());
    return true;
  }
}
