# إعداد مفاتيح الذكاء الاصطناعي - Tahania App

## 🔧 التكوين المطلوب

### 1. إعداد ملف البيئة (.env)

قم بتحديث ملف `.env` في جذر المشروع بمفاتيح API الخاصة بك:

```env
# OpenAI Configuration
OPENAI_API_KEY=sk-your-actual-openai-key-here
OPENAI_MODEL=gpt-3.5-turbo

# OpenRouter Configuration (Free Alternative)
OPENROUTER_API_KEY=sk-your-actual-openrouter-key-here
OPENROUTER_MODEL=mistralai/mistral-7b-instruct

# Default AI Provider (openai or openrouter)
DEFAULT_AI_PROVIDER=openai
```

### 2. الحصول على مفاتيح API

#### OpenAI API Key:
1. اذهب إلى [OpenAI Platform](https://platform.openai.com/)
2. قم بإنشاء حساب أو تسجيل الدخول
3. اذهب إلى [API Keys](https://platform.openai.com/api-keys)
4. انقر على "Create new secret key"
5. انسخ المفتاح وضعه في `OPENAI_API_KEY`

#### OpenRouter API Key (البديل المجاني):
1. اذهب إلى [OpenRouter](https://openrouter.ai/)
2. قم بإنشاء حساب
3. اذهب إلى [Keys](https://openrouter.ai/keys)
4. انقر على "Create Key"
5. انسخ المفتاح وضعه في `OPENROUTER_API_KEY`

### 3. تشغيل التطبيق

```bash
# تحديث التبعيات
flutter pub get

# تشغيل التطبيق
flutter run
```

## 🔍 استكشاف الأخطاء

### المشكلة: "يرجى إضافة مفتاح OpenAI"

**الحلول:**

1. **تأكد من صحة مفتاح API:**
   - تأكد أن المفتاح لا يحتوي على `your_` أو `_here`
   - تأكد أن المفتاح يبدأ بـ `sk-`

2. **تأكد من ملف .env:**
   - تأكد أن ملف `.env` موجود في جذر المشروع
   - تأكد أن الملف مُضاف في `pubspec.yaml` تحت `assets`

3. **إعادة تشغيل التطبيق:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

### المشكلة: خطأ 401 (Unauthorized)

- تأكد من صحة مفتاح API
- تأكد من وجود رصيد في حساب OpenAI
- جرب استخدام OpenRouter كبديل

### المشكلة: خطأ 429 (Rate Limit)

- تم تجاوز الحد المسموح من الطلبات
- انتظر قليلاً ثم أعد المحاولة
- فعّل OpenRouter كبديل

## 🎯 الميزات الجديدة

### ✅ فصل المفاتيح الحساسة
- مفاتيح API منفصلة في ملف `.env`
- حماية من التسريب عبر `.gitignore`

### ✅ التحقق الآمن من الاستجابة
- فحص شامل لصحة البيانات المُستلمة
- معالجة أخطاء مُحسنة

### ✅ نظام احتياطي ذكي
- تبديل تلقائي بين OpenAI و OpenRouter
- رسائل احتياطية عند فشل الخدمات

### ✅ رسائل خطأ مُعرَّبة
- رسائل واضحة للمستخدم النهائي
- إرشادات مفيدة لحل المشاكل

### ✅ تسجيل مُحسن
- سجلات مفصلة لاستكشاف الأخطاء
- تتبع حالة الخدمات

## 📱 كيفية الاستخدام

```dart
import 'package:tahania_app/core/services/ai_service.dart';

// توليد تهنئة
final greeting = await AIService.generateGreeting(
  'اكتب تهنئة بمناسبة عيد ميلاد صديقي أحمد',
  senderName: 'محمد',
  recipientName: 'أحمد',
);

print('المحتوى: ${greeting.content}');
print('المزود: ${greeting.provider}');
print('مُولد بالذكاء الاصطناعي: ${greeting.isGenerated}');
```

## 🔒 الأمان

- ✅ مفاتيح API محمية في ملف `.env`
- ✅ ملف `.env` مُستبعد من Git
- ✅ لا توجد مفاتيح مُشفرة في الكود
- ✅ التحقق من صحة المفاتيح قبل الاستخدام

## 📞 الدعم

إذا واجهت أي مشاكل:

1. تأكد من اتباع خطوات الإعداد بدقة
2. راجع قسم استكشاف الأخطاء
3. تحقق من سجلات التطبيق للحصول على تفاصيل أكثر

---

**ملاحظة مهمة:** لا تشارك مفاتيح API مع أي شخص ولا تضعها في أي مكان عام!
