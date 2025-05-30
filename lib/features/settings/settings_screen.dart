import 'package:flutter/material.dart';
import '../../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _senderNameController = TextEditingController();
  final _signatureController = TextEditingController();
  bool _autoSignature = true;
  String _selectedLanguage = 'ar';
  String _selectedTheme = 'system';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final senderName = await SettingsService.getSenderName();
    final signature = await SettingsService.getDefaultSignature();
    final autoSignature = await SettingsService.getAutoSignature();
    final language = await SettingsService.getPreferredLanguage();
    final theme = await SettingsService.getThemeMode();

    setState(() {
      _senderNameController.text = senderName ?? '';
      _signatureController.text = signature ?? '';
      _autoSignature = autoSignature;
      _selectedLanguage = language;
      _selectedTheme = theme;
    });
  }

  Future<void> _saveSettings() async {
    await SettingsService.setSenderName(_senderNameController.text);
    await SettingsService.setDefaultSignature(_signatureController.text);
    await SettingsService.setAutoSignature(_autoSignature);
    await SettingsService.setPreferredLanguage(_selectedLanguage);
    await SettingsService.setThemeMode(_selectedTheme);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ الإعدادات بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // إعدادات المرسل
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إعدادات المرسل',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _senderNameController,
                      decoration: const InputDecoration(
                        labelText: 'اسم المرسل',
                        hintText: 'أدخل اسمك',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _signatureController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'التوقيع الافتراضي',
                        hintText: 'مع أطيب التحيات',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.edit),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('إضافة التوقيع تلقائياً'),
                      subtitle: const Text('إضافة التوقيع في نهاية كل رسالة'),
                      value: _autoSignature,
                      onChanged: (value) {
                        setState(() {
                          _autoSignature = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // إعدادات التطبيق
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إعدادات التطبيق',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedLanguage,
                      decoration: const InputDecoration(
                        labelText: 'اللغة',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.language),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'ar', child: Text('العربية')),
                        DropdownMenuItem(value: 'en', child: Text('English')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedLanguage = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedTheme,
                      decoration: const InputDecoration(
                        labelText: 'المظهر',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.palette),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'system', child: Text('تلقائي')),
                        DropdownMenuItem(value: 'light', child: Text('فاتح')),
                        DropdownMenuItem(value: 'dark', child: Text('داكن')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedTheme = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // أزرار الإجراءات
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveSettings,
                    icon: const Icon(Icons.save),
                    label: const Text('حفظ الإعدادات'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('تأكيد'),
                          content: const Text('هل تريد مسح جميع الإعدادات؟'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('إلغاء'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('مسح'),
                            ),
                          ],
                        ),
                      );
                      
                      if (confirmed == true) {
                        await SettingsService.clearAllSettings();
                        await _loadSettings();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تم مسح الإعدادات'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text('مسح الإعدادات'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _senderNameController.dispose();
    _signatureController.dispose();
    super.dispose();
  }
}
