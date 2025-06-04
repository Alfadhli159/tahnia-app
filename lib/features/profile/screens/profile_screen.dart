import 'package:flutter/material.dart';
import '../../auth/privacy_policy_screen.dart';
import '../../more/screens/about_screen.dart';
import '../../more/screens/support_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) => Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المزيد'),
          backgroundColor: Colors.teal,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildOption(context, Icons.privacy_tip, 'سياسة الخصوصية', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
              );
            }),
            _buildOption(context, Icons.description, 'شروط الاستخدام', () {
              // TODO: تنفيذ شاشة الشروط لاحقًا
            }),
            _buildOption(context, Icons.info, 'حول التطبيق', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            }),
            _buildOption(context, Icons.support_agent, 'الدعم والمساعدة', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SupportScreen()),
              );
            }),
          ],
        ),
      ),
    );

  Widget _buildOption(BuildContext context, IconData icon, String title, VoidCallback onTap) => Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
}
