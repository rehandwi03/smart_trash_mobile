import 'package:flutter/material.dart';
import 'package:smart_trash_mobile/routes.dart';

class JwtMiddleware extends RouteObserver<PageRoute<dynamic>> {
  bool isTokenValid(String token) {
    return true;
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    // TODO: implement didPush
    super.didPush(route, previousRoute);

    if (route.settings.name == Routes.login) {
      return;
    }
  }
}