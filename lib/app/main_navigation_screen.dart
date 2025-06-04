import 'package:flutter/material.dart';
import 'package:tahania_app/features/greetings/presentation/screens/smart_message_screen.dart';
import 'package:tahania_app/features/more/screens/official_messages_screen.dart';
import 'package:tahania_app/features/auto_reply/presentation/screens/auto_reply_screen.dart';
import 'package:tahania_app/features/greetings/presentation/screens/scheduled_messages_screen.dart';
import 'package:tahania_app/features/greetings/presentation/screens/templates_screen.dart';
import 'package:tahania_app/features/settings/presentation/screens/settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const SmartMessageScreen(),
    const OfficialMessagesScreen(),
    const AutoReplyScreen(),
    const ScheduledMessagesScreen(),
    const TemplatesScreen(),
    const SettingsScreen(),
  ];

  final List<BottomNavigationBarItem> _navItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.smart_toy),
      label: 'رسائل ذكية',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.business),
      label: 'رسائل رسمية',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.auto_awesome),
      label: 'رد تلقائي',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.schedule),
      label: 'رسائل مجدولة',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.description),
      label: 'قوالب',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'الإعدادات',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _navItems,
      ),
    );
  }
}
