# دليل الترقية - Migration Guide

## 🔄 ترقية من OpenAIService إلى AIService

### التغييرات المطلوبة في الكود

#### 1. تحديث الاستيرادات (Imports)

**قبل:**
```dart
import 'package:tahania_app/core/services/openai_service.dart';
```

**بعد:**
```dart
import 'package:tahania_app/core/services/ai_service.dart';
```

#### 2. تحديث استدعاءات الخدمة

**قبل:**
```dart
final result = await OpenAIService.generateGreeting(
  prompt,
  senderName: senderName,
  recipientName: recipientName,
);
// result هو String
```

**بعد:**
```dart
final greeting = await AIService.generateGreeting(
  prompt,
  senderName: senderName,
  recipientName: recipientName,
);
// greeting هو Greeting object
final content = greeting.content;
final provider = greeting.provider;
final isGenerated = greeting.isGenerated;
```

#### 3. معالجة الأخطاء المحسنة

**قبل:**
```dart
try {
  final message = await OpenAIService.generateGreeting(prompt);
  // استخدام الرسالة
} catch (e) {
  // معالجة عامة للخطأ
  print('خطأ: $e');
}
```

**بعد:**
```dart
try {
  final greeting = await AIService.generateGreeting(prompt);
  
  if (greeting.isGenerated) {
    // رسالة مُولدة بالذكاء الاصطناعي
    print('تم التوليد بواسطة: ${greeting.provider}');
  } else {
    // رسالة احتياطية
    print('تم استخدام النظام الاحتياطي');
  }
  
  // استخدام المحتوى
  final content = greeting.content;
  
} on AIServiceException catch (e) {
  // معالجة أخطاء الخدمة الذكية
  showErrorDialog(e.message); // رسالة مُعرَّبة للمستخدم
} catch (e) {
  // معالجة أخطاء أخرى
  showErrorDialog('حدث خطأ غير متوقع');
}
```

#### 4. فحص حالة الخدمة

**جديد:**
```dart
final status = await AIService.checkServiceStatus();

if (status.hasAnyProvider) {
  print('الخدمة متوفرة');
  print('المزود الافتراضي: ${status.defaultProvider.name}');
  print('OpenAI متوفر: ${status.openaiAvailable}');
  print('OpenRouter متوفر: ${status.openrouterAvailable}');
} else {
  print('لا توجد مفاتيح API مُكونة');
}
```

#### 5. اختيار مزود محدد

**جديد:**
```dart
// استخدام OpenAI تحديداً
final greeting = await AIService.generateGreeting(
  prompt,
  preferredProvider: AIProvider.openai,
);

// استخدام OpenRouter تحديداً
final greeting = await AIService.generateGreeting(
  prompt,
  preferredProvider: AIProvider.openrouter,
);
```

### الملفات التي تحتاج تحديث

#### 1. ملفات الشاشات (Screens)
ابحث عن جميع الملفات التي تستخدم `OpenAIService.generateGreeting` وقم بتحديثها.

#### 2. ملفات الخدمات (Services)
إذا كان لديك خدمات أخرى تستدعي `OpenAIService`.

#### 3. ملفات الاختبار (Tests)
قم بتحديث اختبارات الوحدة لتستخدم `AIService`.

### مثال كامل للترقية

**قبل (في ملف الشاشة):**
```dart
class MessageScreen extends StatefulWidget {
  // ...
}

class _MessageScreenState extends State<MessageScreen> {
  String? _generatedMessage;
  bool _isLoading = false;

  Future<void> _generateMessage() async {
    setState(() => _isLoading = true);
    
    try {
      final message = await OpenAIService.generateGreeting(
        _promptController.text,
        senderName: _senderController.text,
        recipientName: _recipientController.text,
      );
      
      setState(() {
        _generatedMessage = message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e')),
      );
    }
  }
}
```

**بعد:**
```dart
class MessageScreen extends StatefulWidget {
  // ...
}

class _MessageScreenState extends State<MessageScreen> {
  Greeting? _greeting;
  bool _isLoading = false;

  Future<void> _generateMessage() async {
    setState(() => _isLoading = true);
    
    try {
      final greeting = await AIService.generateGreeting(
        _promptController.text,
        senderName: _senderController.text,
        recipientName: _recipientController.text,
      );
      
      setState(() {
        _greeting = greeting;
        _isLoading = false;
      });
      
      // إظهار معلومات إضافية للمطور
      if (greeting.isGenerated) {
        print('✅ تم التوليد بواسطة: ${greeting.provider}');
      } else {
        print('🔄 تم استخدام النظام الاحتياطي');
      }
      
    } on AIServiceException catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)), // رسالة مُعرَّبة
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ غير متوقع')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ...
      body: Column(
        children: [
          // ...
          if (_greeting != null) ...[
            Text(_greeting!.content),
            if (_greeting!.isGenerated)
              Text('مُولد بواسطة: ${_greeting!.provider}')
            else
              Text('رسالة احتياطية'),
          ],
          // ...
        ],
      ),
    );
  }
}
```

### خطوات الترقية

1. **قم بتحديث مفاتيح API في ملف .env**
2. **ابحث عن جميع استخدامات `OpenAIService`**
3. **استبدلها بـ `AIService`**
4. **حدث معالجة الأخطاء**
5. **اختبر التطبيق**
6. **احذف `OpenAIService` القديم (اختياري)**

### فوائد الترقية

- ✅ **أمان محسن**: مفاتيح API منفصلة ومحمية
- ✅ **موثوقية أعلى**: نظام احتياطي ذكي
- ✅ **تجربة مستخدم أفضل**: رسائل خطأ مُعرَّبة
- ✅ **مرونة أكثر**: دعم مزودين متعددين
- ✅ **سجلات مفصلة**: تسهل استكشاف الأخطاء
- ✅ **كود أكثر تنظيماً**: فصل الاهتمامات

---

**ملاحظة:** يمكنك الاحتفاظ بـ `OpenAIService` القديم مؤقتاً أثناء الترقية التدريجية، ثم حذفه بعد التأكد من عمل النظام الجديد بشكل صحيح.
