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
      'createdAt': createdAt ?? '',
      'updatedAt': updatedAt ?? '',
      'level': level ?? 1,
    };
  }

}
