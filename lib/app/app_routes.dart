import 'package:flutter/material.dart';
import 'package:tahania_app/features/splash/splash_screen.dart';
import 'package:tahania_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:tahania_app/features/auth/login_screen.dart';
import 'package:tahania_app/features/auth/register_screen.dart';
import 'package:tahania_app/features/auth/privacy_policy_screen.dart';
import 'package:tahania_app/features/home/home_screen.dart';
import 'package:tahania_app/features/greetings/presentation/screens/send_greeting_screen.dart';
import 'package:tahania_app/features/auto_reply/presentation/screens/auto_reply_screen.dart';
import 'package:tahania_app/features/more/screens/official_messages_screen.dart';
import 'package:tahania_app/features/home/favorites_screen.dart';
import 'package:tahania_app/features/home/settings_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const register = '/register';
  static const login = '/login';
  static const home = '/home';
  static const privacy = '/privacy';
  static const sendGreeting = '/send';
  static const autoReply = '/autoreply';
  static const officialMessages = '/official';
  static const favorites = '/favorites';
  static const settings = '/settings';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        onboarding: (context) => const OnboardingScreen(),
        register: (context) => const RegisterScreen(),
        login: (context) => const LoginScreen(),
        home: (context) => const HomeScreen(),
        privacy: (context) => const PrivacyPolicyScreen(),
        sendGreeting: (context) => const SendGreetingScreen(),
        autoReply: (context) => const AutoReplyScreen(),
        officialMessages: (context) => const OfficialMessagesScreen(),
        favorites: (context) => const FavoritesScreen(),
        settings: (context) => const SettingsScreen(),
      };
}
