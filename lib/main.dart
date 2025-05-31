// lib/main.dart - نسخة بسيطة تعمل بدون أخطاء

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
// استيراد الصفحات بالمسارات الجديدة
import 'app/navigation/main_navigation_screen.dart';
import 'features/greetings/presentation/screens/send_greeting_screen.dart';
import 'features/greetings/presentation/screens/surprise_message_screen.dart';
import 'features/greetings/presentation/screens/schedule_greeting_screen.dart';
import 'features/greetings/presentation/screens/greeting_history_screen.dart';
import 'features/greetings/presentation/screens/greeting_templates_screen.dart';
import 'features/contacts/presentation/screens/groups_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Hive.initFlutter();
    await Hive.openBox('groupsBox');
  } catch (e) {
    print('خطأ في تهيئة Hive: $e');
  }
  
  runApp(const TahniaApp());
}

class TahniaApp extends StatelessWidget {
  const TahniaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'تطبيق تهنئة',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Cairo',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تطبيق تهنئة'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.celebration,
                size: 100,
                color: Colors.teal,
              ),
              SizedBox(height: 20),
              Text(
                'مرحباً بك في تطبيق تهنئة',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'التطبيق جاهز للعمل!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('التطبيق يعمل بنجاح!'),
                backgroundColor: Colors.green,
              ),
            );
          },
          backgroundColor: Colors.teal,
          child: const Icon(Icons.check, color: Colors.white),
        ),
      ),
    );
  }
}