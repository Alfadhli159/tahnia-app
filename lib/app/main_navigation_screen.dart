import 'package:flutter/material.dart';

import '../features/greetings/screens/schedule_greeting_screen.dart';
// إذا لم توجد هذه الملفات، علّق الاستيراد ولا تستخدمها
// import '../features/settings/settings_screen.dart'; // غير موجود فعليًا الآن

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    Placeholder(), // الرد التلقائي
    ScheduleGreetingScreen(), // الجدولة (متوفرة حسب الصورة)
    Placeholder(), // السجل
    Placeholder(), // القوالب
    Placeholder(), // الإعدادات
  ];

  final List<String> _labels = [
    'الرد التلقائي',
    'الجدولة',
    'السجل',
    'القوالب',
    'الإعدادات',
  ];

  final List<IconData> _icons = [
    Icons.smart_toy_outlined,
    Icons.calendar_today,
    Icons.history,
    Icons.view_module,
    Icons.settings,
  ];

  @override
  Widget build(BuildContext context) => Directionality(
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
