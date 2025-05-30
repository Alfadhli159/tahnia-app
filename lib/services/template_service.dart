import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MessageTemplate {
  final String id;
  final String name;
  final String content;
  final String category;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;

  MessageTemplate({
    required this.id,
    required this.name,
    required this.content,
    required this.category,
    this.isFavorite = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'content': content,
      'category': category,
      'isFavorite': isFavorite,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory MessageTemplate.fromJson(Map<String, dynamic> json) {
    return MessageTemplate(
      id: json['id'],
      name: json['name'],
      content: json['content'],
      category: json['category'],
      isFavorite: json['isFavorite'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class TemplateService {
  static const String _templatesKey = 'message_templates';
  
  static final ValueNotifier<List<MessageTemplate>> templatesNotifier = 
      ValueNotifier<List<MessageTemplate>>([]);

  static Future<void> initialize() async {
    await _loadTemplates();
    if (templatesNotifier.value.isEmpty) {
      await _createDefaultTemplates();
    }
  }

  static Future<void> _loadTemplates() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final templatesJson = prefs.getString(_templatesKey);
      
      if (templatesJson != null) {
        final List<dynamic> templatesList = json.decode(templatesJson);
        final templates = templatesList.map((json) => 
            MessageTemplate.fromJson(json)).toList();
        templatesNotifier.value = templates;
      }
    } catch (e) {
      debugPrint('Error loading templates: $e');
      templatesNotifier.value = [];
    }
  }

  static Future<void> _saveTemplates() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final templatesJson = json.encode(
        templatesNotifier.value.map((template) => template.toJson()).toList()
      );
      await prefs.setString(_templatesKey, templatesJson);
    } catch (e) {
      debugPrint('Error saving templates: $e');
    }
  }

  static Future<void> addTemplate(MessageTemplate template) async {
    final templates = List<MessageTemplate>.from(templatesNotifier.value);
    templates.add(template);
    templatesNotifier.value = templates;
    await _saveTemplates();
  }

  static Future<void> updateTemplate(MessageTemplate template) async {
    final templates = templatesNotifier.value.map((t) {
      return t.id == template.id ? template : t;
    }).toList();
    templatesNotifier.value = templates;
    await _saveTemplates();
  }

  static Future<void> deleteTemplate(String templateId) async {
    final templates = templatesNotifier.value.where((template) => 
        template.id != templateId).toList();
    templatesNotifier.value = templates;
    await _saveTemplates();
  }

  static Future<void> _createDefaultTemplates() async {
    final defaultTemplates = [
      MessageTemplate(
        id: '1',
        name: 'تهنئة عيد الفطر',
        content: 'عيد فطر مبارك عليكم وعلى جميع الأمة الإسلامية، كل عام وأنتم بخير وصحة وسعادة 🌙✨',
        category: 'دينية',
        isFavorite: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      MessageTemplate(
        id: '2',
        name: 'تهنئة عيد الأضحى',
        content: 'عيد أضحى مبارك، تقبل الله منا ومنكم صالح الأعمال، كل عام وأنتم بخير 🕌🐑',
        category: 'دينية',
        isFavorite: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      MessageTemplate(
        id: '3',
        name: 'تهنئة رمضان',
        content: 'رمضان مبارك عليكم، أعاده الله عليكم بالخير والبركات، كل عام وأنتم بخير 🌙',
        category: 'دينية',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      MessageTemplate(
        id: '4',
        name: 'تهنئة زواج',
        content: 'ألف مبروك الزواج، بارك الله لكما وبارك عليكما وجمع بينكما في خير 💍👰',
        category: 'اجتماعية',
        isFavorite: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      MessageTemplate(
        id: '5',
        name: 'تهنئة مولود',
        content: 'ألف مبروك المولود الجديد، بارك الله لكم في الموهوب وشكرتم الواهب 👶💙',
        category: 'اجتماعية',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      MessageTemplate(
        id: '6',
        name: 'تهنئة تخرج',
        content: 'ألف مبروك التخرج، نسأل الله أن يوفقك في حياتك العملية ويبارك في مستقبلك 🎓📚',
        category: 'اجتماعية',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      MessageTemplate(
        id: '7',
        name: 'تهنئة اليوم الوطني',
        content: 'كل عام ووطننا الغالي بخير وعز ومنعة، دام عزك يا وطن 🇸🇦💚',
        category: 'وطنية',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      MessageTemplate(
        id: '8',
        name: 'تهنئة نجاح',
        content: 'ألف مبروك النجاح والتفوق، نسأل الله أن يديم عليك التوفيق والنجاح 🌟📈',
        category: 'اجتماعية',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      MessageTemplate(
        id: '9',
        name: 'تعزية',
        content: 'إنا لله وإنا إليه راجعون، أحر التعازي والمواساة، أسأل الله أن يتغمد الفقيد بواسع رحمته',
        category: 'تعزية',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      MessageTemplate(
        id: '10',
        name: 'تهنئة عيد ميلاد',
        content: 'كل عام وأنت بخير وصحة وسعادة، عيد ميلاد سعيد وسنة جديدة مليئة بالفرح والنجاح 🎂🎉',
        category: 'خاصة',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    for (final template in defaultTemplates) {
      await addTemplate(template);
    }
  }

  static List<MessageTemplate> getTemplatesByCategory(String category) {
    return templatesNotifier.value.where((template) => 
        template.category == category).toList();
  }

  static List<MessageTemplate> getFavoriteTemplates() {
    return templatesNotifier.value.where((template) => 
        template.isFavorite).toList();
  }

  static List<String> getCategories() {
    final categories = templatesNotifier.value.map((template) => 
        template.category).toSet().toList();
    categories.sort();
    return categories;
  }

  static Future<void> toggleFavorite(String templateId) async {
    final templates = templatesNotifier.value.map((template) {
      if (template.id == templateId) {
        return MessageTemplate(
          id: template.id,
          name: template.name,
          content: template.content,
          category: template.category,
          isFavorite: !template.isFavorite,
          createdAt: template.createdAt,
          updatedAt: DateTime.now(),
        );
      }
      return template;
    }).toList();
    
    templatesNotifier.value = templates;
    await _saveTemplates();
  }

  static List<MessageTemplate> searchTemplates(String query) {
    if (query.isEmpty) return templatesNotifier.value;
    
    final lowerQuery = query.toLowerCase();
    return templatesNotifier.value.where((template) {
      return template.name.toLowerCase().contains(lowerQuery) ||
             template.content.toLowerCase().contains(lowerQuery) ||
             template.category.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
