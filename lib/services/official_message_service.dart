import 'package:flutter/material.dart';
import 'package:tahania_app/features/greetings/domain/enums/message_category.dart';
import 'package:tahania_app/features/greetings/domain/models/official_message.dart';

class OfficialMessageService {
  static final Map<MessageCategory, List<OfficialMessage>> _messages = {
    MessageCategory.health: [
      OfficialMessage(
        id: 'health_1',
        title: 'نصائح صحية للصيام',
        content:
            'تأكد من شرب كميات كافية من الماء بين الإفطار والسحور، وتجنب الأطعمة الدسمة والمشروبات الغازية.',
        category: MessageCategory.health,
        imageUrl: 'assets/messages/health/ramadan_health.png',
        publishDate: DateTime.now(),
        source: 'وزارة الصحة',
        tags: ['رمضان', 'صحة', 'نصائح'],
      ),
      OfficialMessage(
        id: 'health_2',
        title: 'التطعيمات الموسمية',
        content:
            'تأكد من أخذ التطعيمات الموسمية لحماية نفسك وعائلتك من الأمراض المعدية.',
        category: MessageCategory.health,
        imageUrl: 'assets/messages/health/vaccination.png',
        publishDate: DateTime.now(),
        source: 'وزارة الصحة',
        tags: ['صحة', 'تطعيمات'],
      ),
    ],
    MessageCategory.education: [
      OfficialMessage(
        id: 'education_1',
        title: 'بدء العام الدراسي',
        content:
            'نتمنى لجميع الطلاب والطالبات عاماً دراسياً موفقاً. تأكدوا من استلام الكتب المدرسية والزي المدرسي.',
        category: MessageCategory.education,
        imageUrl: 'assets/messages/education/school_start.png',
        publishDate: DateTime.now(),
        source: 'وزارة التعليم',
        tags: ['تعليم', 'عام دراسي'],
      ),
    ],
    MessageCategory.security: [
      OfficialMessage(
        id: 'security_1',
        title: 'نصائح أمنية',
        content:
            'تأكد من إغلاق الأبواب والنوافذ عند مغادرة المنزل، ولا تشارك معلوماتك الشخصية مع الغرباء.',
        category: MessageCategory.security,
        imageUrl: 'assets/messages/security/safety_tips.png',
        publishDate: DateTime.now(),
        source: 'وزارة الداخلية',
        tags: ['أمن', 'سلامة'],
      ),
    ],
    MessageCategory.social: [
      OfficialMessage(
        id: 'social_1',
        title: 'التكافل الاجتماعي',
        content:
            'شارك في مبادرات التكافل الاجتماعي ومساعدة المحتاجين في مجتمعك.',
        category: MessageCategory.social,
        imageUrl: 'assets/messages/social/solidarity.png',
        publishDate: DateTime.now(),
        source: 'وزارة الشؤون الاجتماعية',
        tags: ['اجتماعي', 'تكافل'],
      ),
    ],
    MessageCategory.environmental: [
      OfficialMessage(
        id: 'environmental_1',
        title: 'حماية البيئة',
        content:
            'ساهم في حماية البيئة من خلال ترشيد استهلاك المياه والطاقة، وإعادة تدوير النفايات.',
        category: MessageCategory.environmental,
        imageUrl: 'assets/messages/environment/protection.png',
        publishDate: DateTime.now(),
        source: 'وزارة البيئة',
        tags: ['بيئة', 'حماية'],
      ),
    ],
    MessageCategory.religious: [
      OfficialMessage(
        id: 'religious_1',
        title: 'مواقيت الصلاة',
        content:
            'تأكد من معرفة مواقيت الصلاة في منطقتك واتباع التوجيهات الصحية أثناء أداء الصلاة.',
        category: MessageCategory.religious,
        imageUrl: 'assets/messages/religious/prayer_times.png',
        publishDate: DateTime.now(),
        source: 'وزارة الشؤون الإسلامية',
        tags: ['ديني', 'صلاة'],
      ),
    ],
    MessageCategory.seasonal: [
      OfficialMessage(
        id: 'seasonal_1',
        title: 'استعدادات رمضان',
        content:
            'استعد لشهر رمضان المبارك من خلال تنظيم جدولك اليومي وشراء المستلزمات الأساسية.',
        category: MessageCategory.seasonal,
        imageUrl: 'assets/messages/seasonal/ramadan_prep.png',
        publishDate: DateTime.now(),
        source: 'وزارة الشؤون الإسلامية',
        tags: ['رمضان', 'استعدادات'],
      ),
    ],
  };

  /// الحصول على الرسائل حسب الفئة
  static List<OfficialMessage> getMessagesByCategory(MessageCategory category) {
    return _messages[category] ?? [];
  }

  /// الحصول على جميع الرسائل
  static List<OfficialMessage> getAllMessages() {
    return _messages.values.expand((messages) => messages).toList();
  }

  /// الحصول على الرسائل العاجلة
  static List<OfficialMessage> getUrgentMessages() {
    return getAllMessages().where((message) => message.isUrgent).toList();
  }

  /// الحصول على الرسائل حسب الكلمات المفتاحية
  static List<OfficialMessage> searchMessages(String query) {
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
        'type': MessageCategory.health,
        'name': 'رسائل صحية',
        'icon': Icons.health_and_safety,
        'description': 'نصائح وإرشادات صحية',
      },
      {
        'type': MessageCategory.education,
        'name': 'رسائل تعليمية',
        'icon': Icons.school,
        'description': 'إعلانات وتوجيهات تعليمية',
      },
      {
        'type': MessageCategory.security,
        'name': 'رسائل أمنية',
        'icon': Icons.security,
        'description': 'نصائح وإرشادات أمنية',
      },
      {
        'type': MessageCategory.social,
        'name': 'رسائل اجتماعية',
        'icon': Icons.people,
        'description': 'مبادرات وتوجيهات اجتماعية',
      },
      {
        'type': MessageCategory.environmental,
        'name': 'رسائل بيئية',
        'icon': Icons.eco,
        'description': 'حماية البيئة والموارد',
      },
      {
        'type': MessageCategory.religious,
        'name': 'رسائل دينية',
        'icon': Icons.mosque,
        'description': 'توجيهات وإرشادات دينية',
      },
      {
        'type': MessageCategory.seasonal,
        'name': 'رسائل موسمية',
        'icon': Icons.calendar_today,
        'description': 'رسائل خاصة بالمواسم والمناسبات',
      },
    ];
  }
}
