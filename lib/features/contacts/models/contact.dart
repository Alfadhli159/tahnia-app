import 'package:flutter/material.dart';

class AppContact {
  final String id;
  final String name;
  final String? phoneNumber;
  final String? email;
  final String? photoUrl;
  final List<String> groups;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime? lastContacted;
  final Map<String, dynamic>? metadata;

  AppContact({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.email,
    this.photoUrl,
    this.groups = const [],
    this.isFavorite = false,
    required this.createdAt,
    this.lastContacted,
    this.metadata,
  });

  factory AppContact.fromJson(Map<String, dynamic> json) {
    return AppContact(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      photoUrl: json['photoUrl'] as String?,
      groups: List<String>.from(json['groups'] as List? ?? []),
      isFavorite: json['isFavorite'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastContacted: json['lastContacted'] != null
          ? DateTime.parse(json['lastContacted'] as String)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'photoUrl': photoUrl,
      'groups': groups,
      'isFavorite': isFavorite,
      'createdAt': createdAt.toIso8601String(),
      'lastContacted': lastContacted?.toIso8601String(),
      'metadata': metadata,
    };
  }

  AppContact copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    String? photoUrl,
    List<String>? groups,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? lastContacted,
    Map<String, dynamic>? metadata,
  }) {
    return AppContact(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      groups: groups ?? this.groups,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      lastContacted: lastContacted ?? this.lastContacted,
      metadata: metadata ?? this.metadata,
    );
  }
} 