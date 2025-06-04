import 'package:flutter/material.dart';
import 'package:tahania_app/services/settings_service.dart';
import '../../../../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

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
  Widget build(BuildContext context) => Scaffold(
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
                    const SizedBox(height: 16),
                    _buildAccountSettings(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

  Widget _buildGeneralSettings(AppSettings settings) => _buildSection(
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

  Widget _buildAccountSettings() => _buildSection(
      title: 'إعدادات الحساب',
      icon: Icons.account_circle,
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('معلومات الحساب'),
          subtitle: Text(AuthService.currentUser?.email ?? 'غير محدد'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Navigate to account info screen
          },
        ),
        ListTile(
          leading: const Icon(Icons.email),
          title: const Text('حالة التحقق من البريد'),
          subtitle: Text(
            AuthService.isEmailVerified ? 'تم التحقق' : 'لم يتم التحقق',
          ),
          trailing: AuthService.isEmailVerified
              ? const Icon(Icons.verified, color: Colors.green)
              : TextButton(
                  onPressed: () async {
                    try {
                      await AuthService.sendEmailVerification();
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم إرسال رابط التحقق'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('فشل إرسال رابط التحقق: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('إرسال رابط التحقق'),
                ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title:
              const Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
          onTap: () => _showSignOutDialog(),
        ),
        ListTile(
          leading: const Icon(Icons.delete_forever, color: Colors.red),
          title: const Text('حذف الحساب', style: TextStyle(color: Colors.red)),
          onTap: () => _showDeleteAccountDialog(),
        ),
      ],
    );

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: const Text('تسجيل الخروج'),
          content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await AuthService.signOut();
                  // Navigation will be handled by AuthWrapper
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('فشل تسجيل الخروج: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('تسجيل الخروج',
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: const Text('حذف الحساب'),
          content: const Text(
            'هل أنت متأكد من رغبتك في حذف حسابك نهائياً؟ هذا الإجراء لا يمكن التراجع عنه.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await AuthService.deleteAccount();
                  // Navigation will be handled by AuthWrapper
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('فشل حذف الحساب: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child:
                  const Text('حذف الحساب', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) => Card(
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
