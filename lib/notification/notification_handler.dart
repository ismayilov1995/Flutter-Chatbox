import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatbox/app/chat_page.dart';
import 'package:flutter_chatbox/models/user.dart';
import 'package:flutter_chatbox/viewmodel/chat_viewmodel.dart';
import 'package:flutter_chatbox/viewmodel/user_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    print('bg ya noti geldi');
    NotificationHandler.showNotification(message);
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

  BuildContext _context;

  initFCMNotification(BuildContext context) async {
    _context = context;
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: onDidReceiveNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _fcm.subscribeToTopic("all");
    // String token = await _fcm.getToken();

    _fcm.onTokenRefresh.listen((newToken) async {
      User _currentUser = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .doc("tokens/" + _currentUser.uid)
          .set({"token": newToken});
    });

    _fcm.configure(
      onBackgroundMessage: myBackgroundMessageHandler,
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showNotification(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  static void showNotification(Map<String, dynamic> message) async {
    try {
      // var userURLPath = await _downloadAndSaveImage(
      //     message['data']['profileImg'], 'largeIcon');
      var me = Person(
        name: message['data']['title'],
        key: '1',
        // icon: BitmapFilePathAndroidIcon(userURLPath),
      );
      var msgStyle = MessagingStyleInformation(me,
          messages: [Message(message['data']["message"], DateTime.now(), me)]);

      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          '1234', 'New message', 'yeni mesajlar barede',
          styleInformation: msgStyle,
          importance: Importance.Max,
          priority: Priority.High,
          ticker: 'ticker');
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(0, message['data']['title'],
          message['data']['message'], platformChannelSpecifics,
          payload: jsonEncode(message));
    } catch (e) {
      print("Error: " + e.toString());
    }
  }

  Future onSelectNotification(String payload) async {
    final _userVM = Provider.of<UserViewmodel>(_context, listen: false);
    if (payload != null) {
      Map<String, dynamic> payloadNotification = await jsonDecode(payload);
      Navigator.of(_context, rootNavigator: true).push(CupertinoPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (context) => ChatViewmodel(
                  sender: _userVM.user,
                  receiver: AppUser.idAndImage(
                      userID: payloadNotification['data']['sender'],
                      username: payloadNotification['data']['username'],
                      profileUrl: payloadNotification['data']['profileImg'])),
              child: ChatPage())));
    }
  }

  Future onDidReceiveNotification(
      int id, String title, String body, String payload) async {}

  static _downloadAndSaveImage(String url, String name) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$name';
    var response = await http.get(url);
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}
