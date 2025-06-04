import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _greetingsKey = 'saved_greetings';
  static const String _contactsKey = 'saved_contacts';
  static const String _settingsKey = 'app_settings';

  // تهيئة الخدمة
  static Future<void> initialize() async {
    // يمكن إضافة أي تهيئة مطلوبة هنا
  }

  // حفظ واسترجاع التهاني
  static Future<void> saveGreeting(String id, Map<String, dynamic> greeting) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final greetingsJson = prefs.getString(_greetingsKey) ?? '{}';
      final Map<String, dynamic> greetings = json.decode(greetingsJson);
      
      greetings[id] = {
        ...greeting,
        'id': id,
        'savedAt': DateTime.now().toIso8601String(),
      };
      
      await prefs.setString(_greetingsKey, json.encode(greetings));
    } catch (e) {
      throw Exception('Failed to save greeting: $e');
    }
  }

  static Future<Map<String, dynamic>?> getGreeting(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final greetingsJson = prefs.getString(_greetingsKey) ?? '{}';
      final Map<String, dynamic> greetings = json.decode(greetingsJson);
      
      return greetings[id];
    } catch (e) {
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getAllGreetings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final greetingsJson = prefs.getString(_greetingsKey) ?? '{}';
      final Map<String, dynamic> greetings = json.decode(greetingsJson);
      
      return greetings.values.cast<Map<String, dynamic>>().toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> deleteGreeting(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final greetingsJson = prefs.getString(_greetingsKey) ?? '{}';
      final Map<String, dynamic> greetings = json.decode(greetingsJson);
      
      greetings.remove(id);
      
      await prefs.setString(_greetingsKey, json.encode(greetings));
    } catch (e) {
      throw Exception('Failed to delete greeting: $e');
    }
  }

  // حفظ واسترجاع جهات الاتصال
  static Future<void> saveContact(String id, Map<String, dynamic> contact) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final contactsJson = prefs.getString(_contactsKey) ?? '{}';
      final Map<String, dynamic> contacts = json.decode(contactsJson);
      
      contacts[id] = {
        ...contact,
        'id': id,
        'savedAt': DateTime.now().toIso8601String(),
      };
      
      await prefs.setString(_contactsKey, json.encode(contacts));
    } catch (e) {
      throw Exception('Failed to save contact: $e');
    }
  }

  static Future<Map<String, dynamic>?> getContact(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final contactsJson = prefs.getString(_contactsKey) ?? '{}';
      final Map<String, dynamic> contacts = json.decode(contactsJson);
      
      return contacts[id];
    } catch (e) {
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getAllContacts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final contactsJson = prefs.getString(_contactsKey) ?? '{}';
      final Map<String, dynamic> contacts = json.decode(contactsJson);
      
      return contacts.values.cast<Map<String, dynamic>>().toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> deleteContact(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final contactsJson = prefs.getString(_contactsKey) ?? '{}';
      final Map<String, dynamic> contacts = json.decode(contactsJson);
      
      contacts.remove(id);
      
      await prefs.setString(_contactsKey, json.encode(contacts));
    } catch (e) {
      throw Exception('Failed to delete contact: $e');
    }
  }

  // حفظ واسترجاع الإعدادات
  static Future<void> saveSetting(String key, dynamic value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey) ?? '{}';
      final Map<String, dynamic> settings = json.decode(settingsJson);
      
      settings[key] = value;
      
      await prefs.setString(_settingsKey, json.encode(settings));
    } catch (e) {
      throw Exception('Failed to save setting: $e');
    }
  }

  static Future<T?> getSetting<T>(String key, [T? defaultValue]) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey) ?? '{}';
      final Map<String, dynamic> settings = json.decode(settingsJson);
      
      return settings[key] as T? ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  static Future<Map<String, dynamic>> getAllSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey) ?? '{}';
      return json.decode(settingsJson);
    } catch (e) {
      return {};
    }
  }

  static Future<void> deleteSetting(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey) ?? '{}';
      final Map<String, dynamic> settings = json.decode(settingsJson);
      
      settings.remove(key);
      
      await prefs.setString(_settingsKey, json.encode(settings));
    } catch (e) {
      throw Exception('Failed to delete setting: $e');
    }
  }

  // مسح جميع البيانات
  static Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_greetingsKey);
      await prefs.remove(_contactsKey);
      await prefs.remove(_settingsKey);
    } catch (e) {
      throw Exception('Failed to clear all data: $e');
    }
  }

  // نسخ احتياطي واستعادة
  static Future<Map<String, dynamic>> exportData() async {
    try {
      final greetings = await getAllGreetings();
      final contacts = await getAllContacts();
      final settings = await getAllSettings();
      
      return {
        'greetings': greetings,
        'contacts': contacts,
        'settings': settings,
        'exportedAt': DateTime.now().toIso8601String(),
        'version': '1.0.0',
      };
    } catch (e) {
      throw Exception('Failed to export data: $e');
    }
  }

  static Future<void> importData(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // استيراد التهاني
      if (data['greetings'] != null) {
        final greetings = <String, dynamic>{};
        for (final greeting in data['greetings']) {
          greetings[greeting['id']] = greeting;
        }
        await prefs.setString(_greetingsKey, json.encode(greetings));
      }
      
      // استيراد جهات الاتصال
      if (data['contacts'] != null) {
        final contacts = <String, dynamic>{};
        for (final contact in data['contacts']) {
          contacts[contact['id']] = contact;
        }
        await prefs.setString(_contactsKey, json.encode(contacts));
      }
      
      // استيراد الإعدادات
      if (data['settings'] != null) {
        await prefs.setString(_settingsKey, json.encode(data['settings']));
      }
    } catch (e) {
      throw Exception('Failed to import data: $e');
    }
  }

  // إحصائيات التخزين
  static Future<Map<String, int>> getStorageStats() async {
    try {
      final greetings = await getAllGreetings();
      final contacts = await getAllContacts();
      final settings = await getAllSettings();
      
      return {
        'greetingsCount': greetings.length,
        'contactsCount': contacts.length,
        'settingsCount': settings.length,
      };
    } catch (e) {
      return {
        'greetingsCount': 0,
        'contactsCount': 0,
        'settingsCount': 0,
      };
    }
  }

  // البحث في البيانات
  static Future<List<Map<String, dynamic>>> searchGreetings(String query) async {
    try {
      final allGreetings = await getAllGreetings();
      final lowerQuery = query.toLowerCase();
      
      return allGreetings.where((greeting) {
        final message = (greeting['message'] ?? '').toString().toLowerCase();
        final occasion = (greeting['occasion'] ?? '').toString().toLowerCase();
        final senderName = (greeting['senderName'] ?? '').toString().toLowerCase();
        
        return message.contains(lowerQuery) ||
               occasion.contains(lowerQuery) ||
               senderName.contains(lowerQuery);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> searchContacts(String query) async {
    try {
      final allContacts = await getAllContacts();
      final lowerQuery = query.toLowerCase();
      
      return allContacts.where((contact) {
        final name = (contact['name'] ?? '').toString().toLowerCase();
        final phone = (contact['phone'] ?? '').toString().toLowerCase();
        final email = (contact['email'] ?? '').toString().toLowerCase();
        
        return name.contains(lowerQuery) ||
               phone.contains(lowerQuery) ||
               email.contains(lowerQuery);
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
