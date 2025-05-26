import 'package:flutter/material.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> services = [
      {'icon': Icons.card_giftcard, 'title': 'أرسل تهنئة'},
      {'icon': Icons.schedule, 'title': 'جدولة تهنئة'},
      {'icon': Icons.auto_awesome, 'title': 'فاجئني برسالة'},
      {'icon': Icons.groups, 'title': 'المجموعات'},
      {'icon': Icons.menu_book, 'title': 'قوالب التهاني'},
      {'icon': Icons.history, 'title': 'سجل التهاني'},
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الخدمات'),
          backgroundColor: Colors.teal,
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  itemCount: services.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return GestureDetector(
                      onTap: () {
                        // TODO: تنفيذ التنقل للخدمة
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal[50],
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(service['icon'], size: 40, color: Colors.teal[700]),
                            const SizedBox(height: 12),
                            Text(
                              service['title'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.teal,
              unselectedItemColor: Colors.grey,
              currentIndex: 1, // Tab رقم 2 - الخدمات
              onTap: (index) {
                // TODO: التنقل بين التبويبات حسب AppRoutes
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
                BottomNavigationBarItem(icon: Icon(Icons.widgets), label: 'الخدمات'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'ملفي'),
                BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'الإحصائيات'),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'المزيد'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
