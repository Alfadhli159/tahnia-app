import 'dart:convert';
import 'package:shared_preferences.dart';
import 'package:tahania_app/services/sticker_service.dart';

class FavoriteStickersService {
  static const String _favoritesKey = 'favorite_stickers';
  static const String _recentKey = 'recent_stickers';
  static const int _maxRecentStickers = 20;

  /// حفظ استيكر في المفضلة
  static Future<void> addToFavorites(Sticker sticker) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    
    if (!favorites.any((s) => s.id == sticker.id)) {
      favorites.add(sticker);
      await prefs.setString(_favoritesKey, jsonEncode(favorites.map((s) => _stickerToJson(s)).toList()));
    }
  }

  /// إزالة استيكر من المفضلة
  static Future<void> removeFromFavorites(String stickerId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    
    favorites.removeWhere((s) => s.id == stickerId);
    await prefs.setString(_favoritesKey, jsonEncode(favorites.map((s) => _stickerToJson(s)).toList()));
  }

  /// الحصول على الاستيكرات المفضلة
  static Future<List<Sticker>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getString(_favoritesKey);
    
    if (favoritesJson == null) return [];
    
    final List<dynamic> decoded = jsonDecode(favoritesJson);
    return decoded.map((json) => _stickerFromJson(json)).toList();
  }

  /// إضافة استيكر إلى الاستخدامات الأخيرة
  static Future<void> addToRecent(Sticker sticker) async {
    final prefs = await SharedPreferences.getInstance();
    final recent = await getRecent();
    
    // إزالة الاستيكر إذا كان موجوداً
    recent.removeWhere((s) => s.id == sticker.id);
    
    // إضافة الاستيكر في البداية
    recent.insert(0, sticker);
    
    // الحفاظ على العدد الأقصى
    if (recent.length > _maxRecentStickers) {
      recent.removeLast();
    }
    
    await prefs.setString(_recentKey, jsonEncode(recent.map((s) => _stickerToJson(s)).toList()));
  }

  /// الحصول على الاستخدامات الأخيرة
  static Future<List<Sticker>> getRecent() async {
    final prefs = await SharedPreferences.getInstance();
    final recentJson = prefs.getString(_recentKey);
    
    if (recentJson == null) return [];
    
    final List<dynamic> decoded = jsonDecode(recentJson);
    return decoded.map((json) => _stickerFromJson(json)).toList();
  }

  /// التحقق مما إذا كان الاستيكر مفضلاً
  static Future<bool> isFavorite(String stickerId) async {
    final favorites = await getFavorites();
    return favorites.any((s) => s.id == stickerId);
  }

  /// تحويل الاستيكر إلى JSON
  static Map<String, dynamic> _stickerToJson(Sticker sticker) {
    return {
      'id': sticker.id,
      'name': sticker.name,
      'assetPath': sticker.assetPath,
      'category': sticker.category,
      'type': sticker.type.index,
      'iconData': sticker.iconData?.codePoint,
    };
  }

  /// تحويل JSON إلى استيكر
  static Sticker _stickerFromJson(Map<String, dynamic> json) {
    return Sticker(
      id: json['id'],
      name: json['name'],
      assetPath: json['assetPath'],
      category: json['category'],
      type: StickerType.values[json['type']],
      iconData: json['iconData'] != null ? IconData(json['iconData'], fontFamily: 'MaterialIcons') : null,
    );
  }
} 