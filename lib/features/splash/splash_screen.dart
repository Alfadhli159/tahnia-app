import 'package:flutter/material.dart';
import '../../core/widgets/auth_wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToAuthWrapper();
  }

  void _navigateToAuthWrapper() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AuthWrapper()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
        backgroundColor: Colors.white, // خلفية بيضاءلفية بيضاء
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo or app icon
              Icon(
                Icons.celebration,
                size: 80,
                color: Color(0xFF2196F3), // أزرق
              ),
              SizedBox(height: 20),
              Text(
                'تهنئة',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 48,
                  color: Color(0xFF2196F3), // أزرق
                  fontFamily: 'Tajawal',
                ),
              ),
              SizedBox(height: 10),
              Text(
                'تطبيق التهاني والمعايدات',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontFamily: 'Tajawal',
                ),
              ),
              SizedBox(height: 40),
              CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)), // أزرق
              ),
            ],
          ),
        ),
      );
}
