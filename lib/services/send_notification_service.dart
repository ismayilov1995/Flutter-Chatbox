import 'package:flutter_chatbox/models/message.dart';
import 'package:flutter_chatbox/models/user.dart';
import 'package:http/http.dart' as http;

class SendNotificationService {
  Future<bool> sendNotification(
      Message message, AppUser sender, String token) async {
    String endPoint = "https://fcm.googleapis.com/fcm/send";
    String _firebaseFCMKey =
        "AAAAG6USqb4:APA91bFkcEdEQFFIq7Do2y5---FmGcAADPO5QsTD4xa-gQ75OElhPwJySR2Q5VeqLOARAxG_NVu3sGwSVA22VCZE-4ZzAlq877C3uSErVNySBJwyrmMQ0FEEkb8sOIFKggZu1YOqvrsk";
    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "key=$_firebaseFCMKey"
    };
    String json =
        '{"to": "$token", "data": {"title": "${sender.username} - new message", "message": "${message.message}", "profileImg": "${sender.profileUrl}", "sender": "${sender.userID}", "username": "${sender.username}"}}';

    http.Response response =
        await http.post(endPoint, headers: header, body: json);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
