import 'package:flutter/material.dart';

class Sticker {
  final String id;
  final String name;
  final String path;
  final String category;
  final bool isAnimated;
  final List<String> tags;

  const Sticker({
    required this.id,
    required this.name,
    required this.path,
    required this.category,
    this.isAnimated = false,
    this.tags = const [],
  });

  Widget loadWidget() {
    if (isAnimated) {
      // TODO: Implement Lottie animation loading
      return Image.asset(path);
    } else {
      return Image.asset(path);
    }
  }

  Sticker copyWith({
    String? id,
    String? name,
    String? path,
    String? category,
    bool? isAnimated,
    List<String>? tags,
  }) {
    return Sticker(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      category: category ?? this.category,
      isAnimated: isAnimated ?? this.isAnimated,
      tags: tags ?? this.tags,
    );
  }
}
