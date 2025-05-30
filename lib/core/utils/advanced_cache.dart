import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';
import 'error_handler.dart';

class AdvancedCache {
  static final AdvancedCache _instance = AdvancedCache._internal();
  factory AdvancedCache() => _instance;
  AdvancedCache._internal();

  final Map<String, dynamic> _cache = {};
  final Map<String, DateTime> _cacheTimes = {};
  final Map<String, int> _cacheSizes = {};
  final Duration _maxAge = const Duration(days: 7);
  final int _maxCacheSize = 100 * 1024 * 1024; // 100MB

  Future<void> put(String key, dynamic value, {
    Duration? duration,
    int? size,
  }) async {
    try {
      if (size != null) {
        if (_calculateCacheSize() + size > _maxCacheSize) {
          await _cleanupCache();
        }
        _cacheSizes[key] = size;
      }

      _cache[key] = value;
      _cacheTimes[key] = DateTime.now();

      if (duration != null) {
        Timer(duration, () => remove(key));
      }
    } catch (e) {
      ErrorHandler().handleError(e);
    }
  }

  dynamic get(String key) {
    if (!_cache.containsKey(key)) return null;

    final cacheTime = _cacheTimes[key];
    if (cacheTime == null) return null;

    if (DateTime.now().difference(cacheTime) > _maxAge) {
      remove(key);
      return null;
    }

    _cacheTimes[key] = DateTime.now(); // Update access time
    return _cache[key];
  }

  void remove(String key) {
    _cache.remove(key);
    _cacheTimes.remove(key);
    _cacheSizes.remove(key);
  }

  Future<void> clear() async {
    _cache.clear();
    _cacheTimes.clear();
    _cacheSizes.clear();
  }

  Future<void> _cleanupCache() async {
    final now = DateTime.now();
    
    _cacheTimes.entries.removeWhere((entry) {
      if (now.difference(entry.value) > _maxAge) {
        remove(entry.key);
        return true;
      }
      return false;
    });

    if (_calculateCacheSize() > _maxCacheSize) {
      final sortedEntries = _cacheSizes.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));

      for (final entry in sortedEntries) {
        remove(entry.key);
        if (_calculateCacheSize() <= _maxCacheSize) break;
      }
    }
  }

  int _calculateCacheSize() {
    return _cacheSizes.values.fold(0, (sum, size) => sum + size);
  }

  Future<void> saveToDisk() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/cache.json');
      
      final content = json.encode({
        'cache': _cache,
        'times': _cacheTimes,
        'sizes': _cacheSizes,
      });
      
      await file.writeAsString(content);
    } catch (e) {
      ErrorHandler().handleError(e);
    }
  }

  Future<void> loadFromDisk() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/cache.json');
      
      if (!await file.exists()) return;
      
      final content = await file.readAsString();
      final data = json.decode(content) as Map<String, dynamic>;
      
      _cache.addAll(data['cache'] as Map<String, dynamic>);
      _cacheTimes.addAll(data['times'] as Map<String, dynamic>);
      _cacheSizes.addAll(data['sizes'] as Map<String, dynamic>);
    } catch (e) {
      ErrorHandler().handleError(e);
    }
  }
}
