import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tahania_app/theme/app_constants.dart';

class AppUtils {
  // تنسيق التاريخ والوقت
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy/MM/dd HH:mm').format(dateTime);
  }

  static String formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd').format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  // التحقق من صحة البيانات
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    return RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(phone);
  }

  static bool isValidPassword(String password) {
    return password.length >= 8;
  }

  // عرض رسائل النظام
  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = AppConstants.saveButtonText,
    String cancelText = AppConstants.cancelButtonText,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // تنسيق النصوص
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  // التحويل بين الأنواع
  static String sentimentTypeToText(String type) {
    switch (type.toLowerCase()) {
      case 'positive':
        return AppConstants.sentimentTypes[0];
      case 'neutral':
        return AppConstants.sentimentTypes[1];
      case 'negative':
        return AppConstants.sentimentTypes[2];
      default:
        return type;
    }
  }

  static Color sentimentTypeToColor(String type) {
    switch (type.toLowerCase()) {
      case 'positive':
        return Colors.green;
      case 'neutral':
        return Colors.blue;
      case 'negative':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // التحقق من الاتصال بالإنترنت
  static Future<bool> checkInternetConnection() async {
    try {
      // تنفيذ التحقق من الاتصال
      return true;
    } catch (e) {
      return false;
    }
  }

  // التحقق من الصلاحيات
  static Future<bool> checkPermission(String permission) async {
    try {
      // تنفيذ التحقق من الصلاحيات
      return true;
    } catch (e) {
      return false;
    }
  }

  // تنسيق الأرقام
  static String formatNumber(int number) {
    return NumberFormat('#,###').format(number);
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(symbol: 'ر.س').format(amount);
  }

  // التحقق من صحة البيانات المدخلة
  static String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    if (!isValidEmail(value)) {
      return 'البريد الإلكتروني غير صالح';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    if (!isValidPhone(value)) {
      return 'رقم الهاتف غير صالح';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (!isValidPassword(value)) {
      return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    }
    return null;
  }

  // تنسيق المدة الزمنية
  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} يوم';
    }
    if (duration.inHours > 0) {
      return '${duration.inHours} ساعة';
    }
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes} دقيقة';
    }
    return '${duration.inSeconds} ثانية';
  }

  // تنسيق حجم الملف
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // تنسيق النسبة المئوية
  static String formatPercentage(double value) {
    return '${(value * 100).toStringAsFixed(1)}%';
  }

  // تنسيق العنوان
  static String formatAddress(String address) {
    return address.replaceAll(',', '\n');
  }

  // تنسيق رقم الهاتف
  static String formatPhoneNumber(String phone) {
    return phone.replaceAllMapped(
      RegExp(r'(\d{3})(\d{3})(\d{4})'),
      (Match m) => '${m[1]}-${m[2]}-${m[3]}',
    );
  }

  // تنسيق رقم البطاقة
  static String formatCardNumber(String cardNumber) {
    return cardNumber.replaceAllMapped(
      RegExp(r'(\d{4})(\d{4})(\d{4})(\d{4})'),
      (Match m) => '${m[1]} ${m[2]} ${m[3]} ${m[4]}',
    );
  }

  // تنسيق رقم الحساب
  static String formatAccountNumber(String accountNumber) {
    return accountNumber.replaceAllMapped(
      RegExp(r'(\d{4})(\d{4})(\d{4})(\d{4})'),
      (Match m) => '${m[1]}-${m[2]}-${m[3]}-${m[4]}',
    );
  }
} 