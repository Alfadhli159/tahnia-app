import 'package:flutter/material.dart';

import 'app/app_routes.dart';
import 'config/theme/app_theme.dart';
import 'core/services/navigation_service.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase using our service
  await FirebaseService.initialize();

  runApp(const TahniaApp());
}

class TahniaApp extends StatelessWidget {
  const TahniaApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'تطبيق تهنئة',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      navigatorKey: NavigationService.navigatorKey,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
}