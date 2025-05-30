import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

enum RepeatType {
  none,
  daily,
  weekly,
  monthly,
  yearly,
}

class ScheduledMessage {
  final String id;
  final String content;
  final String recipientName;
  final String recipientPhone;
  final DateTime scheduledTime;
  final RepeatType repeatType;
  final bool isEnabled;
  final DateTime createdAt;

  ScheduledMessage({
    required this.id,
    required this.content,
    required this.recipientName,
    required this.recipientPhone,
    required this.scheduledTime,
    this.repeatType = RepeatType.none,
    this.isEnabled = true,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'recipientName': recipientName,
      'recipientPhone': recipientPhone,
      'scheduledTime': scheduledTime.toIso8601String(),
      'repeatType': repeatType.index,
      'isEnabled': isEnabled,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ScheduledMessage.fromJson(Map<String, dynamic> json) {
    return ScheduledMessage(
      id: json['id'],
      content: json['content'],
      recipientName: json['recipientName'],
      recipientPhone: json['recipientPhone'],
      scheduledTime: DateTime.parse(json['scheduledTime']),
      repeatType: RepeatType.values[json['repeatType'] ?? 0],
      isEnabled: json['isEnabled'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class MessageTemplate {
  final String id;
  final String name;
  final String content;
  final String category;
  final DateTime createdAt;

  MessageTemplate({
    required this.id,
    required this.name,
    required this.content,
    required this.category,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'content': content,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MessageTemplate.fromJson(Map<String, dynamic> json) {
    return MessageTemplate(
      id: json['id'],
      name: json['name'],
      content: json['content'],
      category: json['category'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class ScheduledMessageService {
  static const String _messagesKey = 'scheduled_messages';
  static const String _templatesKey = 'scheduled_templates';
  
  static final ValueNotifier<List<ScheduledMessage>> messagesNotifier = 
      ValueNotifier<List<ScheduledMessage>>([]);
  
  static final ValueNotifier<List<MessageTemplate>> templatesNotifier = 
      ValueNotifier<List<MessageTemplate>>([]);

  static Future<void> initialize() async {
    await _loadMessages();
    await _loadTemplates();
    if (templatesNotifier.value.isEmpty) {
      await _createDefaultTemplates();
    }
  }

  // إدارة الرسائل المجدولة
  static Future<void> _loadMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesJson = prefs.getString(_messagesKey);
      
      if (messagesJson != null) {
        final List<dynamic> messagesList = json.decode(messagesJson);
        final messages = messagesList.map((json) => 
            ScheduledMessage.fromJson(json)).toList();
        messagesNotifier.value = messages;
      }
    } catch (e) {
      debugPrint('Error loading scheduled messages: $e');
      messagesNotifier.value = [];
    }
  }

  static Future<void> _saveMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesJson = json.encode(
        messagesNotifier.value.map((message) => message.toJson()).toList()
      );
      await prefs.setString(_messagesKey, messagesJson);
    } catch (e) {
      debugPrint('Error saving scheduled messages: $e');
    }
  }

  static Future<void> addMessage(ScheduledMessage message) async {
    final messages = List<ScheduledMessage>.from(messagesNotifier.value);
    messages.add(message);
    messagesNotifier.value = messages;
    await _saveMessages();
  }

  static Future<void> updateMessage(ScheduledMessage message) async {
    final messages = messagesNotifier.value.map((m) {
      return m.id == message.id ? message : m;
    }).toList();
    messagesNotifier.value = messages;
    await _saveMessages();
  }

  static Future<void> deleteMessage(String messageId) async {
    final messages = messagesNotifier.value.where((message) => 
        message.id != messageId).toList();
    messagesNotifier.value = messages;
    await _saveMessages();
  }

  static Future<void> toggleMessage(String messageId, bool isEnabled) async {
    final messages = messagesNotifier.value.map((message) {
      if (message.id == messageId) {
        return ScheduledMessage(
          id: message.id,
          content: message.content,
          recipientName: message.recipientName,
          recipientPhone: message.recipientPhone,
          scheduledTime: message.scheduledTime,
          repeatType: message.repeatType,
          isEnabled: isEnabled,
          createdAt: message.createdAt,
        );
      }
      return message;
    }).toList();
    
    messagesNotifier.value = messages;
    await _saveMessages();
  }

  // إدارة القوالب
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
      debugPrint('Error loading scheduled templates: $e');
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
      debugPrint('Error saving scheduled templates: $e');
    }
  }

  static Future<void> addTemplate(MessageTemplate template) async {
    final templates = List<MessageTemplate>.from(templatesNotifier.value);
    templates.add(template);
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
        name: 'تذكير بالاجتماع',
        content: 'تذكير: لديك اجتماع اليوم في تمام الساعة [الوقت]',
        category: 'عمل',
        createdAt: DateTime.now(),
      ),
      MessageTemplate(
        id: '2',
        name: 'تذكير بالموعد',
        content: 'تذكير: لديك موعد اليوم، لا تنس الحضور في الوقت المحدد',
        category: 'شخصي',
        createdAt: DateTime.now(),
      ),
      MessageTemplate(
        id: '3',
        name: 'تهنئة عيد ميلاد',
        content: 'كل عام وأنت بخير، عيد ميلاد سعيد! 🎂🎉',
        category: 'تهنئة',
        createdAt: DateTime.now(),
      ),
      MessageTemplate(
        id: '4',
        name: 'تذكير بالدواء',
        content: 'تذكير: حان وقت تناول الدواء، لا تنس أخذ جرعتك',
        category: 'صحة',
        createdAt: DateTime.now(),
      ),
    ];

    for (final template in defaultTemplates) {
      await addTemplate(template);
    }
  }

  // البحث والتصفية
  static List<ScheduledMessage> getActiveMessages() {
    return messagesNotifier.value.where((message) => 
        message.isEnabled && message.scheduledTime.isAfter(DateTime.now())).toList();
  }

  static List<ScheduledMessage> getOverdueMessages() {
    return messagesNotifier.value.where((message) => 
        message.isEnabled && message.scheduledTime.isBefore(DateTime.now())).toList();
  }

  static List<ScheduledMessage> getMessagesByDate(DateTime date) {
    return messagesNotifier.value.where((message) {
      final messageDate = message.scheduledTime;
      return messageDate.year == date.year &&
             messageDate.month == date.month &&
             messageDate.day == date.day;
    }).toList();
  }

  // معالجة التكرار
  static DateTime? getNextScheduledTime(ScheduledMessage message) {
    if (message.repeatType == RepeatType.none) return null;
    
    final now = DateTime.now();
    var nextTime = message.scheduledTime;
    
    while (nextTime.isBefore(now)) {
      switch (message.repeatType) {
        case RepeatType.daily:
          nextTime = nextTime.add(const Duration(days: 1));
          break;
        case RepeatType.weekly:
          nextTime = nextTime.add(const Duration(days: 7));
          break;
        case RepeatType.monthly:
          nextTime = DateTime(
            nextTime.year,
            nextTime.month + 1,
            nextTime.day,
            nextTime.hour,
            nextTime.minute,
          );
          break;
        case RepeatType.yearly:
          nextTime = DateTime(
            nextTime.year + 1,
            nextTime.month,
            nextTime.day,
            nextTime.hour,
            nextTime.minute,
          );
          break;
        case RepeatType.none:
          return null;
      }
    }
    
    return nextTime;
  }

  // إرسال الرسائل المجدولة
  static Future<void> processScheduledMessages() async {
    final now = DateTime.now();
    final messagesToSend = messagesNotifier.value.where((message) {
      return message.isEnabled && 
             message.scheduledTime.isBefore(now) &&
             message.scheduledTime.isAfter(now.subtract(const Duration(minutes: 5)));
    }).toList();

    for (final message in messagesToSend) {
      await _sendMessage(message);
      
      // إذا كانت الرسالة متكررة، جدول الإرسال التالي
      if (message.repeatType != RepeatType.none) {
        final nextTime = getNextScheduledTime(message);
        if (nextTime != null) {
          final updatedMessage = ScheduledMessage(
            id: message.id,
            content: message.content,
            recipientName: message.recipientName,
            recipientPhone: message.recipientPhone,
            scheduledTime: nextTime,
            repeatType: message.repeatType,
            isEnabled: message.isEnabled,
            createdAt: message.createdAt,
          );
          await updateMessage(updatedMessage);
        }
      } else {
        // إذا لم تكن متكررة، عطل الرسالة
        await toggleMessage(message.id, false);
      }
    }
  }

  static Future<void> _sendMessage(ScheduledMessage message) async {
    // هنا يمكن إضافة منطق الإرسال الفعلي
    debugPrint('Sending scheduled message to ${message.recipientName}: ${message.content}');
    
    // يمكن إضافة تكامل مع:
    // - واتساب
    // - SMS
    // - البريد الإلكتروني
    // - الإشعارات المحلية
  }

  // إحصائيات
  static Map<String, int> getStatistics() {
    final messages = messagesNotifier.value;
    return {
      'total': messages.length,
      'active': messages.where((m) => m.isEnabled).length,
      'overdue': getOverdueMessages().length,
      'today': getMessagesByDate(DateTime.now()).length,
    };
  }
}
