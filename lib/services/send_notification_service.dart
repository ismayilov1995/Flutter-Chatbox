import 'package:flutter_chatbox/models/message.dart';
import 'package:flutter_chatbox/models/user.dart';
import 'package:http/http.dart' as http;

class SendNotificationService{
  Future<bool> sendNotification(Message message, AppUser sender, String token){
    String endPoint = "https://fcm.googleapis.com/fcm/send";

  }
}