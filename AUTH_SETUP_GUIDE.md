# دليل إعداد المصادقة في تطبيق تهنئة

## المشاكل التي تم إصلاحها

### 1. مشكلة Firebase Duplicate App
- ✅ تم إنشاء `FirebaseService` لإدارة تهيئة Firebase بشكل آمن
- ✅ تم إنشاء `FirebaseDevHelper` للتعامل مع سيناريوهات التطوير
- ✅ تم حل مشكلة Hot Restart

### 2. مشاكل المصادقة
- ✅ تم إنشاء `AuthService` لإدارة جميع عمليات المصادقة
- ✅ تم تحسين معالجة الأخطاء مع رسائل باللغة العربية
- ✅ تم إضافة دعم Google Sign-In
- ✅ تم إضافة إعادة تعيين كلمة المرور

### 3. مشاكل التنقل
- ✅ تم إنشاء `AuthWrapper` للتحقق من حالة المصادقة تلقائياً
- ✅ تم تحسين التنقل بين الشاشات
- ✅ تم إضافة تسجيل الخروج في شاشة الإعدادات

## الملفات المُحدثة

### 1. خدمات جديدة
- `lib/services/firebase_service.dart` - إدارة Firebase
- `lib/services/auth_service.dart` - إدارة المصادقة
- `lib/core/utils/firebase_dev_helper.dart` - مساعد التطوير

### 2. واجهات محدثة
- `lib/core/widgets/auth_wrapper.dart` - مُلف المصادقة
- `lib/features/auth/login_screen.dart` - شاشة تسجيل الدخول
- `lib/features/auth/register_screen.dart` - شاشة التسجيل
- `lib/features/settings/presentation/screens/settings_screen.dart` - الإعدادات

### 3. إعدادات
- `lib/firebase_options.dart` - إعدادات Firebase محدثة
- `lib/main.dart` - نقطة البداية محدثة

## كيفية الاستخدام

### 1. تسجيل الدخول
```dart
// تسجيل دخول بالبريد وكلمة المرور
await AuthService.signInWithEmailAndPassword(
  email: email,
  password: password,
);

// تسجيل دخول بـ Google
await AuthService.signInWithGoogle();
```

### 2. إنشاء حساب جديد
```dart
await AuthService.createUserWithEmailAndPassword(
  email: email,
  password: password,
  displayName: name,
);
```

### 3. تسجيل الخروج
```dart
await AuthService.signOut();
```

### 4. التحقق من حالة المصادقة
```dart
// التحقق من تسجيل الدخول
bool isSignedIn = AuthService.isSignedIn;

// الحصول على المستخدم الحالي
User? currentUser = AuthService.currentUser;

// مراقبة تغييرات حالة المصادقة
AuthService.authStateChanges.listen((user) {
  // التعامل مع تغيير حالة المصادقة
});
```

## الميزات المضافة

### 1. معالجة الأخطاء المحسنة
- رسائل خطأ باللغة العربية
- معالجة جميع أنواع أخطاء Firebase Auth
- تسجيل مفصل في وضع التطوير

### 2. إدارة حالة المصادقة
- تحقق تلقائي من حالة تسجيل الدخول
- تنقل تلقائي بناءً على حالة المصادقة
- دعم Hot Restart بدون مشاكل

### 3. ميزات إضافية
- إرسال رابط إعادة تعيين كلمة المرور
- إرسال رابط التحقق من البريد الإلكتروني
- حذف الحساب
- تسجيل الخروج من جميع الأجهزة

## إعداد Firebase (مطلوب للإنتاج)

### 1. إنشاء مشروع Firebase
1. اذهب إلى [Firebase Console](https://console.firebase.google.com/)
2. أنشئ مشروع جديد
3. فعّل Authentication
4. أضف طرق تسجيل الدخول (Email/Password, Google)

### 2. إعداد التطبيق
1. أضف تطبيق Android/iOS إلى مشروع Firebase
2. حمّل ملف `google-services.json` (Android) أو `GoogleService-Info.plist` (iOS)
3. اتبع تعليمات FlutterFire CLI:
```bash
flutter pub global activate flutterfire_cli
flutterfire configure
```

### 3. تحديث إعدادات Firebase
بعد تشغيل `flutterfire configure`، سيتم تحديث ملف `lib/firebase_options.dart` تلقائياً بالإعدادات الصحيحة.

## اختبار التطبيق

### 1. تسجيل دخول جديد
1. افتح التطبيق
2. اضغط "سجّل الآن"
3. أدخل البيانات المطلوبة
4. تحقق من البريد الإلكتروني

### 2. تسجيل الدخول
1. أدخل البريد وكلمة المرور
2. أو استخدم تسجيل الدخول بـ Google
3. يجب أن تنتقل إلى الشاشة الرئيسية

### 3. تسجيل الخروج
1. اذهب إلى الإعدادات
2. اضغط "تسجيل الخروج"
3. يجب أن تعود إلى شاشة تسجيل الدخول

## استكشاف الأخطاء

### 1. مشكلة Firebase Duplicate App
- تم حلها تلقائياً بـ `FirebaseService`
- في حالة استمرار المشكلة، استخدم `flutter clean`

### 2. مشكلة Google Sign-In
- تأكد من إضافة SHA-1 fingerprint في Firebase Console
- تأكد من تفعيل Google Sign-In في Authentication

### 3. مشاكل التنقل
- تم حلها بـ `AuthWrapper`
- التنقل يتم تلقائياً بناءً على حالة المصادقة

## الخطوات التالية

1. **إعداد Firebase للإنتاج**: استبدال الإعدادات التجريبية بإعدادات حقيقية
2. **تحسين الأمان**: إضافة قواعد أمان Firebase
3. **إضافة ميزات**: مثل تسجيل الدخول بالهاتف، تسجيل الدخول بـ Apple
4. **اختبار شامل**: اختبار جميع السيناريوهات على أجهزة مختلفة

## الدعم

في حالة مواجهة مشاكل:
1. تحقق من سجلات التطبيق (Debug Console)
2. تأكد من إعدادات Firebase
3. راجع وثائق [FlutterFire](https://firebase.flutter.dev/)