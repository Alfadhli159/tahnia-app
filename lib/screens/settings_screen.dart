import 'package:flutter/material.dart';
import 'package:tahania_app/services/settings_service.dart';
import 'package:tahania_app/config/theme/app_theme.dart';

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
    SettingsService.initialize();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // عرض صفحة المساعدة
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<AppSettings>(
        valueListenable: SettingsService.settingsNotifier,
        builder: (context, settings, child) {
          return Column(
            children: [
              // شريط البحث
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

              // قائمة الإعدادات
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // إعدادات عامة
                    _buildSection(
                      title: 'إعدادات عامة',
                      icon: Icons.settings,
                      children: [
                        SwitchListTile(
                          title: const Text('عرض شاشة الترحيب'),
                          subtitle: const Text('عرض شاشة الترحيب عند فتح التطبيق'),
                          value: settings.general.showWelcomeScreen,
                          onChanged: (value) {
                            SettingsService.updateGeneralSettings(
                              settings.general.copyWith(showWelcomeScreen: value),
                            );
                          },
                        ),
                        SwitchListTile(
                          title: const Text('تحليلات التطبيق'),
                          subtitle: const Text('تفعيل/تعطيل تحليلات استخدام التطبيق'),
                          value: settings.general.enableAnalytics,
                          onChanged: (value) {
                            SettingsService.updateGeneralSettings(
                              settings.general.copyWith(enableAnalytics: value),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // إعدادات المظهر
                    _buildSection(
                      title: 'إعدادات المظهر',
                      icon: Icons.palette,
                      children: [
                        ListTile(
                          title: const Text('السمة'),
                          subtitle: const Text('اختر سمة التطبيق'),
                          trailing: DropdownButton<ThemeMode>(
                            value: settings.appearance.themeMode,
                            items: const [
                              DropdownMenuItem(
                                value: ThemeMode.system,
                                child: Text('تلقائي'),
                              ),
                              DropdownMenuItem(
                                value: ThemeMode.light,
                                child: Text('فاتح'),
                              ),
                              DropdownMenuItem(
                                value: ThemeMode.dark,
                                child: Text('داكن'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                SettingsService.updateAppearanceSettings(
                                  settings.appearance.copyWith(themeMode: value),
                                );
                              }
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('حجم الخط'),
                          subtitle: const Text('اختر حجم الخط المناسب'),
                          trailing: DropdownButton<double>(
                            value: settings.appearance.fontSize,
                            items: const [
                              DropdownMenuItem(
                                value: 14.0,
                                child: Text('صغير'),
                              ),
                              DropdownMenuItem(
                                value: 16.0,
                                child: Text('متوسط'),
                              ),
                              DropdownMenuItem(
                                value: 18.0,
                                child: Text('كبير'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                SettingsService.updateAppearanceSettings(
                                  settings.appearance.copyWith(fontSize: value),
                                );
                              }
                            },
                          ),
                        ),
                        SwitchListTile(
                          title: const Text('اتجاه RTL'),
                          subtitle: const Text('تفعيل/تعطيل اتجاه النص من اليمين إلى اليسار'),
                          value: settings.appearance.isRTL,
                          onChanged: (value) {
                            SettingsService.updateAppearanceSettings(
                              settings.appearance.copyWith(isRTL: value),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // إعدادات الخصوصية
                    _buildSection(
                      title: 'إعدادات الخصوصية',
                      icon: Icons.security,
                      children: [
                        SwitchListTile(
                          title: const Text('تتبع الموقع'),
                          subtitle: const Text('تفعيل/تعطيل تتبع موقع الجهاز'),
                          value: settings.privacy.locationTracking,
                          onChanged: (value) {
                            SettingsService.updatePrivacySettings(
                              settings.privacy.copyWith(locationTracking: value),
                            );
                          },
                        ),
                        SwitchListTile(
                          title: const Text('المصادقة البيومترية'),
                          subtitle: const Text('استخدام البصمة أو الوجه للدخول'),
                          value: settings.privacy.biometricAuth,
                          onChanged: (value) {
                            SettingsService.updatePrivacySettings(
                              settings.privacy.copyWith(biometricAuth: value),
                            );
                          },
                        ),
                        SwitchListTile(
                          title: const Text('تشفير البيانات'),
                          subtitle: const Text('تشفير البيانات المحلية'),
                          value: settings.privacy.encryptData,
                          onChanged: (value) {
                            SettingsService.updatePrivacySettings(
                              settings.privacy.copyWith(encryptData: value),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // إعدادات النسخ الاحتياطي
                    _buildSection(
                      title: 'إعدادات النسخ الاحتياطي',
                      icon: Icons.backup,
                      children: [
                        SwitchListTile(
                          title: const Text('نسخ احتياطي تلقائي'),
                          subtitle: const Text('تفعيل/تعطيل النسخ الاحتياطي التلقائي'),
                          value: settings.backup.autoBackup,
                          onChanged: (value) {
                            SettingsService.updateBackupSettings(
                              settings.backup.copyWith(autoBackup: value),
                            );
                          },
                        ),
                        ListTile(
                          title: const Text('تكرار النسخ الاحتياطي'),
                          subtitle: const Text('اختر تكرار النسخ الاحتياطي'),
                          trailing: DropdownButton<String>(
                            value: settings.backup.backupFrequency,
                            items: const [
                              DropdownMenuItem(
                                value: 'daily',
                                child: Text('يومي'),
                              ),
                              DropdownMenuItem(
                                value: 'weekly',
                                child: Text('أسبوعي'),
                              ),
                              DropdownMenuItem(
                                value: 'monthly',
                                child: Text('شهري'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                SettingsService.updateBackupSettings(
                                  settings.backup.copyWith(backupFrequency: value),
                                );
                              }
                            },
                          ),
                        ),
                        SwitchListTile(
                          title: const Text('مزامنة السحابة'),
                          subtitle: const Text('مزامنة البيانات مع السحابة'),
                          value: settings.backup.cloudSync,
                          onChanged: (value) {
                            SettingsService.updateBackupSettings(
                              settings.backup.copyWith(cloudSync: value),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // إعدادات الأداء
                    _buildSection(
                      title: 'إعدادات الأداء',
                      icon: Icons.speed,
                      children: [
                        SwitchListTile(
                          title: const Text('وضع توفير الطاقة'),
                          subtitle: const Text('تفعيل/تعطيل وضع توفير الطاقة'),
                          value: settings.performance.lowPowerMode,
                          onChanged: (value) {
                            SettingsService.updatePerformanceSettings(
                              settings.performance.copyWith(lowPowerMode: value),
                            );
                          },
                        ),
                        SwitchListTile(
                          title: const Text('مسح الذاكرة المؤقتة عند الخروج'),
                          subtitle: const Text('مسح الذاكرة المؤقتة عند إغلاق التطبيق'),
                          value: settings.performance.clearCacheOnExit,
                          onChanged: (value) {
                            SettingsService.updatePerformanceSettings(
                              settings.performance.copyWith(clearCacheOnExit: value),
                            );
                          },
                        ),
                        ListTile(
                          title: const Text('حجم الذاكرة المؤقتة'),
                          subtitle: const Text('اختر الحد الأقصى لحجم الذاكرة المؤقتة'),
                          trailing: DropdownButton<int>(
                            value: settings.performance.maxCacheSize,
                            items: const [
                              DropdownMenuItem(
                                value: 50,
                                child: Text('50 ميجابايت'),
                              ),
                              DropdownMenuItem(
                                value: 100,
                                child: Text('100 ميجابايت'),
                              ),
                              DropdownMenuItem(
                                value: 200,
                                child: Text('200 ميجابايت'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                SettingsService.updatePerformanceSettings(
                                  settings.performance.copyWith(maxCacheSize: value),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // إعدادات اللغة
                    _buildSection(
                      title: 'إعدادات اللغة',
                      icon: Icons.language,
                      children: [
                        ListTile(
                          title: const Text('لغة التطبيق'),
                          subtitle: const Text('اختر لغة التطبيق'),
                          trailing: DropdownButton<String>(
                            value: settings.language.language,
                            items: const [
                              DropdownMenuItem(
                                value: 'ar',
                                child: Text('العربية'),
                              ),
                              DropdownMenuItem(
                                value: 'en',
                                child: Text('English'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                SettingsService.updateLanguageSettings(
                                  settings.language.copyWith(language: value),
                                );
                              }
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('تنسيق التاريخ'),
                          subtitle: const Text('اختر تنسيق عرض التاريخ'),
                          trailing: DropdownButton<String>(
                            value: settings.language.dateFormat,
                            items: const [
                              DropdownMenuItem(
                                value: 'dd/MM/yyyy',
                                child: Text('DD/MM/YYYY'),
                              ),
                              DropdownMenuItem(
                                value: 'MM/dd/yyyy',
                                child: Text('MM/DD/YYYY'),
                              ),
                              DropdownMenuItem(
                                value: 'yyyy-MM-dd',
                                child: Text('YYYY-MM-DD'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                SettingsService.updateLanguageSettings(
                                  settings.language.copyWith(dateFormat: value),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // إعدادات الأمان
                    _buildSection(
                      title: 'إعدادات الأمان',
                      icon: Icons.lock,
                      children: [
                        SwitchListTile(
                          title: const Text('المصادقة الثنائية'),
                          subtitle: const Text('تفعيل/تعطيل المصادقة الثنائية'),
                          value: settings.security.twoFactorAuth,
                          onChanged: (value) {
                            SettingsService.updateSecuritySettings(
                              settings.security.copyWith(twoFactorAuth: value),
                            );
                          },
                        ),
                        SwitchListTile(
                          title: const Text('المصادقة البيومترية'),
                          subtitle: const Text('استخدام البصمة أو الوجه للدخول'),
                          value: settings.security.biometricAuth,
                          onChanged: (value) {
                            SettingsService.updateSecuritySettings(
                              settings.security.copyWith(biometricAuth: value),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // إعدادات التخصيص
                    _buildSection(
                      title: 'إعدادات التخصيص',
                      icon: Icons.dashboard_customize,
                      children: [
                        SwitchListTile(
                          title: const Text('تخصيص الشاشة الرئيسية'),
                          subtitle: const Text('تخصيص ترتيب العناصر في الشاشة الرئيسية'),
                          value: settings.customization.customHomeScreen,
                          onChanged: (value) {
                            SettingsService.updateCustomizationSettings(
                              settings.customization.copyWith(customHomeScreen: value),
                            );
                          },
                        ),
                        SwitchListTile(
                          title: const Text('تخصيص القائمة الجانبية'),
                          subtitle: const Text('تخصيص ترتيب العناصر في القائمة الجانبية'),
                          value: settings.customization.customDrawer,
                          onChanged: (value) {
                            SettingsService.updateCustomizationSettings(
                              settings.customization.copyWith(customDrawer: value),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // إعدادات التكامل
                    _buildSection(
                      title: 'إعدادات التكامل',
                      icon: Icons.integration_instructions,
                      children: [
                        SwitchListTile(
                          title: const Text('تكامل التقويم'),
                          subtitle: const Text('تكامل مع تطبيقات التقويم'),
                          value: settings.integration.calendarIntegration,
                          onChanged: (value) {
                            SettingsService.updateIntegrationSettings(
                              settings.integration.copyWith(calendarIntegration: value),
                            );
                          },
                        ),
                        SwitchListTile(
                          title: const Text('تكامل المهام'),
                          subtitle: const Text('تكامل مع تطبيقات المهام'),
                          value: settings.integration.tasksIntegration,
                          onChanged: (value) {
                            SettingsService.updateIntegrationSettings(
                              settings.integration.copyWith(tasksIntegration: value),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // إعدادات التقارير
                    _buildSection(
                      title: 'إعدادات التقارير',
                      icon: Icons.assessment,
                      children: [
                        SwitchListTile(
                          title: const Text('إحصائيات الاستخدام'),
                          subtitle: const Text('تفعيل/تعطيل إحصائيات استخدام التطبيق'),
                          value: settings.reporting.usageStatistics,
                          onChanged: (value) {
                            SettingsService.updateReportingSettings(
                              settings.reporting.copyWith(usageStatistics: value),
                            );
                          },
                        ),
                        SwitchListTile(
                          title: const Text('تقارير الأداء'),
                          subtitle: const Text('تفعيل/تعطيل تقارير أداء التطبيق'),
                          value: settings.reporting.performanceReports,
                          onChanged: (value) {
                            SettingsService.updateReportingSettings(
                              settings.reporting.copyWith(performanceReports: value),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // أزرار الإجراءات
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.file_download),
                          label: const Text('تصدير الإعدادات'),
                          onPressed: () async {
                            final settings = await SettingsService.exportSettings();
                            // تنفيذ عملية التصدير
                          },
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.file_upload),
                          label: const Text('استيراد الإعدادات'),
                          onPressed: () {
                            // تنفيذ عملية الاستيراد
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.delete_forever),
                      label: const Text('إعادة تعيين الإعدادات'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('إعادة تعيين الإعدادات'),
                            content: const Text('هل أنت متأكد من إعادة تعيين جميع الإعدادات؟'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('إلغاء'),
                              ),
                              TextButton(
                                onPressed: () {
                                  SettingsService.resetSettings();
                                  Navigator.pop(context);
                                },
                                child: const Text('تأكيد'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
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