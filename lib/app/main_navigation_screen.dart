// النسخة المرتبطة بشريط التنقل السفلي BottomNavigationBar
import 'package:flutter/material.dart';
import 'package:tahania_app/features/greetings/presentation/screens/send_greeting_screen.dart';
import 'package:tahania_app/features/auto_reply/presentation/screens/auto_reply_screen.dart';
import 'package:tahania_app/features/more/screens/official_messages_screen.dart';
import 'package:tahania_app/features/greetings/surprise_message_screen.dart';
import 'package:tahania_app/features/greetings/presentation/screens/templates_screen.dart';
import 'package:tahania_app/features/greetings/presentation/screens/scheduled_messages_screen.dart';
import 'package:tahania_app/features/settings/presentation/screens/settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    SendGreetingScreen(), // 1- إرسال الرسالة
    OfficialMessagesScreen(), // 2- الرسالة المصنفة
    AutoReplyScreen(), // 3- الرد التلقائي
    SurpriseMessageScreen(), // 4- فاجئني برسالة
    TemplatesScreen(), // 5- القوالب
    ScheduledMessagesScreen(), // 6- جدولة
    SettingsScreen(), // 7- الإعدادات
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.send), label: 'أرسل'),
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: 'مصنفة'),
          BottomNavigationBarItem(icon: Icon(Icons.reply_all), label: 'الرد'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: 'فاجئني'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'القوالب'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'الجدولة'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'الإعدادات'),
        ],
      ),
    );
  }
}
