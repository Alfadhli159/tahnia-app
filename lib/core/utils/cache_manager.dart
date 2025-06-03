import 'dart:async';

class CacheManager {
  static final CacheManager _instance = CacheManager._internal();
  factory CacheManager() => _instance;
  CacheManager._internal();

  final Map<String, dynamic> _cache = {};
  final Map<String, DateTime> _cacheTimes = {};
  final Duration _maxAge = const Duration(days: 7);

  void put(String key, dynamic value) {
    _cache[key] = value;
    _cacheTimes[key] = DateTime.now();
  }

  dynamic get(String key) {
    if (!_cache.containsKey(key)) return null;

    final cacheTime = _cacheTimes[key];
    if (cacheTime == null) return null;

    if (DateTime.now().difference(cacheTime) > _maxAge) {
      remove(key);
      return null;
    }

    return _cache[key];
  }

  void remove(String key) {
    _cache.remove(key);
    _cacheTimes.remove(key);
  }

  void clear() {
    _cache.clear();
    _cacheTimes.clear();
  }

  void clearExpired() {
    final now = DateTime.now();
    _cacheTimes.forEach((key, time) {
      if (now.difference(time) > _maxAge) {
        remove(key);
      }
    });
  }
}

class ImageCacheManager {
  static final ImageCacheManager _instance = ImageCacheManager._internal();
  factory ImageCacheManager() => _instance;
  ImageCacheManager._internal();

  final Map<String, dynamic> _imageCache = {};
  final Map<String, DateTime> _imageCacheTimes = {};
  final Duration _maxImageAge = const Duration(days: 1);

  Future<void> setImage(String url, dynamic image) async {
    _imageCache[url] = image;
    _imageCacheTimes[url] = DateTime.now();
  }

  dynamic getImage(String url) {
    if (!_imageCache.containsKey(url)) return null;

    final cacheTime = _imageCacheTimes[url];
    if (cacheTime == null) return null;

    if (DateTime.now().difference(cacheTime) > _maxImageAge) {
      removeImage(url);
      return null;
    }

    return _imageCache[url];
  }

  void removeImage(String url) {
    _imageCache.remove(url);
    _imageCacheTimes.remove(url);
  }

  void clearImages() {
    _imageCache.clear();
    _imageCacheTimes.clear();
  }

  void clearExpiredImages() {
    final now = DateTime.now();
    _imageCacheTimes.forEach((key, time) {
      if (now.difference(time) > _maxImageAge) {
        removeImage(key);
      }
    });
  }
}
