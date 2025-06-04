import 'package:flutter/material.dart';
import 'package:tahania_app/app/main_navigation_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام شريط التنقل الجديد مباشرة
    return const MainNavigationScreen();
  }
}
