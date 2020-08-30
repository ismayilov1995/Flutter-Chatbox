import 'package:flutter/material.dart';

class AppUser {
  final String userID;

  AppUser({@required this.userID});

  Map<String, dynamic> toMap() {
    return {'userID': userID};
  }
}
