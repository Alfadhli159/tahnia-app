import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo(String routeName, {Object? arguments}) => navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);

  static void goBack() => navigatorKey.currentState!.pop();
}
