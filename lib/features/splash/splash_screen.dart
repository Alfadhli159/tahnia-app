import 'package:flutter/material.dart';
import '../../app/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
    });// لتعديل مدة الانتظار حسب الحاجةلشاشة العرض رقم 1 الترحيبية
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', width: 120),
              const SizedBox(height: 32),
              Text(
                "تـهـنـئـة",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                "شارك الفرح تلقائيًا مع أحبّتك!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF18816A), // أخضر غامق واضح
                  shadows: [
                    Shadow(
                        blurRadius: 1.5,
                        color: Colors.black12,
                        offset: Offset(1, 1))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
