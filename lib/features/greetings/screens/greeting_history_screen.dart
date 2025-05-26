// ✅ 4. سجل التهاني
// lib/features/greetings/screens/greeting_history_screen.dart
import 'package:flutter/material.dart';

class GreetingHistoryScreen extends StatelessWidget {
  const GreetingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('سجل التهاني ⏳')),
      body: const Center(
        child: Text('قائمة التهاني المرسلة / المجدولة تشمل التاريخ، المناسبة، المستلم، والحالة'),
      ),
    );
  }
}