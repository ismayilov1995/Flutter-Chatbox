import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chatbox/models/chat.dart';
import 'package:flutter_chatbox/models/message.dart';
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

  @override
  Future<List<Chat>> getConversations(String userID) async {
    List<Chat> conversations;
    QuerySnapshot _chatSnapshot = await _firestore
        .collection('chat')
        .where('owner', isEqualTo: userID)
        .orderBy('createdAt', descending: true)
        .get();
    conversations =
        _chatSnapshot.docs.map((e) => Chat.fromMap(e.data())).toList();
    return conversations;
  }

  @override
  Stream<List<Message>> getChatMessages(String senderID, String receiverID) {
    var _snap = _firestore
        .collection("chat")
        .doc(senderID + "--" + receiverID)
        .collection("messages")
        .orderBy("createdAt", descending: true)
        .snapshots();
    return _snap.map((messageList) =>
        messageList.docs.map((e) => Message.fromMap(e.data())).toList());
  }

  @override
  Future<bool> sendMessage(Message message) async {
    String _messageID = _firestore.collection("chat").doc().id;
    String _myDocId = message.from + '--' + message.to;
    String _receiverDocId = message.to + '--' + message.from;
    var _messageToMap = message.toMap();
    await _firestore
        .collection("chat")
        .doc(_myDocId)
        .collection("messages")
        .doc(_messageID)
        .set(_messageToMap);
    await _firestore.collection("chat").doc(_myDocId).set({
      "owner": message.from,
      "talk": message.to,
      "lastMessage": message.message,
      "seen": true,
      "createdAt": FieldValue.serverTimestamp()
    });
    _messageToMap.update('fromMe', (value) => false);
    await _firestore
        .collection("chat")
        .doc(_receiverDocId)
        .collection("messages")
        .doc(_messageID)
        .set(_messageToMap);
    await _firestore.collection("chat").doc(_receiverDocId).set({
      "owner": message.to,
      "talk": message.from,
      "lastMessage": message.message,
      "seen": false,
      "createdAt": FieldValue.serverTimestamp()
    });
    return true;
  }

  @override
  Future<DateTime> showTime(String userID) async {
    await _firestore.collection('utils').doc(userID).set({"time": FieldValue.serverTimestamp()});
    var timeMap = await _firestore.collection('utils').doc(userID).get();
    Timestamp time = timeMap.data()['time'];
    return time.toDate();
  }
}
