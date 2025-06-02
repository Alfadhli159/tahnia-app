import 'package:flutter/material.dart';
import 'package:tahania_app/features/splash/splash_screen.dart';
import 'package:tahania_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:tahania_app/features/auth/login_screen.dart';
import 'package:tahania_app/features/auth/register_screen.dart';
import 'package:tahania_app/features/auth/privacy_policy_screen.dart';
import 'package:tahania_app/features/home/home_screen.dart';
// أضف باقي الشاشات حسب الحاجة

class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const register = '/register';
  static const login = '/login';
  static const home = '/home';
  static const privacy = '/privacy';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        onboarding: (context) => const OnboardingScreen(),
        register: (context) => const RegisterScreen(),
        login: (context) => const LoginScreen(),
        home: (context) => const HomeScreen(),
        privacy: (context) => const PrivacyPolicyScreen(),
        // أضف باقي الشاشات هنا...
      };
}
