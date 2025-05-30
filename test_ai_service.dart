import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'lib/core/services/config_service.dart';
import 'lib/core/services/ai_service.dart';

void main() async {
  print('🔧 تحميل متغيرات البيئة...');
  await dotenv.load(fileName: ".env");
  
  print('🔧 تهيئة خدمة التكوين...');
  await ConfigService.initialize();
  
  print('🔍 فحص حالة الخدمة...');
  final status = await AIService.checkServiceStatus();
  print('📊 حالة الخدمة: $status');
  
  print('🔑 مفتاح OpenAI: ${ConfigService.getApiKey(AIProvider.openai)?.substring(0, 10)}...');
  print('🤖 النموذج: ${ConfigService.getModel(AIProvider.openai)}');
  print('🌐 URL: ${ConfigService.getApiUrl(AIProvider.openai)}');
  
  if (status.hasAnyProvider) {
    print('✅ يوجد مزود ذكاء اصطناعي متاح');
    
    try {
      print('🚀 محاولة توليد رسالة تجريبية...');
      final greeting = await AIService.generateGreeting(
        'اكتب تهنئة عيد ميلاد قصيرة ومميزة',
        senderName: 'أحمد',
        recipientName: 'فاطمة',
      );
      
      print('✅ تم توليد الرسالة بنجاح!');
      print('📝 المحتوى: ${greeting.content}');
      print('🔧 المصدر: ${greeting.source}');
      
    } catch (e) {
      print('❌ خطأ في توليد الرسالة: $e');
    }
  } else {
    print('❌ لا يوجد مزود ذكاء اصطناعي متاح');
  }
}
