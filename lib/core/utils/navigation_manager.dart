import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class NavigationManager {
  static Future<T?> navigateTo<T>({
    required BuildContext context,
    required Widget screen,
    bool replace = false,
    bool clearStack = false,
  }) {
    if (clearStack) {
      return Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => screen),
        (route) => false,
      );
    } else if (replace) {
      return Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    }
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
        settings: const RouteSettings(name: 'screen'),
      ),
    );
  }

  static Future<T?> navigateWithFade<T>({
    required BuildContext context,
    required Widget screen,
    bool replace = false,
  }) {
    return Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: AppConstants.defaultAnimationDuration,
      ),
    );
  }

  static Future<T?> navigateWithSlide<T>({
    required BuildContext context,
    required Widget screen,
    bool replace = false,
  }) {
    return Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        transitionDuration: AppConstants.defaultAnimationDuration,
      ),
    );
  }

  static void pop(BuildContext context, [result]) {
    Navigator.pop(context, result);
  }

  static void popUntil(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }
}
