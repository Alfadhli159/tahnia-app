import 'package:flutter/material.dart';
import 'package:tahania_app/features/splash/splash_screen.dart';
import 'package:tahania_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:tahania_app/features/auth/login_screen.dart';
import 'package:tahania_app/features/auth/register_screen.dart';
import 'package:tahania_app/features/auth/privacy_policy_screen.dart';
import 'package:tahania_app/features/home/home_screen.dart' as home_screen;
import 'package:tahania_app/features/greetings/presentation/screens/send_greeting_screen.dart';
import 'package:tahania_app/features/greetings/surprise_message_screen.dart';
import 'package:tahania_app/features/greetings/presentation/screens/templates_screen.dart';
import 'package:tahania_app/features/greetings/presentation/screens/scheduled_messages_screen.dart';
import 'package:tahania_app/features/auto_reply/presentation/screens/auto_reply_screen.dart';
import 'package:tahania_app/features/more/screens/official_messages_screen.dart';
import 'package:tahania_app/features/settings/presentation/screens/settings_screen.dart'
    as settings;

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String register = '/register';
  static const String login = '/login';
  static const String home = '/home';
  static const String privacy = '/privacy';
  static const String sendGreeting = '/send';
  static const String autoReply = '/autoreply';
  static const String officialMessages = '/official';
  static const String surprise = '/surprise';
  static const String templates = '/templates';
  static const String scheduled = '/scheduled';
  static const String settingsRoute = '/settings';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        onboarding: (context) => const OnboardingScreen(),
        register: (context) => const RegisterScreen(),
        login: (context) => const LoginScreen(),
        home: (context) => const home_screen.HomeScreen(),
        privacy: (context) => const PrivacyPolicyScreen(),
        sendGreeting: (context) => const SendGreetingScreen(),
        autoReply: (context) => const AutoReplyScreen(),
        officialMessages: (context) => const OfficialMessagesScreen(),
        surprise: (context) => const SurpriseMessageScreen(),
        templates: (context) => const TemplatesScreen(),
        scheduled: (context) => const ScheduledMessagesScreen(),
        settingsRoute: (context) => const settings.SettingsScreen(),
      };
}
