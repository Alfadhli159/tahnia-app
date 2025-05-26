// lib/main.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// استيراد الصفحات
import 'features/home/home_screen.dart';
import 'features/greetings/screens/send_greeting_screen.dart';
import 'features/greetings/screens/surprise_message_screen.dart';
import 'features/greetings/screens/schedule_greeting_screen.dart';
import 'features/greetings/screens/greeting_history_screen.dart';
import 'features/greetings/screens/greeting_templates_screen.dart';
import 'features/contacts/screens/groups_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('groupsBox');
  runApp(const TahniaApp());
}

class TahniaApp extends StatelessWidget {
  const TahniaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'تهنئة',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Tajawal',
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/sendGreeting': (_) => const SendGreetingScreen(),
        '/surpriseMessage': (_) => const SurpriseMessageScreen(),
        '/scheduleGreeting': (_) => const ScheduleGreetingScreen(),
        '/greetingHistory': (_) => const GreetingHistoryScreen(),
        '/greetingTemplates': (_) => const GreetingTemplatesScreen(),
        '/groups': (_) => const GroupsScreen(),
      },
    );
  }
}
