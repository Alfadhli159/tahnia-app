import 'package:flutter/material.dart';
import 'package:tahania_app/services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // تم إزالة استدعاء غير معرف: SettingsService.initialize()
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: ValueListenableBuilder<AppSettings>(
        valueListenable: SettingsService.settingsNotifier,
        builder: (context, settings, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'بحث في الإعدادات',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildGeneralSettings(settings),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGeneralSettings(AppSettings settings) {
    return _buildSection(
      title: 'إعدادات عامة',
      icon: Icons.settings,
      children: [
        SwitchListTile(
          title: const Text('عرض شاشة الترحيب'),
          subtitle: const Text('عرض شاشة الترحيب عند فتح التطبيق'),
          value: settings.general.showWelcomeScreen,
          onChanged: (value) {
            SettingsService.updateGeneralSettings(
              GeneralSettings(
                showWelcomeScreen: value,
                enableAnalytics: settings.general.enableAnalytics,
              ),
            );
          },
        ),
        SwitchListTile(
          title: const Text('تحليلات التطبيق'),
          subtitle: const Text('تفعيل/تعطيل تحليلات استخدام التطبيق'),
          value: settings.general.enableAnalytics,
          onChanged: (value) {
            SettingsService.updateGeneralSettings(
              GeneralSettings(
                showWelcomeScreen: settings.general.showWelcomeScreen,
                enableAnalytics: value,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }
}
