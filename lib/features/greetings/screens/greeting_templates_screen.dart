// ✅ 6. قوالب التهاني
// lib/features/greetings/screens/greeting_templates_screen.dart
import 'package:flutter/material.dart';

class GreetingTemplatesScreen extends StatelessWidget {
  const GreetingTemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('قوالب التهاني 📖'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'الأعياد'),
              Tab(text: 'التخرج'),
              Tab(text: 'اجتماعية'),
              Tab(text: 'إسلامية'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('قوالب الأعياد')), 
            Center(child: Text('قوالب التخرج')),
            Center(child: Text('قوالب المناسبات الاجتماعية')),
            Center(child: Text('قوالب التهاني الإسلامية')),
          ],
        ),
      ),
    );
  }
}
