import 'dart:math';

class FallbackGenerator {
  static final Random _random = Random();

  static String generateGreeting(
    String prompt, {
    String? senderName,
    String? recipientName,
    String? messageType,
    String? occasion,
    String? purpose,
  }) {
    // استخدام المعاملات المرسلة أو تحليل النص
    String type = messageType ?? _analyzeMessageType(prompt);
    String occasionText = occasion ?? _analyzeOccasion(prompt);
    String purposeText = purpose ?? _analyzePurpose(prompt);
    
    // اسم المرسل والمستلم
    String sender = senderName ?? '';
    String recipient = recipientName ?? 'المستلم الكريم';

    // اختيار قالب مناسب حسب النوع والمناسبة والغرض
    String greeting = _selectAppropriateGreeting(type, occasionText, purposeText);

    // استبدال المتغيرات
    greeting = _replaceVariables(greeting, occasionText, recipient);

    // إضافة توقيع باسم المرسل إن وجد
    if (sender.isNotEmpty) {
      greeting += '\n\n— $sender';
    }

    return greeting;
  }

  static String _analyzeMessageType(String prompt) {
    final types = {
      'تعزية': ['تعزية', 'وفاة', 'عزاء', 'مواساة', 'فقدان'],
      'مهنية': ['مهنية', 'عمل', 'وظيفة', 'ترقية', 'شركة'],
      'عائلية': ['عائلية', 'أسرة', 'زواج', 'خطوبة', 'مولود'],
      'دينية': ['دينية', 'عيد', 'رمضان', 'حج', 'عمرة'],
      'وطنية': ['وطنية', 'اليوم الوطني', 'سعودية'],
      'مدرسية': ['مدرسية', 'تخرج', 'نجاح', 'دراسة'],
    };

    for (final entry in types.entries) {
      for (final keyword in entry.value) {
        if (prompt.toLowerCase().contains(keyword)) {
          return entry.key;
        }
      }
    }
    return 'عائلية'; // افتراضي
  }

  static String _analyzeOccasion(String prompt) {
    final occasions = {
      'وفاة': ['وفاة', 'توفي', 'فقدان', 'رحيل'],
      'زواج': ['زواج', 'عرس', 'زفاف'],
      'خطوبة': ['خطوبة', 'خطبة', 'ملكة'],
      'مولود': ['مولود', 'ولادة', 'طفل', 'مولودة'],
      'نجاح': ['نجاح', 'تفوق', 'امتياز'],
      'تخرج': ['تخرج', 'تخرجت', 'شهادة'],
      'ترقية': ['ترقية', 'منصب', 'وظيفة جديدة'],
    };
    
    for (final entry in occasions.entries) {
      for (final keyword in entry.value) {
        if (prompt.toLowerCase().contains(keyword)) {
          return entry.key;
        }
      }
    }
    return 'المناسبة'; // افتراضي
  }

  static String _analyzePurpose(String prompt) {
    final purposes = {
      'تعزية': ['تعزية', 'مواساة', 'عزاء'],
      'تهنئة': ['تهنئة', 'مبارك', 'تبريك'],
      'تشجيع': ['تشجيع', 'دعم', 'تحفيز'],
      'دعاء': ['دعاء', 'دعوة', 'بركة'],
    };

    for (final entry in purposes.entries) {
      for (final keyword in entry.value) {
        if (prompt.toLowerCase().contains(keyword)) {
          return entry.key;
        }
      }
    }
    return 'تهنئة'; // افتراضي
  }

  static String _selectAppropriateGreeting(String type, String occasion, String purpose) {
    // قوالب التعزية
    if (type == 'تعزية' || purpose == 'تعزية') {
      return _getCondolenceTemplates()[_random.nextInt(_getCondolenceTemplates().length)];
    }
    
    // قوالب حسب النوع والمناسبة
    final templates = _getTemplatesByTypeAndOccasion(type, occasion);
    if (templates.isNotEmpty) {
      return templates[_random.nextInt(templates.length)];
    }
    
    // قالب افتراضي
    return _getDefaultTemplates()[_random.nextInt(_getDefaultTemplates().length)];
  }

  static List<String> _getCondolenceTemplates() {
    return [
      'السلام عليكم ورحمة الله وبركاته\n\n{recipient}\n\nإنا لله وإنا إليه راجعون، تلقيت نبأ الوفاة بحزن بالغ، وأتقدم إليكم بأصدق عبارات المواساة والعزاء.\n\nأسأل الله العلي القدير أن يتغمد الفقيد بواسع رحمته ومغفرته، وأن يسكنه فسيح جناته، وأن يلهمكم الصبر والسلوان.\n\nإن الموت حق على كل نفس، وما نحن إلا في دار ممر إلى دار مقر، فاصبروا واحتسبوا الأجر عند الله.',
      'بسم الله الرحمن الرحيم\n\n{recipient}\n\nبقلوب مؤمنة بقضاء الله وقدره، نتقدم إليكم بأحر التعازي وأصدق المواساة في فقيدكم الغالي.\n\nنسأل الله أن يرحم الفقيد ويغفر له، وأن يسكنه الفردوس الأعلى، وأن يصبركم ويقويكم على هذا المصاب الجلل.\n\nتذكروا أن الصبر مفتاح الفرج، وأن الله مع الصابرين.',
      'السلام عليكم ورحمة الله وبركاته\n\n{recipient}\n\nبمشاعر الحزن والأسى، تلقينا نبأ الوفاة، ونتقدم إليكم بخالص التعازي وصادق المواساة.\n\nندعو الله أن يرحم الفقيد ويغفر له، وأن يجعل قبره روضة من رياض الجنة، وأن يعوضكم خيراً ويصبركم على هذا الفراق.',
    ];
  }

