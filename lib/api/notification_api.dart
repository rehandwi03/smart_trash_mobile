import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_trash_mobile/main.dart';
import 'package:smart_trash_mobile/routes.dart';

class NotificationApi {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails('channel id', 'channel name',
          channelDescription: 'channel description',
          importance: Importance.max),
      iOS: DarwinNotificationDetails(),
    );
  }

  static void _onDidReceiveBackgroundNotificationResponse(details) {
    print(details);
    print("onDidReceiveBackgroundNotificationResponse");
  }

  static void _onDidReceiveNotificationResponse(NotificationResponse details) {
    print(details.payload);
    if (details.payload == "monitoring_almost_full") {
      Navigator.pushNamed(appContext!, Routes.garbageMonitor);
    }
  }

  static void initialize() {
    // Initialization  setting for android
    const InitializationSettings initializationSettingsAndroid =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );

    _notifications.initialize(
      initializationSettingsAndroid,
      onDidReceiveBackgroundNotificationResponse:
          _onDidReceiveBackgroundNotificationResponse,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
      );

  static Future<void> display(RemoteMessage message) async {
    print(message.data);
    // To display the notification in device
    try {
      print(message.notification!.android!.sound);
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            message.notification!.android!.sound ?? "Channel Id",
            message.notification!.android!.sound ?? "Main Channel",
            groupKey: "Smart Trash",
            color: Colors.green,
            importance: Importance.max,
            playSound: true,
            priority: Priority.high),
      );
      await _notifications.show(id, message.notification?.title,
          message.notification?.body, notificationDetails,
          payload: message.data['type']);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
