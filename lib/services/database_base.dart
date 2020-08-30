import 'package:flutter_chatbox/models/user.dart';

abstract class DbBase{
  Future<bool> saveUser(AppUser user);
  Future<AppUser> getUser(String userId);
}