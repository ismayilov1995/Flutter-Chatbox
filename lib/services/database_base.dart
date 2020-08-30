import 'package:flutter_chatbox/models/user_model.dart';

abstract class DbBase{
  Future<bool> saveUser(AppUser user);
}