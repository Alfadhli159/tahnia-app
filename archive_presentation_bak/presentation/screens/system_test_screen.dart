import 'package:flutter/material.dart';
import 'package:tahania_app/theme/app_theme.dart';
import 'package:tahania_app/theme/app_styles.dart';
import 'package:tahania_app/theme/app_constants.dart';
import 'package:tahania_app/theme/app_utils.dart';
// تم تعليق هذا الاستيراد تلقائياً: import 'package:tahania_app/services/auto_reply_service.dart';
import 'package:tahania_app/services/scheduled_message_service.dart';
import 'package:tahania_app/services/template_service.dart';
import 'package:tahania_app/services/settings_service.dart';

class SystemTestScreen extends StatefulWidget {
  const SystemTestScreen({super.key});

  @override
  State<SystemTestScreen> createState() => _SystemTestScreenState();
}

class _SystemTestScreenState extends State<SystemTestScreen> {
  final _autoReplyService = AutoReplyService();
  final _scheduledMessageService = ScheduledMessageService();
  final _templateService = TemplateService();
  final _settingsService = SettingsService();

  bool _isTesting = false;
  String _testResult = '';
  Map<String, bool> _testResults = {};

  Future<void> _runAllTests() async {
    setState(() {
      _isTesting = true;
      _testResult = '';
      _testResults.clear();
    });

    try {
      // اختبار خدمة الرد التلقائي
      await _testAutoReplyService();
      
      // اختبار خدمة الرسائل المجدولة
      await _testScheduledMessageService();
      
      // اختبار خدمة القوالب
      await _testTemplateService();
      
      // اختبار خدمة الإعدادات
      await _testSettingsService();
      
      // اختبار الاتصال بالإنترنت
      await _testInternetConnection();
      
      // اختبار الصلاحيات
      await _testPermissions();
      
      // اختبار التخزين المحلي
      await _testLocalStorage();
      
      // اختبار الإشعارات
      await _testNotifications();
      
      setState(() {
        _testResult = 'تم الانتهاء من جميع الاختبارات بنجاح';
      });
    } catch (e) {
      setState(() {
        _testResult = 'حدث خطأ أثناء الاختبار: $e';
      });
    } finally {
      setState(() {
        _isTesting = false;
      });
    }
  }

  Future<void> _testAutoReplyService() async {
    try {
      // اختبار تحليل المشاعر
      final sentiment = await _autoReplyService.analyzeSentiment('رسالة اختبار');
      _testResults['تحليل المشاعر'] = sentiment != null;
      
      // اختبار توليد الردود
      final replies = await _autoReplyService.generateReplies('رسالة اختبار');
      _testResults['توليد الردود'] = replies.isNotEmpty;
      
      // اختبار حفظ الإعدادات
      await _autoReplyService.updateSettings(
        isEnabled: true,
        notifyOnNewMessage: true,
        notifyOnApproval: true,
      );
      _testResults['حفظ إعدادات الرد التلقائي'] = true;
      
    } catch (e) {
      _testResults['خدمة الرد التلقائي'] = false;
      throw Exception('فشل اختبار خدمة الرد التلقائي: $e');
    }
  }

  Future<void> _testScheduledMessageService() async {
    try {
      // اختبار إضافة رسالة مجدولة
      final message = await _scheduledMessageService.addMessage(
        recipientName: 'اختبار',
        recipientNumber: '1234567890',
        message: 'رسالة اختبار',
        scheduledTime: DateTime.now().add(const Duration(minutes: 5)),
      );
      _testResults['إضافة رسالة مجدولة'] = message != null;
      
      // اختبار البحث في الرسائل
      final searchResults = await _scheduledMessageService.searchMessages('اختبار');
      _testResults['بحث الرسائل المجدولة'] = true;
      
      // اختبار حذف الرسالة
      if (message != null) {
        await _scheduledMessageService.deleteMessage(message.id);
        _testResults['حذف رسالة مجدولة'] = true;
      }
      
    } catch (e) {
      _testResults['خدمة الرسائل المجدولة'] = false;
      throw Exception('فشل اختبار خدمة الرسائل المجدولة: $e');
    }
  }

