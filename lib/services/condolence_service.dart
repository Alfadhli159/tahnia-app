import 'package:tahania_app/services/smart_greeting_service.dart';

enum RelationshipType {
  immediateFamily, // العائلة المباشرة (الوالدين، الإخوة، الأبناء)
  extendedFamily, // العائلة الممتدة (الأعمام، الأخوال، العمات، الخالات)
  closeFriend, // الأصدقاء المقربين
  colleague, // الزملاء
  neighbor, // الجيران
  acquaintance, // المعارف
  general, // عام
}

class CondolenceService {
  static final Map<RelationshipType, List<String>> _condolenceTemplates = {
    RelationshipType.immediateFamily: [
      'ببالغ الحزن والأسى نعزي أنفسنا وأسرتنا الكريمة بوفاة {recipient}، نسأل الله أن يتغمده بواسع رحمته ويسكنه فسيح جناته، وأن يلهمكم الصبر والسلوان، إنا لله وإنا إليه راجعون.',
      'بقلوب مؤمنة بقضاء الله وقدره، نتقدم بأحر التعازي وأصدق المواساة بوفاة {recipient}، نسأل الله أن يتقبله في الصالحين وأن يجعله من أهل الجنة، وأن يلهمكم الصبر والسلوان.',
      'ببالغ الحزن والأسى نتقدم بأحر التعازي وأصدق المواساة بوفاة {recipient}، نسأل الله أن يتغمده بواسع رحمته ويسكنه فسيح جناته، وأن يلهمكم الصبر والسلوان، إنا لله وإنا إليه راجعون.',
    ],
    RelationshipType.extendedFamily: [
      'ببالغ الحزن والأسى نتقدم بأحر التعازي وأصدق المواساة بوفاة {recipient}، نسأل الله أن يتغمده بواسع رحمته ويسكنه فسيح جناته، وأن يلهمكم الصبر والسلوان.',
      'بقلوب مؤمنة بقضاء الله وقدره، نتقدم بأحر التعازي وأصدق المواساة بوفاة {recipient}، نسأل الله أن يتقبله في الصالحين وأن يجعله من أهل الجنة.',
      'نتقدم بأحر التعازي وأصدق المواساة بوفاة {recipient}، نسأل الله أن يتغمده بواسع رحمته ويسكنه فسيح جناته، وأن يلهمكم الصبر والسلوان.',
    ],
    RelationshipType.closeFriend: [
      'ببالغ الحزن والأسى نتقدم بأحر التعازي وأصدق المواساة بوفاة {recipient}، نسأل الله أن يتغمده بواسع رحمته ويسكنه فسيح جناته.',
      'بقلوب مؤمنة بقضاء الله وقدره، نتقدم بأحر التعازي وأصدق المواساة بوفاة {recipient}، نسأل الله أن يتقبله في الصالحين.',
      'نتقدم بأحر التعازي وأصدق المواساة بوفاة {recipient}، نسأل الله أن يتغمده بواسع رحمته ويسكنه فسيح جناته.',
    ],
    RelationshipType.colleague: [
      'نتقدم بأحر التعازي وأصدق المواساة بوفاة {recipient}، نسأل الله أن يتغمده بواسع رحمته ويسكنه فسيح جناته.',
      'بقلوب مؤمنة بقضاء الله وقدره، نتقدم بأحر التعازي وأصدق المواساة بوفاة {recipient}، نسأل الله أن يتقبله في الصالحين.',
      'نتقدم بأحر التعازي وأصدق المواساة بوفاة {recipient}، نسأل الله أن يتغمده بواسع رحمته.',
    ],
    RelationshipType.neighbor: [
      'نتقدم بأحر التعازي وأصدق المواساة بوفاة {recipient}، نسأل الله أن يتغمده بواسع رحمته ويسكنه فسيح جناته.',
      'بقلوب مؤمنة بقضاء الله وقدره، نتقدم بأحر التعازي وأصدق المواساة بوفاة {recipient}، نسأل الله أن يتقبله في الصالحين.',
      'نتقدم بأحر التعازي وأصدق المواساة بوفاة {recipient}، نسأل الله أن يتغمده بواسع رحمته.',
    ],
    RelationshipType.acquaintance: [
      'نتقدم بأحر التعازي وأصدق المواساة بوفاة {recipient}، نسأل الله أن يتغمده بواسع رحمته.',
      'بقلوب مؤمنة بقضاء الله وقدره، نتقدم بأحر التعازي وأصدق المواساة بوفاة {recipient}.',
      'نتقدم بأحر التعازي وأصدق المواساة بوفاة {recipient}، نسأل الله أن يتغمده بواسع رحمته.',
    ],
    RelationshipType.general: [
      'نتقدم بأحر التعازي وأصدق المواساة بوفاة {recipient}، نسأل الله أن يتغمده بواسع رحمته.',
      'بقلوب مؤمنة بقضاء الله وقدره، نتقدم بأحر التعازي وأصدق المواساة بوفاة {recipient}.',
      'نتقدم بأحر التعازي وأصدق المواساة بوفاة {recipient}، نسأل الله أن يتغمده بواسع رحمته.',
    ],
  };

  /// اقتراح تعزية مخصصة حسب درجة القرابة
  static Future<SmartGreeting> suggestCondolence({
    required String recipient,
    required String sender,
    required RelationshipType relationship,
    String locale = 'ar',
    bool useAI = false,
  }) async {
    final templates = _condolenceTemplates[relationship] ?? _condolenceTemplates[RelationshipType.general]!;
    final template = templates[DateTime.now().millisecondsSinceEpoch % templates.length];
    
    String message = template.replaceAll('{recipient}', recipient);
    
    if (useAI) {
      // استخدام الذكاء الاصطناعي لتخصيص التعزية
      message = await SmartGreetingService.suggestGreeting(
        occasion: 'تعزية',
        recipient: recipient,
        sender: sender,
        locale: locale,
        useAI: true,
        relationship: relationship.toString(),
      );
    }

    // إضافة استيكر تعزية مناسب
    final media = await SmartGreetingService._getGreetingMedia('condolence');

    return SmartGreeting(
      text: message,
      mediaUrl: media['url'],
      mediaType: media['type'],
    );
  }

  /// الحصول على قائمة درجات القرابة
  static List<Map<String, dynamic>> getRelationshipTypes() {
    return [
      {
        'type': RelationshipType.immediateFamily,
        'name': 'عائلة مباشرة',
        'description': 'الوالدين، الإخوة، الأبناء',
      },
      {
        'type': RelationshipType.extendedFamily,
        'name': 'عائلة ممتدة',
        'description': 'الأعمام، الأخوال، العمات، الخالات',
      },
      {
        'type': RelationshipType.closeFriend,
        'name': 'صديق مقرب',
        'description': 'الأصدقاء المقربين',
      },
      {
        'type': RelationshipType.colleague,
        'name': 'زميل',
        'description': 'الزملاء في العمل',
      },
      {
        'type': RelationshipType.neighbor,
        'name': 'جار',
        'description': 'الجيران',
      },
      {
        'type': RelationshipType.acquaintance,
        'name': 'معارف',
        'description': 'المعارف والأصدقاء',
      },
      {
        'type': RelationshipType.general,
        'name': 'عام',
        'description': 'تعزية عامة',
      },
    ];
  }
} 