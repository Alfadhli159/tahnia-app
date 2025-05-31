import 'package:flutter/material.dart';
// تم تعليق هذا الاستيراد تلقائياً: import 'package:tahania_app/services/smart_greeting_service.dart';

// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
// enum MessageCategory {
  health, // رسائل صحية
  education, // رسائل تعليمية
  security, // رسائل أمنية
  social, // رسائل اجتماعية
  environmental, // رسائل بيئية
  religious, // رسائل دينية
  seasonal, // رسائل موسمية
  general, // رسائل عامة
}

// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
// class OfficialMessage {
  final String id;
  final String title;
  final String content;
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//   final MessageCategory category;
  final String? imageUrl;
  final String? videoUrl;
  final DateTime publishDate;
  final String source;
  final bool isUrgent;
  final List<String> tags;

// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//   const OfficialMessage({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.imageUrl,
    this.videoUrl,
    required this.publishDate,
    required this.source,
    this.isUrgent = false,
    this.tags = const [],
  });
}

// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
// class OfficialMessageService {
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//   static final Map<MessageCategory, List<OfficialMessage>> _messages = {
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//     MessageCategory.health: [
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//       OfficialMessage(
        id: 'health_1',
        title: 'نصائح صحية للصيام',
        content: 'تأكد من شرب كميات كافية من الماء بين الإفطار والسحور، وتجنب الأطعمة الدسمة والمشروبات الغازية.',
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//         category: MessageCategory.health,
        imageUrl: 'assets/messages/health/ramadan_health.png',
        publishDate: DateTime.now(),
        source: 'وزارة الصحة',
        tags: ['رمضان', 'صحة', 'نصائح'],
      ),
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//       OfficialMessage(
        id: 'health_2',
        title: 'التطعيمات الموسمية',
        content: 'تأكد من أخذ التطعيمات الموسمية لحماية نفسك وعائلتك من الأمراض المعدية.',
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//         category: MessageCategory.health,
        imageUrl: 'assets/messages/health/vaccination.png',
        publishDate: DateTime.now(),
        source: 'وزارة الصحة',
        tags: ['صحة', 'تطعيمات'],
      ),
    ],
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//     MessageCategory.education: [
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//       OfficialMessage(
        id: 'education_1',
        title: 'بدء العام الدراسي',
        content: 'نتمنى لجميع الطلاب والطالبات عاماً دراسياً موفقاً. تأكدوا من استلام الكتب المدرسية والزي المدرسي.',
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//         category: MessageCategory.education,
        imageUrl: 'assets/messages/education/school_start.png',
        publishDate: DateTime.now(),
        source: 'وزارة التعليم',
        tags: ['تعليم', 'عام دراسي'],
      ),
    ],
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//     MessageCategory.security: [
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//       OfficialMessage(
        id: 'security_1',
        title: 'نصائح أمنية',
        content: 'تأكد من إغلاق الأبواب والنوافذ عند مغادرة المنزل، ولا تشارك معلوماتك الشخصية مع الغرباء.',
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//         category: MessageCategory.security,
        imageUrl: 'assets/messages/security/safety_tips.png',
        publishDate: DateTime.now(),
        source: 'وزارة الداخلية',
        tags: ['أمن', 'سلامة'],
      ),
    ],
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//     MessageCategory.social: [
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//       OfficialMessage(
        id: 'social_1',
        title: 'التكافل الاجتماعي',
        content: 'شارك في مبادرات التكافل الاجتماعي ومساعدة المحتاجين في مجتمعك.',
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//         category: MessageCategory.social,
        imageUrl: 'assets/messages/social/solidarity.png',
        publishDate: DateTime.now(),
        source: 'وزارة الشؤون الاجتماعية',
        tags: ['اجتماعي', 'تكافل'],
      ),
    ],
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//     MessageCategory.environmental: [
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//       OfficialMessage(
        id: 'environmental_1',
        title: 'حماية البيئة',
        content: 'ساهم في حماية البيئة من خلال ترشيد استهلاك المياه والطاقة، وإعادة تدوير النفايات.',
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//         category: MessageCategory.environmental,
        imageUrl: 'assets/messages/environment/protection.png',
        publishDate: DateTime.now(),
        source: 'وزارة البيئة',
        tags: ['بيئة', 'حماية'],
      ),
    ],
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//     MessageCategory.religious: [
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//       OfficialMessage(
        id: 'religious_1',
        title: 'مواقيت الصلاة',
        content: 'تأكد من معرفة مواقيت الصلاة في منطقتك واتباع التوجيهات الصحية أثناء أداء الصلاة.',
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//         category: MessageCategory.religious,
        imageUrl: 'assets/messages/religious/prayer_times.png',
        publishDate: DateTime.now(),
        source: 'وزارة الشؤون الإسلامية',
        tags: ['ديني', 'صلاة'],
      ),
    ],
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//     MessageCategory.seasonal: [
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//       OfficialMessage(
        id: 'seasonal_1',
        title: 'استعدادات رمضان',
        content: 'استعد لشهر رمضان المبارك من خلال تنظيم جدولك اليومي وشراء المستلزمات الأساسية.',
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//         category: MessageCategory.seasonal,
        imageUrl: 'assets/messages/seasonal/ramadan_prep.png',
        publishDate: DateTime.now(),
        source: 'وزارة الشؤون الإسلامية',
        tags: ['رمضان', 'استعدادات'],
      ),
    ],
  };

  /// الحصول على الرسائل حسب الفئة
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//   static List<OfficialMessage> getMessagesByCategory(MessageCategory category) {
    return _messages[category] ?? [];
  }

  /// الحصول على جميع الرسائل
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//   static List<OfficialMessage> getAllMessages() {
    return _messages.values.expand((messages) => messages).toList();
  }

  /// الحصول على الرسائل العاجلة
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//   static List<OfficialMessage> getUrgentMessages() {
    return getAllMessages().where((message) => message.isUrgent).toList();
  }

  /// الحصول على الرسائل حسب الكلمات المفتاحية
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//   static List<OfficialMessage> searchMessages(String query) {
    final lowercaseQuery = query.toLowerCase();
    return getAllMessages().where((message) {
      return message.title.toLowerCase().contains(lowercaseQuery) ||
          message.content.toLowerCase().contains(lowercaseQuery) ||
          message.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  /// الحصول على قائمة الفئات
  static List<Map<String, dynamic>> getCategories() {
    return [
      {
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//         'type': MessageCategory.health,
        'name': 'رسائل صحية',
        'icon': Icons.health_and_safety,
        'description': 'نصائح وإرشادات صحية',
      },
      {
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//         'type': MessageCategory.education,
        'name': 'رسائل تعليمية',
        'icon': Icons.school,
        'description': 'إعلانات وتوجيهات تعليمية',
      },
      {
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//         'type': MessageCategory.security,
        'name': 'رسائل أمنية',
        'icon': Icons.security,
        'description': 'نصائح وإرشادات أمنية',
      },
      {
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//         'type': MessageCategory.social,
        'name': 'رسائل اجتماعية',
        'icon': Icons.people,
        'description': 'مبادرات وتوجيهات اجتماعية',
      },
      {
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//         'type': MessageCategory.environmental,
        'name': 'رسائل بيئية',
        'icon': Icons.eco,
        'description': 'حماية البيئة والموارد',
      },
      {
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//         'type': MessageCategory.religious,
        'name': 'رسائل دينية',
        'icon': Icons.mosque,
        'description': 'توجيهات وإرشادات دينية',
      },
      {
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//         'type': MessageCategory.seasonal,
        'name': 'رسائل موسمية',
        'icon': Icons.calendar_today,
        'description': 'رسائل خاصة بالمواسم والمناسبات',
      },
    ];
  }
} 