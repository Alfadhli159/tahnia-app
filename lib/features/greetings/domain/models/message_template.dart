class MessageTemplate {
  final String id;
  final String name;
  final String content;
  final String category;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isFavorite;

  const MessageTemplate({
    required this.id,
    required this.name,
    required this.content,
    required this.category,
    this.tags = const [],
    required this.createdAt,
    this.updatedAt,
    this.isFavorite = false,
  });

  MessageTemplate copyWith({
    String? id,
    String? name,
    String? content,
    String? category,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
  }) => MessageTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      content: content ?? this.content,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
}
