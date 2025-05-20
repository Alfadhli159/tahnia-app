import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app/theme.dart';
import 'features/splash/splash_screen.dart';
import 'features/home/home_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/auth/register_screen.dart';         // صفحة التسجيل
import 'features/auth/privacy_policy_screen.dart';   // صفحة سياسة الخصوصية
import 'features/auth/otp_verification_screen.dart'; // صفحة التحقق OTP
import 'app/app_routes.dart';

void main() {
  runApp(const TahniaApp());
}

class TahniaApp extends StatelessWidget {
  const TahniaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق تهنئة',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.onboarding: (_) => const OnboardingScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        AppRoutes.privacy: (_) => const PrivacyPolicyScreen(),
        // ملاحظة: صفحة OTP يتم استدعاؤها عبر MaterialPageRoute لنقل رقم الجوال معها
        // AppRoutes.otp: (_) => OtpVerificationScreen(phone: ''), // إن أردت تعريفها ضمن routes
      },
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}

