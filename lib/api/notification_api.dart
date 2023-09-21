import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_trash_mobile/main.dart';
import 'package:smart_trash_mobile/presentation/screens/garbage_monitor.dart';
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
    // if (details.payload == "monitoring_almost_full") {
    //   Navigator.pushNamed(appContext!, Routes.garbageMonitor);
    // }
  }

  Future<void> _firebaseMessagingForegroundHandler(
      RemoteMessage message) async {
    print("Title dari init: ${message.notification?.title}");
    print("Body dari init: ${message.notification?.body}");
    print("Payload dari init: ${message.data}");

    if (message.notification != null) {
      print("hahaha");
      NotificationApi.display(message);
    }
  }

  void firebaseInit(BuildContext context) {
    // FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);
    FirebaseMessaging.onMessage.listen((message) {
      print("Title dari init: ${message.notification?.title}");
      print("Body dari init: ${message.notification?.body}");
      print("Payload dari init: ${message.data}");
      initLocalNotifications(context, message);
      NotificationApi.display(message);
    });
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

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _notifications.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
      // handle interaction when app is active for android
      handleMessage(context, message);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'monitoring_full') {
      print("uhuy");
      // Navigator.pushNamed(context, Routes.userSetting);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GarbageMonitorScreen(),
          ));
    }
  }

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