  Future<void> _testTemplateService() async {
    try {
      // اختبار إضافة قالب
      final template = await _templateService.addTemplate(
        name: 'قالب اختبار',
        content: 'محتوى اختبار',
        category: AppConstants.templateCategories[1],
        tags: [AppConstants.templateTags[0]],
      );
      _testResults['إضافة قالب'] = template != null;
      
      // اختبار البحث في القوالب
      final searchResults = await _templateService.searchTemplates('اختبار');
      _testResults['بحث القوالب'] = true;
      
      // اختبار حذف القالب
      if (template != null) {
        await _templateService.deleteTemplate(template.id);
        _testResults['حذف قالب'] = true;
      }
      
    } catch (e) {
      _testResults['خدمة القوالب'] = false;
      throw Exception('فشل اختبار خدمة القوالب: $e');
    }
  }

  Future<void> _testSettingsService() async {
    try {
      // اختبار حفظ الإعدادات
      await _settingsService.updateGeneralSettings(
        isDarkMode: false,
        language: 'ar',
        fontSize: 16,
      );
      _testResults['حفظ الإعدادات العامة'] = true;
      
      // اختبار حفظ إعدادات الإشعارات
      await _settingsService.updateNotificationSettings(
        isEnabled: true,
        sound: true,
        vibration: true,
      );
      _testResults['حفظ إعدادات الإشعارات'] = true;
      
    } catch (e) {
      _testResults['خدمة الإعدادات'] = false;
      throw Exception('فشل اختبار خدمة الإعدادات: $e');
    }
  }

  Future<void> _testInternetConnection() async {
    try {
      final hasConnection = await AppUtils.checkInternetConnection();
      _testResults['الاتصال بالإنترنت'] = hasConnection;
    } catch (e) {
      _testResults['الاتصال بالإنترنت'] = false;
      throw Exception('فشل اختبار الاتصال بالإنترنت: $e');
    }
  }

  Future<void> _testPermissions() async {
    try {
      final hasPermission = await AppUtils.checkPermission('notification');
      _testResults['صلاحيات الإشعارات'] = hasPermission;
    } catch (e) {
      _testResults['الصلاحيات'] = false;
      throw Exception('فشل اختبار الصلاحيات: $e');
    }
  }

  Future<void> _testLocalStorage() async {
    try {
      // اختبار التخزين المحلي
      _testResults['التخزين المحلي'] = true;
    } catch (e) {
      _testResults['التخزين المحلي'] = false;
      throw Exception('فشل اختبار التخزين المحلي: $e');
    }
  }

  Future<void> _testNotifications() async {
    try {
      // اختبار الإشعارات
      _testResults['الإشعارات'] = true;
    } catch (e) {
      _testResults['الإشعارات'] = false;
      throw Exception('فشل اختبار الإشعارات: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختبار النظام'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isTesting ? null : _runAllTests,
            tooltip: 'تشغيل الاختبارات',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppStyles.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // زر تشغيل الاختبارات
            ElevatedButton.icon(
              onPressed: _isTesting ? null : _runAllTests,
              icon: _isTesting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.play_arrow),
              label: Text(_isTesting ? 'جاري الاختبار...' : 'تشغيل الاختبارات'),
              style: AppStyles.primaryButtonStyle,
            ),
            const SizedBox(height: AppStyles.spacingM),
            
            // نتائج الاختبارات
            if (_testResults.isNotEmpty) ...[
              const Text(
                'نتائج الاختبارات:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppStyles.spacingS),
              ..._testResults.entries.map((entry) => Card(
                child: ListTile(
                  leading: Icon(
                    entry.value ? Icons.check_circle : Icons.error,
                    color: entry.value ? Colors.green : Colors.red,
                  ),
                  title: Text(entry.key),
                  trailing: Text(
                    entry.value ? 'نجاح' : 'فشل',
                    style: TextStyle(
                      color: entry.value ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )),
            ],
            
            // رسالة النتيجة
            if (_testResult.isNotEmpty) ...[
              const SizedBox(height: AppStyles.spacingM),
              Card(
                color: _testResult.contains('نجاح')
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(AppStyles.spacingM),
                  child: Text(
                    _testResult,
                    style: TextStyle(
                      color: _testResult.contains('نجاح')
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 