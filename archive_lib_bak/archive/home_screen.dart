import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("الرئيسية"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildServiceBox(
                context,
                icon: Icons.calendar_today,
                label: "جدولة تهنئة",
                onTap: () {},
              ),
              _buildServiceBox(
                context,
                icon: Icons.card_giftcard,
                label: "أرسل تهنئة",
                onTap: () {},
              ),
              _buildServiceBox(
                context,
                icon: Icons.group,
                label: "المجموعات",
                onTap: () {},
              ),
              _buildServiceBox(
                context,
                icon: Icons.auto_awesome,
                label: "فاجئني برسالة",
                onTap: () {},
              ),
              _buildServiceBox(
                context,
                icon: Icons.history,
                label: "سجل التهاني",
                onTap: () {},
              ),
              _buildServiceBox(
                context,
                icon: Icons.menu_book,
                label: "قوالب التهاني",
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceBox(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.teal[50],
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.teal),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
