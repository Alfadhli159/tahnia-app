class AppConstants {
  // أسماء الصفحات
  static const String homePageTitle = 'الرئيسية';
  static const String autoReplyPageTitle = 'الرد التلقائي';
  static const String scheduledMessagesPageTitle = 'الرسائل المجدولة';
  static const String templatesPageTitle = 'قوالب الرسائل';
  static const String settingsPageTitle = 'الإعدادات';

  // رسائل النظام
  static const String appName = 'Tahania App';
  static const String loadingMessage = 'جاري التحميل...';
  static const String errorMessage = 'حدث خطأ ما';
  static const String successMessage = 'تمت العملية بنجاح';
  static const String confirmDeleteMessage = 'هل أنت متأكد من الحذف؟';
  static const String noDataMessage = 'لا توجد بيانات';
  static const String searchHint = 'بحث...';
  static const String saveButtonText = 'حفظ';
  static const String cancelButtonText = 'إلغاء';
  static const String deleteButtonText = 'حذف';
  static const String editButtonText = 'تعديل';
  static const String addButtonText = 'إضافة';
  static const String resetButtonText = 'إعادة تعيين';

  // فئات القوالب
  static const List<String> templateCategories = [
    'الكل',
    'ترحيب',
    'شكر',
    'اعتذار',
    'تأكيد',
    'متابعة',
    'أخرى',
  ];

  // وسوم القوالب
  static const List<String> templateTags = [
    'مهم',
    'عاجل',
    'متابعة',
    'تأكيد',
    'شكر',
  ];

  // أنماط التكرار
  static const List<String> repeatPatterns = [
    'لا يوجد',
    'يومي',
    'أسبوعي',
    'شهري',
  ];

  // أيام الأسبوع
  static const List<String> weekDays = [
    'الأحد',
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
  ];

  // أنواع المشاعر
  static const List<String> sentimentTypes = [
    'إيجابي',
    'محايد',
    'سلبي',
  ];

  // أنواع الإشعارات
  static const List<String> notificationTypes = [
    'الكل',
    'رسائل جديدة',
    'ردود تلقائية',
    'رسائل مجدولة',
    'تحديثات النظام',
  ];

  // إعدادات التطبيق
  static const String settingsGeneral = 'عام';
  static const String settingsAppearance = 'المظهر';
  static const String settingsNotifications = 'الإشعارات';
  static const String settingsPrivacy = 'الخصوصية';
  static const String settingsBackup = 'النسخ الاحتياطي';
  static const String settingsPerformance = 'الأداء';
  static const String settingsLanguage = 'اللغة';
  static const String settingsSecurity = 'الأمان';
  static const String settingsCustomization = 'التخصيص';
  static const String settingsIntegration = 'التكامل';
  static const String settingsReporting = 'التقارير';

  // قيم افتراضية
  static const int defaultNotificationDelay = 5; // دقائق
  static const int maxRetryAttempts = 3;
  static const int maxMessageLength = 1000;
  static const int maxTemplateLength = 500;
  static const int maxScheduledMessages = 100;
  static const int maxTemplates = 50;

  // مفاتيح التخزين
  static const String storageKeyTemplates = 'message_templates';
  static const String storageKeyScheduledMessages = 'scheduled_messages';
  static const String storageKeySettings = 'app_settings';
  static const String storageKeyAutoReply = 'auto_reply_settings';
  static const String storageKeyUserData = 'user_data';

  // روابط API
  static const String apiBaseUrl = 'https://api.tahania.com';
  static const String apiVersion = 'v1';
  static const String apiEndpointTemplates = '/templates';
  static const String apiEndpointMessages = '/messages';
  static const String apiEndpointSettings = '/settings';
  static const String apiEndpointUsers = '/users';

  // رسائل الخطأ
  static const String errorNetwork = 'خطأ في الاتصال بالشبكة';
  static const String errorServer = 'خطأ في الخادم';
  static const String errorAuth = 'خطأ في المصادقة';
  static const String errorValidation = 'خطأ في التحقق من البيانات';
  static const String errorNotFound = 'لم يتم العثور على البيانات';
  static const String errorPermission = 'ليس لديك الصلاحية الكافية';
  static const String errorUnknown = 'خطأ غير معروف';

  // رسائل النجاح
  static const String successSave = 'تم الحفظ بنجاح';
  static const String successDelete = 'تم الحذف بنجاح';
  static const String successUpdate = 'تم التحديث بنجاح';
  static const String successAdd = 'تمت الإضافة بنجاح';
  static const String successImport = 'تم الاستيراد بنجاح';
  static const String successExport = 'تم التصدير بنجاح';
  static const String successReset = 'تم إعادة التعيين بنجاح';

  // رسائل التأكيد
  static const String confirmDelete = 'هل أنت متأكد من حذف هذا العنصر؟';
  static const String confirmReset = 'هل أنت متأكد من إعادة تعيين الإعدادات؟';
  static const String confirmLogout = 'هل أنت متأكد من تسجيل الخروج؟';
  static const String confirmDiscard = 'هل أنت متأكد من تجاهل التغييرات؟';
  static const String confirmClear = 'هل أنت متأكد من مسح جميع البيانات؟';
} 