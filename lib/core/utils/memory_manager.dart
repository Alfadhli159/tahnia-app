import 'dart:async';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';

class MemoryManager {
  static final MemoryManager _instance = MemoryManager._internal();
  factory MemoryManager() => _instance;
  MemoryManager._internal();

  final Map<String, DateTime> _lastAccessTimes = {};
  final Map<String, dynamic> _memoryCache = {};
  final Duration _maxIdleTime = const Duration(minutes: 5);

  void cacheValue(String key, dynamic value) {
    _memoryCache[key] = value;
    _lastAccessTimes[key] = DateTime.now();
    _scheduleCleanup();
  }

  dynamic getCachedValue(String key) {
    if (!_memoryCache.containsKey(key)) return null;
    
    _lastAccessTimes[key] = DateTime.now();
    return _memoryCache[key];
  }

  void removeValue(String key) {
    _memoryCache.remove(key);
    _lastAccessTimes.remove(key);
  }

  void clearCache() {
    _memoryCache.clear();
    _lastAccessTimes.clear();
  }

  void _scheduleCleanup() {
    Timer(const Duration(seconds: 1), _cleanupMemory);
  }

  void _cleanupMemory() {
    final now = DateTime.now();
    
    _lastAccessTimes.entries.removeWhere((entry) {
      if (now.difference(entry.value) > _maxIdleTime) {
        removeValue(entry.key);
        return true;
      }
      return false;
    });
  }

  void dispose() {
    clearCache();
  }
}