  static List<String> _getTemplatesByTypeAndOccasion(String type, String occasion) {
    final templates = <String, Map<String, List<String>>>{
      'عائلية': {
        'زواج': [
          'مع خالص التحية والتقدير\n\n{recipient}\n\nأسعدني أن أتقدم إليكم بأطيب التهاني وأجمل التبريكات بمناسبة الزواج المبارك.\n\nأسأل الله أن يبارك لكما ويبارك عليكما، وأن يجمع بينكما في خير، وأن يرزقكما السعادة والهناء.\n\nتمنياتي لكما بحياة زوجية سعيدة مليئة بالمحبة والوئام.',
          'السلام عليكم ورحمة الله وبركاته\n\n{recipient}\n\nبمناسبة الزواج السعيد، أتقدم بأحر التهاني وأطيب الأماني.\n\nبارك الله لكما وبارك عليكما وجمع بينكما في خير، وجعل حياتكما مليئة بالسعادة والبركة.\n\nألف مبروك وعقبال مائة سنة بالخير والعافية.',
        ],
        'خطوبة': [
          'مع خالص التحية والتقدير\n\n{recipient}\n\nيسعدني أن أهنئكم بمناسبة الخطوبة المباركة، وأتمنى لكم حياة سعيدة مليئة بالفرح والسرور.\n\nأسأل الله أن يبارك هذه الخطوة وأن يكتب لكم السعادة والتوفيق.\n\nألف مبروك وبالرفاه والبنين.',
          'السلام عليكم ورحمة الله وبركاته\n\n{recipient}\n\nبمناسبة الخطوبة السعيدة، أرسل لكم أطيب التهاني وأجمل الأماني.\n\nبارك الله لكم وأتم عليكم بالخير والبركة، وجعل هذه بداية حياة سعيدة مليئة بالمحبة والوئام.',
        ],
        'مولود': [
          'مع خالص التحية والتقدير\n\n{recipient}\n\nأسعدني خبر قدوم المولود الجديد، وأتقدم بأحر التهاني وأطيب الأماني.\n\nبارك الله لكم في المولود وبارك لكم فيه، وأنبته نباتاً حسناً، وجعله من الصالحين البررة.\n\nألف مبروك وعقبال ما نفرح بنجاحه وتفوقه.',
        ],
      },
      'مهنية': {
        'ترقية': [
          'مع خالص التحية والتقدير\n\n{recipient}\n\nيسرني أن أتقدم إليكم بأحر التهاني بمناسبة الترقية المستحقة.\n\nهذا الإنجاز ثمرة جهدكم المتواصل وتفانيكم في العمل، وأتمنى لكم مزيداً من التقدم والنجاح.\n\nبارك الله لكم وأعانكم على تحمل المسؤوليات الجديدة.',
        ],
        'نجاح': [
          'مع خالص التحية والتقدير\n\n{recipient}\n\nأتقدم بأطيب التهاني بمناسبة النجاح المتميز.\n\nهذا الإنجاز يعكس جهدكم وتفانيكم، وأتمنى لكم مزيداً من التفوق والنجاح.\n\nألف مبروك وإلى الأمام دائماً.',
        ],
      },
    };

    if (templates.containsKey(type) && templates[type]!.containsKey(occasion)) {
      return templates[type]![occasion]!;
    }
    
    return [];
  }

  static List<String> _getDefaultTemplates() {
    return [
      'مع خالص التحية والتقدير\n\n{recipient}\n\nأتقدم إليكم بأطيب التهاني وأجمل الأماني بمناسبة {occasion}.\n\nأسأل الله أن يديم عليكم الفرح والسعادة، وأن يبارك لكم في كل خطوة.\n\nتمنياتي لكم بالتوفيق والنجاح.',
      'السلام عليكم ورحمة الله وبركاته\n\n{recipient}\n\nبمناسبة {occasion}، أرسل لكم أحر التهاني وأطيب الأماني.\n\nبارك الله لكم وأتم عليكم بالخير والبركة.\n\nألف مبروك وعقبال المزيد من الأفراح.',
    ];
  }

  static String _replaceVariables(String greeting, String occasion, String recipient) {
    return greeting
        .replaceAll('{occasion}', occasion.isNotEmpty ? occasion : 'المناسبة')
        .replaceAll('{recipient}', recipient.isNotEmpty ? recipient : 'المستلم الكريم');
  }
}
