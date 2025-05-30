import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';
import 'error_handler.dart';

class MemoryManagerAdvanced {
  static final MemoryManagerAdvanced _instance = MemoryManagerAdvanced._internal();
  factory MemoryManagerAdvanced() => _instance;
  MemoryManagerAdvanced._internal();

  final LruMap<String, dynamic> _memoryCache = LruMap(
    maxSize: 1000,
    onEviction: (key, value) {
      debugPrint('Evicted: $key');
    },
  );

  final Map<String, int> _memorySizes = {};
  final int _maxMemorySize = 100 * 1024 * 1024; // 100MB

  void cacheValue(String key, dynamic value, {int? size}) {
    try {
      if (size != null) {
        if (_calculateMemorySize() + size > _maxMemorySize) {
          _cleanupMemory();
        }
        _memorySizes[key] = size;
      }

      _memoryCache[key] = value;
    } catch (e) {
      ErrorHandler().handleError(e);
    }
  }

  dynamic getCachedValue(String key) {
    if (!_memoryCache.containsKey(key)) return null;
    return _memoryCache[key];
  }

  void removeValue(String key) {
    _memoryCache.remove(key);
    _memorySizes.remove(key);
  }

  void clearCache() {
    _memoryCache.clear();
    _memorySizes.clear();
  }

  int _calculateMemorySize() {
    return _memorySizes.values.fold(0, (sum, size) => sum + size);
  }

  void _cleanupMemory() {
    while (_calculateMemorySize() > _maxMemorySize) {
      final firstKey = _memoryCache.keys.first;
      removeValue(firstKey);
    }
  }

  void startMemoryMonitoring() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      final memoryInfo = _getMemoryInfo();
      debugPrint('Memory Usage: ${memoryInfo.toString()}');
    });
  }

  Map<String, dynamic> _getMemoryInfo() {
    final memoryInfo = {
      'total': _calculateMemorySize(),
      'items': _memoryCache.length,
      'max': _maxMemorySize,
    };
    return memoryInfo;
  }

  void dispose() {
    clearCache();
    _memoryCache.clear();
    _memorySizes.clear();
  }
}

class LruMap<K, V> extends LinkedHashMap<K, V> {
  final int maxSize;
  final void Function(K key, V value)? onEviction;

  LruMap({
    required this.maxSize,
    this.onEviction,
    bool equals(K key1, K key2) = identical,
    int hashCode(K key) = Object.hashCode,
    bool isValidKey(dynamic object) = _isValidKey,
  }) : super(
          equals: equals,
          hashCode: hashCode,
          isValidKey: isValidKey,
        );

  @override
  V? operator [](Object? key) {
    final value = super[key];
    if (value != null) {
      // Move accessed item to the end
      remove(key);
      this[key] = value;
    }
    return value;
  }

  @override
  void operator []=(K key, V value) {
    if (length >= maxSize) {
      final firstKey = first;
      final firstValue = remove(firstKey);
      if (firstValue != null && onEviction != null) {
        onEviction!(firstKey, firstValue);
      }
    }
    super[key] = value;
  }

  static bool _isValidKey(dynamic object) {
    return object != null;
  }
}
