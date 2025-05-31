import 'package:flutter/material.dart';
import 'package:tahania_app/features/auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF7EEE3),
      body: Center(
        child: Text(
          'تهنئة',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 48,
            fontFamily: 'Tajawal', // أو الخط الافتراضي لديك
          ),
        ),
      ),
    );
  }
}
