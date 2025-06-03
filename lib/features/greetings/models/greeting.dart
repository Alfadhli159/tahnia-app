class Greeting {
  final String id;
  final String content;
  final String category;
  final DateTime createdAt;
  final DateTime? scheduledFor;
  final List<String> recipientIds;
  final bool isSent;
  final String? imageUrl;
  final Map<String, dynamic>? metadata;
  final String? provider;
  final bool isGenerated;

  Greeting({
    required this.id,
    required this.content,
    required this.category,
    required this.createdAt,
    this.scheduledFor,
    required this.recipientIds,
    this.isSent = false,
    this.imageUrl,
    this.metadata,
    this.provider,
    this.isGenerated = false,
  });

  /// Constructor for AI-generated greetings
  factory Greeting.fromAI({
    required String content,
    required String provider,
    String? category,
    List<String>? recipientIds,
  }) {
    return Greeting(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      category: category ?? 'ai_generated',
      createdAt: DateTime.now(),
      recipientIds: recipientIds ?? [],
      provider: provider,
      isGenerated: true,
    );
  }

  /// Constructor for fallback greetings
  factory Greeting.fallback({
    required String content,
    String? category,
    List<String>? recipientIds,
  }) {
    return Greeting(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      category: category ?? 'fallback',
      createdAt: DateTime.now(),
      recipientIds: recipientIds ?? [],
      provider: 'fallback',
      isGenerated: false,
    );
  }

  factory Greeting.fromJson(Map<String, dynamic> json) {
    return Greeting(
      id: json['id'] as String,
      content: json['content'] as String,
      category: json['category'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      scheduledFor: json['scheduledFor'] != null
          ? DateTime.parse(json['scheduledFor'] as String)
          : null,
      recipientIds: List<String>.from(json['recipientIds'] as List),
      isSent: json['isSent'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      provider: json['provider'] as String?,
      isGenerated: json['isGenerated'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'scheduledFor': scheduledFor?.toIso8601String(),
      'recipientIds': recipientIds,
      'isSent': isSent,
      'imageUrl': imageUrl,
      'metadata': metadata,
      'provider': provider,
      'isGenerated': isGenerated,
    };
  }

  Greeting copyWith({
    String? id,
    String? content,
    String? category,
    DateTime? createdAt,
    DateTime? scheduledFor,
    List<String>? recipientIds,
    bool? isSent,
    String? imageUrl,
    Map<String, dynamic>? metadata,
    String? provider,
    bool? isGenerated,
  }) {
    return Greeting(
      id: id ?? this.id,
      content: content ?? this.content,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      recipientIds: recipientIds ?? this.recipientIds,
      isSent: isSent ?? this.isSent,
      imageUrl: imageUrl ?? this.imageUrl,
      metadata: metadata ?? this.metadata,
      provider: provider ?? this.provider,
      isGenerated: isGenerated ?? this.isGenerated,
    );
  }
}
