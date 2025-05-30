import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../features/greetings/screens/enhanced_send_greeting_screen.dart';
import '../features/greetings/screens/surprise_message_screen.dart';
import '../features/auto_reply/auto_reply_screen.dart';
import '../features/greetings/screens/schedule_greeting_screen.dart';
import '../features/greetings/screens/greeting_history_screen.dart';
import '../features/greetings/screens/greeting_templates_screen.dart';
import '../features/settings/settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    EnhancedSendGreetingScreen(),
    SurpriseMessageScreen(),
    AutoReplyScreen(),
    ScheduleGreetingScreen(),
    GreetingHistoryScreen(),
    GreetingTemplatesScreen(),
    SettingsScreen(),
  ];

  final List<String> _labels = [
    'إرسال رسالة',
    'فاجئني',
    'الرد التلقائي',
    'الجدولة',
    'السجل',
    'القوالب',
    'الإعدادات',
  ];

  final List<IconData> _icons = [
    Icons.send,
    Icons.auto_awesome,
    Icons.smart_toy_outlined,
    Icons.calendar_today,
    Icons.history,
    Icons.view_module,
    Icons.settings,
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: List.generate(_labels.length, (index) {
            return BottomNavigationBarItem(
              icon: Icon(_icons[index]),
              label: _labels[index],
            );
          }),
        ),
      ),
    );
  }
}
