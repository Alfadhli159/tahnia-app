import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // ✅ أضف هذا
import 'app/app_routes.dart';
import 'config/theme/app_theme.dart';
import 'core/services/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ ضروري قبل تهيئة Firebase
  await Firebase.initializeApp(); // ✅ تهيئة Firebase

  runApp(const TahniaApp());
}

class TahniaApp extends StatelessWidget {
  const TahniaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق تهنئة',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      navigatorKey: NavigationService.navigatorKey,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
