import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutoReplyMessage {
  final String id;
  final String senderName;
  final String originalMessage;
  final String suggestedReply;
  final DateTime receivedAt;
  final bool isApproved;

  AutoReplyMessage({
    required this.id,
    required this.senderName,
    required this.originalMessage,
    required this.suggestedReply,
    required this.receivedAt,
    this.isApproved = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderName': senderName,
      'originalMessage': originalMessage,
      'suggestedReply': suggestedReply,
      'receivedAt': receivedAt.toIso8601String(),
      'isApproved': isApproved,
    };
  }

  factory AutoReplyMessage.fromJson(Map<String, dynamic> json) {
    return AutoReplyMessage(
      id: json['id'],
      senderName: json['senderName'],
      originalMessage: json['originalMessage'],
      suggestedReply: json['suggestedReply'],
      receivedAt: DateTime.parse(json['receivedAt']),
      isApproved: json['isApproved'] ?? false,
    );
  }
}

class AutoReplyService {
  static const String _whatsappEnabledKey = 'auto_reply_whatsapp_enabled';
  static const String _smsEnabledKey = 'auto_reply_sms_enabled';
  static const String _groupsEnabledKey = 'auto_reply_groups_enabled';
  static const String _businessEnabledKey = 'auto_reply_business_enabled';
  static const String _ownerNameKey = 'auto_reply_owner_name';
  static const String _messagesKey = 'auto_reply_messages';

  static final ValueNotifier<List<AutoReplyMessage>> messagesNotifier = 
      ValueNotifier<List<AutoReplyMessage>>([]);

  static Future<void> initialize() async {
    await _loadMessages();
  }

  // إعدادات الرد التلقائي
  static Future<bool> isWhatsAppAutoReplyEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_whatsappEnabledKey) ?? false;
  }

  static Future<void> setWhatsAppAutoReplyEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_whatsappEnabledKey, enabled);
  }

  static Future<bool> isSMSAutoReplyEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_smsEnabledKey) ?? false;
  }

  static Future<void> setSMSAutoReplyEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_smsEnabledKey, enabled);
  }

  static Future<bool> isGroupsAutoReplyEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_groupsEnabledKey) ?? false;
  }

  static Future<void> setGroupsAutoReplyEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_groupsEnabledKey, enabled);
  }

  static Future<bool> isBusinessAutoReplyEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_businessEnabledKey) ?? false;
  }

  static Future<void> setBusinessAutoReplyEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_businessEnabledKey, enabled);
  }

  static Future<String> getOwnerName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_ownerNameKey) ?? '';
  }

  static Future<void> setOwnerName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ownerNameKey, name);
  }

  // إدارة الرسائل
  static Future<void> _loadMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesJson = prefs.getStringList(_messagesKey) ?? [];
      
      final messages = messagesJson.map((json) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(
          Uri.splitQueryString(json)
        );
        return AutoReplyMessage.fromJson(data);
      }).toList();
      
      messagesNotifier.value = messages;
    } catch (e) {
      debugPrint('Error loading auto-reply messages: $e');
      messagesNotifier.value = [];
    }
  }

  static Future<void> _saveMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesJson = messagesNotifier.value.map((message) {
        return Uri(queryParameters: message.toJson().map(
          (key, value) => MapEntry(key, value.toString())
        )).query;
      }).toList();
      
      await prefs.setStringList(_messagesKey, messagesJson);
    } catch (e) {
      debugPrint('Error saving auto-reply messages: $e');
    }
  }

  static Future<void> addMessage(AutoReplyMessage message) async {
    final messages = List<AutoReplyMessage>.from(messagesNotifier.value);
    messages.add(message);
    messagesNotifier.value = messages;
    await _saveMessages();
  }

  static Future<void> approveReply(String messageId) async {
    final messages = messagesNotifier.value.map((message) {
      if (message.id == messageId) {
        return AutoReplyMessage(
          id: message.id,
          senderName: message.senderName,
          originalMessage: message.originalMessage,
          suggestedReply: message.suggestedReply,
          receivedAt: message.receivedAt,
          isApproved: true,
        );
      }
      return message;
    }).toList();
    
    messagesNotifier.value = messages;
    await _saveMessages();
    
    // هنا يمكن إضافة منطق إرسال الرد الفعلي
    await _sendReply(messageId);
  }

  static Future<void> editReply(String messageId, String newReply) async {
    final messages = messagesNotifier.value.map((message) {
      if (message.id == messageId) {
        return AutoReplyMessage(
          id: message.id,
          senderName: message.senderName,
          originalMessage: message.originalMessage,
          suggestedReply: newReply,
          receivedAt: message.receivedAt,
          isApproved: message.isApproved,
        );
      }
      return message;
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

  static Future<void> _sendReply(String messageId) async {
    // منطق إرسال الرد الفعلي
    // يمكن تنفيذه لاحقاً مع تكامل واتساب أو SMS
    debugPrint('Sending auto-reply for message: $messageId');
  }

  // توليد رد تلقائي باستخدام الذكاء الاصطناعي
  static Future<String> generateAutoReply(String originalMessage, String senderName) async {
    // هنا يمكن إضافة تكامل مع خدمة الذكاء الاصطناعي
    // مؤقتاً سنستخدم ردود جاهزة
    
    final ownerName = await getOwnerName();
    final lowerMessage = originalMessage.toLowerCase();
    
    if (lowerMessage.contains('مبارك') || lowerMessage.contains('تهنئة')) {
      return 'الله يبارك فيك $senderName، شكراً لك على التهنئة الجميلة 🌹';
    } else if (lowerMessage.contains('كيف حالك') || lowerMessage.contains('كيفك')) {
      return 'أهلاً $senderName، الحمد لله بخير، كيف حالك أنت؟';
    } else if (lowerMessage.contains('عيد مبارك')) {
      return 'عيد مبارك عليك وعلى أهلك $senderName، كل عام وأنتم بخير 🌙';
    } else if (lowerMessage.contains('رمضان مبارك')) {
      return 'رمضان مبارك عليك $senderName، كل عام وأنتم بخير 🌙';
    } else {
      return 'شكراً لك $senderName على رسالتك، سأرد عليك قريباً إن شاء الله 🌹';
    }
  }

  // محاكاة استقبال رسالة جديدة
  static Future<void> simulateIncomingMessage(String senderName, String message) async {
    final suggestedReply = await generateAutoReply(message, senderName);
    
    final autoReplyMessage = AutoReplyMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderName: senderName,
      originalMessage: message,
      suggestedReply: suggestedReply,
      receivedAt: DateTime.now(),
    );
    
    await addMessage(autoReplyMessage);
  }
}
