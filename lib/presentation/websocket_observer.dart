import 'package:flutter/material.dart';
import 'package:smart_trash_mobile/utils/network/websocket.dart';

class WebSocketNavigatorObserver extends NavigatorObserver {
  final WebSocketService webSocketService;

  WebSocketNavigatorObserver({required this.webSocketService});

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      webSocketService.disconnect();
    }
  }
}
