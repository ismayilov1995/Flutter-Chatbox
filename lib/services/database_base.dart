import 'package:flutter_chatbox/models/message.dart';
import 'package:flutter_chatbox/models/user.dart';

abstract class DbBase {
  Future<bool> saveUser(AppUser user);

  Future<AppUser> getUser(String userId);

  Future<List<AppUser>> getUsers();

  Future<bool> updateUsername(String userID, String username);

  Future<bool> updateProfilePhoto(String userID, String photoUrl);

  Stream<List<Message>> getChatMessages(String senderID, String receiverID);

  Future<bool> sendMessage(Message message) {}
}
