import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_chatbox/common_widget/responsive_alertdialog.dart';

Future<void> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    final dynamic data = message['data'];
    print(data.toString() + 'dddddddddddddddddddddd');
  }
  return Future<void>.value();
}

class NotificationHandler {
  FirebaseMessaging _fcm = FirebaseMessaging();

  // Using locator
  // NotificationHandler._internal();
  //
  // static final NotificationHandler _singleton = NotificationHandler._internal();
  //
  // factory NotificationHandler() {
  //   return _singleton;
  // }

  initFCMNotification(BuildContext context) async {
    _fcm.subscribeToTopic("all");
    _fcm.configure(
      onBackgroundMessage: myBackgroundMessageHandler,
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        ResponsiveAlertDialog(
          title: "Test",
          content: "Testis",
          allowBtn: "Ok",
        ).show(context);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }
}
