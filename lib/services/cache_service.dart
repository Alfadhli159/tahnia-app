import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';

class CacheService {
  static const Duration _cacheDuration = Duration(days: 7);
  static final Map<String, DateTime> _cacheTimestamps = {};

  /// تحميل صورة مع التخزين المؤقت
  static Future<File?> getCachedImage(String url) async {
    try {
      final cacheDir = await _getCacheDirectory();
      final fileName = _getFileNameFromUrl(url);
      final file = File('${cacheDir.path}/$fileName');

      // التحقق من وجود الملف في التخزين المؤقت
      if (await file.exists()) {
        final timestamp = _cacheTimestamps[fileName];
        if (timestamp != null && DateTime.now().difference(timestamp) < _cacheDuration) {
          return file;
        }
      }

      // تحميل الصورة وتخزينها
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        _cacheTimestamps[fileName] = DateTime.now();
        return file;
      }
    } catch (e) {
      print('خطأ في التخزين المؤقت: $e');
    }
    return null;
  }

  /// تحميل ملف JSON مع التخزين المؤقت
  static Future<String?> getCachedJson(String url) async {
    try {
      final cacheDir = await _getCacheDirectory();
      final fileName = _getFileNameFromUrl(url);
      final file = File('${cacheDir.path}/$fileName');

      if (await file.exists()) {
        final timestamp = _cacheTimestamps[fileName];
        if (timestamp != null && DateTime.now().difference(timestamp) < _cacheDuration) {
          return await file.readAsString();
        }
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await file.writeAsString(response.body);
        _cacheTimestamps[fileName] = DateTime.now();
        return response.body;
      }
    } catch (e) {
      print('خطأ في التخزين المؤقت: $e');
    }
    return null;
  }

  /// مسح التخزين المؤقت القديم
  static Future<void> clearOldCache() async {
    try {
      final cacheDir = await _getCacheDirectory();
      final now = DateTime.now();

      await for (final file in cacheDir.list()) {
        if (file is File) {
          final fileName = file.path.split('/').last;
          final timestamp = _cacheTimestamps[fileName];
          if (timestamp != null && now.difference(timestamp) > _cacheDuration) {
            await file.delete();
            _cacheTimestamps.remove(fileName);
          }
        }
      }
    } catch (e) {
      print('خطأ في مسح التخزين المؤقت: $e');
    }
  }

  /// الحصول على مجلد التخزين المؤقت
  static Future<Directory> _getCacheDirectory() async {
    final cacheDir = await getTemporaryDirectory();
    final appCacheDir = Directory('${cacheDir.path}/tahania_cache');
    if (!await appCacheDir.exists()) {
      await appCacheDir.create(recursive: true);
    }
    return appCacheDir;
  }

  /// إنشاء اسم ملف فريد من URL
  static String _getFileNameFromUrl(String url) {
    final bytes = utf8.encode(url);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }
} 