import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الصفحة الرئيسية'),
        ),
        body: const Center(
          child: Text('مرحبًا بك في تطبيق تهنئة!'),
        ),
      ),
    );
  }
}
