import 'package:tahania_app/features/greetings/domain/models/sticker.dart';

class StickerService {
  static final List<Sticker> _stickers = [
    const Sticker(
      id: 'heart_1',
      name: 'قلب أحمر',
      path: 'assets/stickers/heart_red.png',
      category: 'love',
      tags: ['حب', 'قلب', 'رومانسي'],
    ),
    const Sticker(
      id: 'celebration_1',
      name: 'احتفال',
      path: 'assets/stickers/celebration.png',
      category: 'celebration',
      tags: ['احتفال', 'فرح', 'مناسبة'],
    ),
    const Sticker(
      id: 'flower_1',
      name: 'وردة',
      path: 'assets/stickers/flower.png',
      category: 'nature',
      tags: ['وردة', 'زهرة', 'طبيعة'],
    ),
    const Sticker(
      id: 'star_1',
      name: 'نجمة',
      path: 'assets/stickers/star.png',
      category: 'decoration',
      tags: ['نجمة', 'تزيين', 'لامع'],
    ),
    const Sticker(
      id: 'gift_1',
      name: 'هدية',
      path: 'assets/stickers/gift.png',
      category: 'celebration',
      tags: ['هدية', 'مناسبة', 'احتفال'],
    ),
  ];

  /// الحصول على جميع الملصقات
  static List<Sticker> getAllStickers() => _stickers;

  /// الحصول على الملصقات حسب الفئة
  static List<Sticker> getStickersByCategory(String category) => _stickers.where((sticker) => sticker.category == category).toList();

  /// البحث في الملصقات
  static List<Sticker> searchStickers(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _stickers.where((sticker) => sticker.name.toLowerCase().contains(lowercaseQuery) ||
          sticker.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery))).toList();
  }

  /// الحصول على ملصق بالمعرف
  static Sticker? getStickerById(String id) {
    try {
      return _stickers.firstWhere((sticker) => sticker.id == id);
    } catch (e) {
      return null;
    }
  }

  /// الحصول على فئات الملصقات
  static List<String> getCategories() => _stickers.map((sticker) => sticker.category).toSet().toList();

  /// الحصول على ملصق افتراضي
  static Sticker getDefaultSticker() => _stickers.isNotEmpty
        ? _stickers.first
        : const Sticker(
            id: 'default',
            name: 'افتراضي',
            path: 'assets/stickers/default.png',
            category: 'default',
          );
}
