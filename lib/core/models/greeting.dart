// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
// class Greeting {
  final String content;
  final String provider;
  final bool isGenerated;
  final DateTime timestamp;

// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//   const Greeting({
    required this.content,
    required this.provider,
    required this.isGenerated,
    required this.timestamp,
  });

// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//   factory Greeting.fromAI({
    required String content,
    required String provider,
  }) {
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//     return Greeting(
      content: content,
      provider: provider,
      isGenerated: true,
      timestamp: DateTime.now(),
    );
  }

// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//   factory Greeting.fallback({
    required String content,
  }) {
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//     return Greeting(
      content: content,
      provider: 'fallback',
      isGenerated: false,
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'provider': provider,
      'isGenerated': isGenerated,
      'timestamp': timestamp.toIso8601String(),
    };
  }

// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//   factory Greeting.fromJson(Map<String, dynamic> json) {
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//     return Greeting(
      content: json['content'] as String,
      provider: json['provider'] as String,
      isGenerated: json['isGenerated'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
