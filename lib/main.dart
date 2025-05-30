// lib/main.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// استيراد التكوين
import 'package:tahania_app/config/app_config.dart';
import 'package:tahania_app/config/theme/app_theme.dart';

// استيراد الخدمات
import 'package:tahania_app/services/localization/app_localizations.dart';
import 'package:tahania_app/services/storage/storage_service.dart';
import 'package:tahania_app/core/services/config_service.dart';

// استيراد الصفحات
import 'package:tahania_app/app/main_navigation_screen.dart';
import 'package:tahania_app/features/greetings/screens/send_greeting_screen.dart';
import 'package:tahania_app/features/greetings/screens/enhanced_send_greeting_screen.dart';
import 'package:tahania_app/features/greetings/screens/surprise_message_screen.dart';
import 'package:tahania_app/features/greetings/screens/schedule_greeting_screen.dart';
import 'package:tahania_app/features/greetings/screens/greeting_history_screen.dart';
import 'package:tahania_app/features/greetings/screens/greeting_templates_screen.dart';
import 'package:tahania_app/features/contacts/screens/groups_screen.dart';
import 'package:tahania_app/features/settings/settings_screen.dart';

import 'package:tahania_app/services/memory_optimization_service.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // تهيئة خدمة تحسين الذاكرة
    MemoryOptimizationService().initialize();
    
    // تحميل إعدادات التطبيق الأساسية فقط
    final appConfig = AppConfig();
    await appConfig.loadSettings();
    
    // تحسين كاش الصور
    PaintingBinding.instance.imageCache.maximumSize = 100;
    
    // محاولة تحميل متغيرات البيئة ولكن عدم التوقف إذا فشل
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      debugPrint('⚠️ لم يتم العثور على ملف .env: $e');
    }
    
    // بدء تشغيل التطبيق مع ErrorWidget مخصص
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Material(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                'عذراً، حدث خطأ ما',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              if (details.exception.toString().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    details.exception.toString(),
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      );
    };
    
    // بدء تشغيل التطبيق
    runApp(TahniaApp(initialAppConfig: appConfig));
    
    // تهيئة الخدمات غير الضرورية بشكل متوازٍ في الخلفية
    _initializeNonEssentialServices().catchError((error) {
      debugPrint('❌ خطأ في تهيئة الخدمات الخلفية: $error');
    });
    
  } catch (e, stackTrace) {
    debugPrint('❌ خطأ في بدء التطبيق: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow;
  }
}

/// تهيئة الخدمات غير الضرورية في الخلفية بعد بدء التطبيق
Future<void> _initializeNonEssentialServices() async {
  try {
    // استخدام Future.wait لتشغيل العمليات بشكل متوازٍ مع معالجة الأخطاء
    await Future.wait([
      // تهيئة Hive
      () async {
        try {
          await Hive.initFlutter();
          await Hive.openBox('groupsBox');
        } catch (e) {
          debugPrint('⚠️ خطأ في تهيئة Hive: $e');
        }
      }(),
      
      // تهيئة خدمات التخزين
      () async {
        try {
          await StorageService.initialize();
        } catch (e) {
          debugPrint('⚠️ خطأ في تهيئة خدمة التخزين: $e');
        }
      }(),
      
      // تهيئة خدمة التكوين للذكاء الاصطناعي
      () async {
        try {
          await ConfigService.initialize();
        } catch (e) {
          debugPrint('⚠️ خطأ في تهيئة خدمة التكوين: $e');
        }
      }(),
    ]);
    
    debugPrint('✅ تم تهيئة جميع الخدمات في الخلفية');
  } catch (e) {
    debugPrint('❌ خطأ عام في تهيئة الخدمات: $e');
  }
}

class TahniaApp extends StatelessWidget {
  final AppConfig initialAppConfig;

  const TahniaApp({super.key, required this.initialAppConfig});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: initialAppConfig), // Use .value to provide the existing instance
      ],
      child: Consumer<AppConfig>(
        builder: (context, appConfig, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppConfig.appName,
            
            // دعم الترجمة
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ar', 'SA'),
              Locale('en', 'US'),
            ],
            locale: appConfig.currentLocale,
            
            // دعم الثيم
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appConfig.themeMode,
            
            // المسارات
            initialRoute: '/',
            routes: {
              '/': (_) => const MainNavigationScreen(),
              '/sendGreeting': (_) => const SendGreetingScreen(),
              '/enhanced-send-greeting': (_) => const EnhancedSendGreetingScreen(),
              '/surpriseMessage': (_) => const SurpriseMessageScreen(),
              '/scheduleGreeting': (_) => const ScheduleGreetingScreen(),
              '/greetingHistory': (_) => const GreetingHistoryScreen(),
              '/greetingTemplates': (_) => const GreetingTemplatesScreen(),
              '/groups': (_) => const GroupsScreen(),
              '/settings': (_) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}
