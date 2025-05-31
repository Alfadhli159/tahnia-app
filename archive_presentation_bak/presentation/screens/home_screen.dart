import 'package:flutter/material.dart';
import 'package:tahania_app/screens/send_greeting_screen.dart';
import 'package:tahania_app/screens/official_messages_screen.dart';
// تم تعليق هذا الاستيراد تلقائياً: import 'package:tahania_app/screens/auto_reply_screen.dart';
import 'package:tahania_app/config/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تهانينا'),
        centerTitle: true,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildMenuCard(
            context,
            title: 'إرسال تهنئة',
            icon: Icons.send,
            color: theme.primaryColor,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SendGreetingScreen(),
                ),
              );
            },
          ),
          _buildMenuCard(
            context,
            title: 'الردود التلقائية',
            icon: Icons.reply_all,
            color: Colors.purple,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AutoReplyScreen(),
                ),
              );
            },
          ),
          _buildMenuCard(
            context,
            title: 'الرسائل التوعوية',
            icon: Icons.campaign,
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OfficialMessagesScreen(),
                ),
              );
            },
          ),
          _buildMenuCard(
            context,
            title: 'التهاني المفضلة',
            icon: Icons.favorite,
            color: Colors.red,
            onTap: () {
              // عرض التهاني المفضلة
            },
          ),
          _buildMenuCard(
            context,
            title: 'الإعدادات',
            icon: Icons.settings,
            color: Colors.orange,
            onTap: () {
              // عرض الإعدادات
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 