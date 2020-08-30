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

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'username': username ?? '',
      'profileUrl': profileUrl ?? '',
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
}
