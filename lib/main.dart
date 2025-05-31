import 'package:flutter/material.dart';
import 'app/theme.dart'; // أو عدل للمسار الصحيح
import 'core/services/navigation_service.dart';
import 'app/app_routes.dart'; // حسب بنية المشروع

void main() {
  runApp(const TahniaApp());
}

class TahniaApp extends StatelessWidget {
  const TahniaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahnia App',
      theme: AppTheme.lightTheme, // عدل اسم AppTheme للمكان المناسب
      navigatorKey: NavigationService.navigatorKey,
      // home: MainNavigationScreen(), // أو أي صفحة البداية
      initialRoute: AppRoutes.initial,
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
