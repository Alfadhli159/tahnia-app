import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tahania_app/features/greetings/presentation/screens/smart_message_screen.dart';
import 'package:tahania_app/features/more/screens/official_messages_screen.dart';
import 'package:tahania_app/features/auto_reply/presentation/screens/auto_reply_screen.dart';
import 'package:tahania_app/features/greetings/presentation/screens/scheduled_messages_screen.dart';
import 'package:tahania_app/features/greetings/presentation/screens/templates_screen.dart';
import 'package:tahania_app/features/settings/presentation/screens/settings_screen.dart';

class EnhancedNavigationScreen extends StatefulWidget {
  const EnhancedNavigationScreen({super.key});

  @override
  State<EnhancedNavigationScreen> createState() =>
      _EnhancedNavigationScreenState();
}

class _EnhancedNavigationScreenState extends State<EnhancedNavigationScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _animationController;

  final List<Widget> _screens = [
    const SmartMessageScreen(), // 1- الذكية
    const OfficialMessagesScreen(), // 2- المصنفة
    const AutoReplyScreen(), // 3- الرد التلقائي
    const ScheduledMessagesScreen(), // 4- المجدولة
    const TemplatesScreen(), // 5- القالب
    const SettingsScreen(), // 6- الإعدادات
  ];

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.message,
      activeIcon: Icons.message,
      label: 'الذكية',
      color: const Color(0xFF4CAF50),
    ),
    NavigationItem(
      icon: Icons.table_chart,
      activeIcon: Icons.table_chart,
      label: 'المصنفة',
      color: const Color(0xFF2196F3),
    ),
    NavigationItem(
      icon: Icons.smart_toy,
      activeIcon: Icons.smart_toy,
      label: 'الرد التلقائي',
      color: const Color(0xFF9C27B0),
    ),
    NavigationItem(
      icon: Icons.schedule,
      activeIcon: Icons.schedule,
      label: 'المجدولة',
      color: const Color(0xFFFF9800),
    ),
    NavigationItem(
      icon: Icons.article,
      activeIcon: Icons.article,
      label: 'القالب',
      color: const Color(0xFF607D8B),
    ),
    NavigationItem(
      icon: Icons.settings,
      activeIcon: Icons.settings,
      label: 'الإعدادات',
      color: const Color(0xFF795548),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });

      // تأثير اهتزاز خفيف
      HapticFeedback.selectionClick();

      // انتقال سلس بين الصفحات
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      // تأثير حركي للأيقونة
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: _navigationItems[_currentIndex].color,
            unselectedItemColor: Colors.grey[400],
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 10,
            ),
            elevation: 0,
            items: _navigationItems.asMap().entries.map((entry) {
              int index = entry.key;
              NavigationItem item = entry.value;
              bool isSelected = _currentIndex == index;

              return BottomNavigationBarItem(
                icon: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(isSelected ? 8 : 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? item.color.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    item.icon,
                    size: isSelected ? 26 : 22,
                  ),
                ),
                activeIcon: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + (_animationController.value * 0.1),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: item.color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          item.activeIcon,
                          size: 26,
                          color: item.color,
                        ),
                      ),
                    );
                  },
                ),
                label: item.label,
              );
            }).toList(),
          ),
        ),
      ),
    );
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Color color;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.color,
  });
}
