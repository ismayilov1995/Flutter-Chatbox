import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppUser {
  final String userID;
  String email;
  String username;
  String profileUrl;
  DateTime createdAt;
  DateTime updatedAt;
  int level;

  AppUser({@required this.userID, @required this.email});

  AppUser.idAndImage(
      {@required this.userID,
      @required this.username,
      @required this.profileUrl});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'username': username ??
          email.substring(0, email.indexOf('@')) + createRandomNumb(),
      'profileUrl': profileUrl ?? 'https://ramcotubular.com/wp-content/uploads/default-avatar.jpg',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'level': level ?? 1,
    };
  }

  AppUser.mapFrom(Map<String, dynamic> map)
      : userID = map['userID'],
        this.email = map['email'],
        username = map['username'],
        profileUrl = map['profileUrl'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        updatedAt = (map['updatedAt'] as Timestamp).toDate(),
        level = map['level'];

  @override
  String toString() {
    return 'AppUser{userID: $userID, email: $email, username: $username, profileUrl: $profileUrl, createdAt: $createdAt, updatedAt: $updatedAt, level: $level}';
  }

  String createRandomNumb() {
    int random = Random().nextInt(7090698);
    return random.toString();
  }
}
