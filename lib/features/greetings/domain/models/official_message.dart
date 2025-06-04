import 'package:tahania_app/features/greetings/domain/enums/message_category.dart';

class OfficialMessage {
  final String id;
  final String title;
  final String content;
  final MessageCategory category;
  final String? imageUrl;
  final String? videoUrl;
  final DateTime publishDate;
  final String source;
  final bool isUrgent;
  final List<String> tags;

  const OfficialMessage({
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

  OfficialMessage copyWith({
    String? id,
    String? title,
    String? content,
    MessageCategory? category,
    String? imageUrl,
    String? videoUrl,
    DateTime? publishDate,
    String? source,
    bool? isUrgent,
    List<String>? tags,
  }) => OfficialMessage(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      publishDate: publishDate ?? this.publishDate,
      source: source ?? this.source,
      isUrgent: isUrgent ?? this.isUrgent,
      tags: tags ?? this.tags,
    );
}
