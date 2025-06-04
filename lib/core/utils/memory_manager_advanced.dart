import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'error_handler.dart';

class MemoryManagerAdvanced {
  static final MemoryManagerAdvanced _instance =
      MemoryManagerAdvanced._internal();
  factory MemoryManagerAdvanced() => _instance;
  MemoryManagerAdvanced._internal();

  final _LruCache<String, dynamic> _memoryCache = _LruCache<String, dynamic>(
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

  dynamic getCachedValue(String key) => _memoryCache[key];

  void removeValue(String key) {
    _memoryCache.remove(key);
    _memorySizes.remove(key);
  }

  void clearCache() {
    _memoryCache.clear();
    _memorySizes.clear();
  }

  int _calculateMemorySize() => _memorySizes.values.fold(0, (sum, size) => sum + size);

  void _cleanupMemory() {
    while (_calculateMemorySize() > _maxMemorySize && _memoryCache.isNotEmpty) {
      final oldestKey = _memoryCache.keys.first;
      removeValue(oldestKey);
    }
  }

  void startMemoryMonitoring() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      final memoryInfo = _getMemoryInfo();
      debugPrint('Memory Usage: ${memoryInfo.toString()}');
    });
  }

  Map<String, dynamic> _getMemoryInfo() => {
      'total': _calculateMemorySize(),
      'items': _memoryCache.length,
      'max': _maxMemorySize,
    };

  void dispose() {
    clearCache();
  }
}

class _LruCache<K, V> implements Map<K, V> {
  final int maxSize;
  final void Function(K key, V value)? onEviction;
  final LinkedHashMap<K, V> _cache = LinkedHashMap<K, V>();

  _LruCache({
    required this.maxSize,
    this.onEviction,
  });

  @override
  V? operator [](Object? key) {
    final value = _cache[key];
    if (value != null && key is K) {
      // Move to end (most recently used)
      _cache.remove(key);
      _cache[key] = value;
    }
    return value;
  }

  @override
  void operator []=(K key, V value) {
    if (_cache.length >= maxSize && !_cache.containsKey(key)) {
      final oldestEntry = _cache.entries.first;
      _cache.remove(oldestEntry.key);
      onEviction?.call(oldestEntry.key, oldestEntry.value);
    }
    _cache[key] = value;
  }

  @override
  void clear() => _cache.clear();

  @override
  bool containsKey(Object? key) => _cache.containsKey(key);

  @override
  bool containsValue(Object? value) => _cache.containsValue(value);

  @override
  void forEach(void Function(K key, V value) action) => _cache.forEach(action);

  @override
  bool get isEmpty => _cache.isEmpty;

  @override
  bool get isNotEmpty => _cache.isNotEmpty;

  @override
  Iterable<K> get keys => _cache.keys;

  @override
  int get length => _cache.length;

  @override
  V? remove(Object? key) => _cache.remove(key);

  @override
  Iterable<V> get values => _cache.values;

  @override
  void addAll(Map<K, V> other) =>
      other.forEach((key, value) => this[key] = value);

  @override
  void addEntries(Iterable<MapEntry<K, V>> entries) {
    for (final entry in entries) {
      this[entry.key] = entry.value;
    }
  }

  @override
  Map<RK, RV> cast<RK, RV>() => _cache.cast<RK, RV>();

  @override
  Iterable<MapEntry<K, V>> get entries => _cache.entries;

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) convert) => _cache.map(convert);

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    if (containsKey(key)) {
      return this[key]!;
    }
    final value = ifAbsent();
    this[key] = value;
    return value;
  }

  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    if (containsKey(key)) {
      final value = update(this[key] as V);
      this[key] = value;
      return value;
    }
    if (ifAbsent != null) {
      final value = ifAbsent();
      this[key] = value;
      return value;
    }
    throw ArgumentError.notNull('key');
  }

  @override
  void updateAll(V Function(K key, V value) update) {
    final entries = this.entries.toList();
    for (final entry in entries) {
      this[entry.key] = update(entry.key, entry.value);
    }
  }

  @override
  void removeWhere(bool Function(K key, V value) test) {
    final entriesToRemove =
        entries.where((entry) => test(entry.key, entry.value)).toList();
    for (final entry in entriesToRemove) {
      remove(entry.key);
    }
  }
}
