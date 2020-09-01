import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String owner;
  final String talk;
  final String lastMessage;
  final bool seen;
  final Timestamp createdAt;
  final Timestamp seenAt;
  String talkUsername;
  String talkProfilephoto;

  Chat(
      {this.owner,
      this.talk,
      this.lastMessage,
      this.seen,
      this.createdAt,
      this.seenAt});

  Map<String, dynamic> toMap() {
    return {
      'owner': owner,
      'talk': talk,
      'lastMessage': lastMessage,
      'seen': seen,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'seenAt': seenAt,
    };
  }

  Chat.fromMap(Map<String, dynamic> map)
      : owner = map['owner'],
        talk = map['talk'],
        lastMessage = map['lastMessage'],
        seen = map['seen'],
        createdAt = map['createdAt'],
        seenAt = map['seenAt'];

  @override
  String toString() {
    return 'Chat{owner: $owner, talk: $talk, lastMessage: $lastMessage, seen: $seen, createdAt: $createdAt, seenAt: $seenAt}';
  }
}
