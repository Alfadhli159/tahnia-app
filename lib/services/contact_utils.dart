import 'package:flutter_contacts/flutter_contacts.dart';

/// خدمة مساعدة للتعامل مع جهات الاتصال
class ContactUtils {
  /// تنظيف رقم الهاتف وإرجاعه بصيغة صالحة للواتساب
  /// يدعم الأنماط التالية:
  /// - الأرقام الدولية مع + (مثل +966501234567)
  /// - الأرقام الدولية مع 00 (مثل 00966501234567)
  /// - الأرقام السعودية المحلية (مثل 0501234567 أو 501234567)
  /// - الأرقام الدولية الأخرى (سيتم الحفاظ عليها كما هي)
  static String getCleanPhoneNumber(Contact contact) {
    if (contact.phones.isEmpty) return '';
    
    String phoneNumber = contact.phones.first.number;
    
    // حذف جميع الرموز الخاصة والمسافات ما عدا +
    phoneNumber = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)\[\]\{\}\.\,]'), '');
    
    // معالجة الأرقام التي تبدأ بـ +
    if (phoneNumber.startsWith('+')) {
      phoneNumber = phoneNumber.substring(1);
    }
    
    // معالجة الأرقام التي تبدأ بـ 00
    if (phoneNumber.startsWith('00')) {
      phoneNumber = phoneNumber.substring(2);
    }
    
    // معالجة الأرقام السعودية
    if (phoneNumber.startsWith('966')) {
      // تأكد من أن طول الرقم صحيح (966 + 9 أرقام)
      return phoneNumber.length == 12 ? phoneNumber : '';
    } else if (phoneNumber.startsWith('05')) {
      // تحويل 05 إلى 966 (مع التحقق من الطول)
      return phoneNumber.length == 10 ? '966${phoneNumber.substring(1)}' : '';
    } else if (phoneNumber.startsWith('5')) {
      // تحويل 5 إلى 966 (مع التحقق من الطول)
      return phoneNumber.length == 9 ? '966$phoneNumber' : '';
    }
    
    // إرجاع الرقم كما هو إذا لم يكن رقماً سعودياً
    return phoneNumber;
  }
  
  /// الحصول على الحرف الأول من اسم جهة الاتصال
  static String getContactInitial(Contact contact) {
    if (contact.displayName.isEmpty) return '؟';
    return contact.displayName[0].toUpperCase();
  }
  
  /// فلترة جهات الاتصال الصالحة
  static List<Contact> filterValidContacts(List<Contact> contacts) {
    return contacts.where((contact) {
      bool hasValidPhone = contact.phones.isNotEmpty && 
                         contact.phones.any((phone) => phone.number.trim().isNotEmpty);
      bool hasValidName = contact.displayName.isNotEmpty;
      return hasValidPhone && hasValidName;
    }).toList();
  }
  
  /// ترتيب جهات الاتصال أبجدياً
  static List<Contact> sortContactsAlphabetically(List<Contact> contacts) {
    contacts.sort((a, b) => a.displayName.compareTo(b.displayName));
    return contacts;
  }
  
  /// البحث في جهات الاتصال
  static List<Contact> searchContacts(List<Contact> contacts, String query) {
    if (query.isEmpty) return contacts;
    
    final lowerQuery = query.toLowerCase();
    return contacts.where((contact) {
      final name = contact.displayName.toLowerCase();
      final phones = contact.phones.map((p) => p.number).join(' ').toLowerCase();
      return name.contains(lowerQuery) || phones.contains(lowerQuery);
    }).toList();
  }
  
  /// تجميع جهات الاتصال حسب الحرف الأول
  static Map<String, List<Contact>> groupContactsByInitial(List<Contact> contacts) {
    final Map<String, List<Contact>> grouped = {};
    
    for (final contact in contacts) {
      final initial = getContactInitial(contact);
      if (!grouped.containsKey(initial)) {
        grouped[initial] = [];
      }
      grouped[initial]!.add(contact);
    }
    
    return grouped;
  }
  
  /// التحقق من صحة رقم الهاتف السعودي
  /// يتحقق من الصيغ التالية:
  /// - 966512345678 (12 رقم)
  /// - 0512345678 (10 أرقام)
  /// - 512345678 (9 أرقام)
  static bool isValidSaudiPhoneNumber(String phoneNumber) {
    // حذف جميع الرموز الخاصة والمسافات
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)\+\[\]\{\}\.\,]'), '');
    
    // التعبير النمطي للتحقق من صحة رقم الهاتف السعودي
    final saudiMobileRegex = RegExp(
      r'^(?:966|00966)?(?:5[0-9]{8})$|^0?5[0-9]{8}$'
    );
    
    return saudiMobileRegex.hasMatch(cleanNumber);
  }
  
  /// تنسيق رقم الهاتف للعرض
  /// يدعم الصيغ التالية:
  /// - أرقام سعودية (966512345678 -> +966 51 234 5678)
  /// - أرقام محلية (0512345678 -> 051 234 5678)
  /// - أرقام مختصرة (512345678 -> 051 234 5678)
  static String formatPhoneNumberForDisplay(String phoneNumber) {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)\+\[\]\{\}\.\,]'), '');
    
    // معالجة الأرقام السعودية التي تبدأ بـ 966
    if (cleanNumber.startsWith('966')) {
      final localNumber = cleanNumber.substring(3);
      if (localNumber.length == 9) {
        return '+966 ${localNumber.substring(0, 2)} ${localNumber.substring(2, 5)} ${localNumber.substring(5)}';
      }
    }
    
    // معالجة الأرقام التي تبدأ بـ 05
    if (cleanNumber.startsWith('05') && cleanNumber.length == 10) {
      return '${cleanNumber.substring(0, 3)} ${cleanNumber.substring(3, 6)} ${cleanNumber.substring(6)}';
    }
    
    // معالجة الأرقام التي تبدأ بـ 5
    if (cleanNumber.startsWith('5') && cleanNumber.length == 9) {
      // For numbers like 512345678 -> 050 123 4567
      final number = cleanNumber.substring(1); // Remove the leading 5
      return '050 ${number.substring(0, 3)} ${number.substring(3, 7)}';
    }
    
    // إرجاع الرقم بتنسيق عام إذا لم يكن رقماً سعودياً
    if (cleanNumber.length > 8) {
      if (cleanNumber.length == 10) {  // For standard 10-digit numbers like 1234567890
        return '${cleanNumber.substring(0, 3)} ${cleanNumber.substring(3, 6)} ${cleanNumber.substring(6)}';
      } else {
        // تقسيم الرقم إلى مجموعات من 3 أرقام من اليسار إلى اليمين
        final List<String> groups = [];
        String remaining = cleanNumber;
        while (remaining.length > 3) {
          groups.add(remaining.substring(0, 3));
          remaining = remaining.substring(3);
        }
        if (remaining.isNotEmpty) {
          groups.add(remaining);
        }
        return groups.join(' ');
      }
    }
    
    return phoneNumber; // إرجاع الرقم كما هو إذا لم يتم التعرف على التنسيق
  }
}
