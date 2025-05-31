import 'package:flutter/material.dart';

// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
// class Greeting {
  final String id;
  final String content;
  final String category;
  final DateTime createdAt;
  final DateTime? scheduledFor;
  final List<String> recipientIds;
  final bool isSent;
  final String? imageUrl;
  final Map<String, dynamic>? metadata;

// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//   Greeting({
    required this.id,
    required this.content,
    required this.category,
    required this.createdAt,
    this.scheduledFor,
    required this.recipientIds,
    this.isSent = false,
    this.imageUrl,
    this.metadata,
  });

// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//   factory Greeting.fromJson(Map<String, dynamic> json) {
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//     return Greeting(
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
    };
  }

// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//   Greeting copyWith({
    String? id,
    String? content,
    String? category,
    DateTime? createdAt,
    DateTime? scheduledFor,
    List<String>? recipientIds,
    bool? isSent,
    String? imageUrl,
    Map<String, dynamic>? metadata,
  }) {
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//     return Greeting(
      id: id ?? this.id,
      content: content ?? this.content,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      recipientIds: recipientIds ?? this.recipientIds,
      isSent: isSent ?? this.isSent,
      imageUrl: imageUrl ?? this.imageUrl,
      metadata: metadata ?? this.metadata,
    );
  }
} 