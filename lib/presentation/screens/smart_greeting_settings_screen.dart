import 'package:flutter/material.dart';
import 'package:tahania_app/services/greeting_cost_manager.dart';
import 'package:tahania_app/widgets/animated_card.dart';
import 'package:tahania_app/widgets/animated_button.dart';
import 'package:tahania_app/config/theme/app_theme.dart';

class SmartGreetingSettingsScreen extends StatefulWidget {
  const SmartGreetingSettingsScreen({Key? key}) : super(key: key);

  @override
  State<SmartGreetingSettingsScreen> createState() => _SmartGreetingSettingsScreenState();
}

class _SmartGreetingSettingsScreenState extends State<SmartGreetingSettingsScreen> {
  bool _useAI = true;
  bool _useCache = true;
  Map<String, dynamic> _stats = {};

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadStats();
  }

  Future<void> _loadSettings() async {
    // هنا يمكن تحميل الإعدادات من SharedPreferences
    setState(() {
      _useAI = true;
      _useCache = true;
    });
  }

  Future<void> _loadStats() async {
    final stats = GreetingCostManager.getStats();
    setState(() {
      _stats = stats;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات التهاني الذكية'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // إحصائيات الاستخدام
            AnimatedCard(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إحصائيات الاستخدام',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16.0),
                    _buildStatItem(
                      'إجمالي الطلبات',
                      _stats['usage']?['total_requests']?.toString() ?? '0',
                    ),
                    _buildStatItem(
                      'طلبات المنطق المحلي',
                      _stats['usage']?['local']?.toString() ?? '0',
                    ),
                    _buildStatItem(
                      'طلبات الذكاء الاصطناعي',
                      _stats['usage']?['ai']?.toString() ?? '0',
                    ),
                    _buildStatItem(
                      'نسبة نجاح التخزين المؤقت',
                      '${_stats['cache_hit_rate']?.toStringAsFixed(1) ?? '0'}%',
                    ),
                    _buildStatItem(
                      'التكلفة الإجمالية',
                      '\$${_stats['cost']?.toStringAsFixed(2) ?? '0.00'}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // إعدادات التهاني
            AnimatedCard(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إعدادات التهاني',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16.0),
                    SwitchListTile(
                      title: const Text('استخدام الذكاء الاصطناعي'),
                      subtitle: const Text(
                        'استخدام الذكاء الاصطناعي لتوليد تهاني مخصصة',
                      ),
                      value: _useAI,
                      onChanged: (value) {
                        setState(() {
                          _useAI = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: const Text('التخزين المؤقت'),
                      subtitle: const Text(
                        'تخزين التهاني السابقة لتسريع الاستجابة',
                      ),
                      value: _useCache,
                      onChanged: (value) {
                        setState(() {
                          _useCache = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // زر تحديث الإحصائيات
            AnimatedButton(
              onPressed: _loadStats,
              text: 'تحديث الإحصائيات',
              icon: Icons.refresh,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
} 