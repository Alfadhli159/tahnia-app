class Greeting {
  final String content;
  final String provider;
  final bool isGenerated;
  final DateTime timestamp;

  const Greeting({
    required this.content,
    required this.provider,
    required this.isGenerated,
    required this.timestamp,
  });

  factory Greeting.fromAI({
    required String content,
    required String provider,
  }) {
    return Greeting(
      content: content,
      provider: provider,
      isGenerated: true,
      timestamp: DateTime.now(),
    );
  }

  factory Greeting.fallback({
    required String content,
  }) {
    return Greeting(
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

  factory Greeting.fromJson(Map<String, dynamic> json) {
    return Greeting(
      content: json['content'] as String,
      provider: json['provider'] as String,
      isGenerated: json['isGenerated'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
