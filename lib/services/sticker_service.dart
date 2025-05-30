import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sticker_view/sticker_view.dart';
import 'package:flutter_icons/flutter_icons.dart';

class StickerService {
  static final Map<String, List<Sticker>> _occasionStickers = {
    'birthday': [
      Sticker(
        id: 'birthday_1',
        name: 'كعكة',
        assetPath: 'assets/stickers/birthday/cake.png',
        category: 'birthday',
        type: StickerType.image,
      ),
      Sticker(
        id: 'birthday_2',
        name: 'بالونات',
        assetPath: 'assets/stickers/birthday/balloons.png',
        category: 'birthday',
        type: StickerType.image,
      ),
      Sticker(
        id: 'birthday_3',
        name: 'هدية',
        assetPath: 'assets/stickers/birthday/gift.png',
        category: 'birthday',
        type: StickerType.image,
      ),
      Sticker(
        id: 'birthday_4',
        name: 'بالونات متحركة',
        assetPath: 'assets/stickers/birthday/balloons_animated.json',
        category: 'birthday',
        type: StickerType.lottie,
      ),
      Sticker(
        id: 'birthday_5',
        name: 'شموع',
        assetPath: 'assets/stickers/birthday/candles_animated.json',
        category: 'birthday',
        type: StickerType.lottie,
      ),
      Sticker(
        id: 'birthday_icon_1',
        name: 'كعكة',
        assetPath: '',
        category: 'birthday',
        type: StickerType.icon,
        iconData: Icons.cake,
      ),
      Sticker(
        id: 'birthday_icon_2',
        name: 'بالونات',
        assetPath: '',
        category: 'birthday',
        type: StickerType.icon,
        iconData: Icons.celebration,
      ),
      Sticker(
        id: 'birthday_icon_3',
        name: 'هدية',
        assetPath: '',
        category: 'birthday',
        type: StickerType.icon,
        iconData: Icons.card_giftcard,
      ),
    ],
    'eid': [
      Sticker(
        id: 'eid_1',
        name: 'هلال',
        assetPath: 'assets/stickers/eid/crescent.png',
        category: 'eid',
        type: StickerType.image,
      ),
      Sticker(
        id: 'eid_2',
        name: 'فانوس',
        assetPath: 'assets/stickers/eid/lantern.png',
        category: 'eid',
        type: StickerType.image,
      ),
      Sticker(
        id: 'eid_3',
        name: 'تهاني متحركة',
        assetPath: 'assets/stickers/eid/eid_animated.json',
        category: 'eid',
        type: StickerType.lottie,
      ),
      Sticker(
        id: 'eid_4',
        name: 'فانوس متحرك',
        assetPath: 'assets/stickers/eid/lantern_animated.json',
        category: 'eid',
        type: StickerType.lottie,
      ),
      Sticker(
        id: 'eid_icon_1',
        name: 'هلال',
        assetPath: '',
        category: 'eid',
        type: StickerType.icon,
        iconData: Icons.nightlight_round,
      ),
      Sticker(
        id: 'eid_icon_2',
        name: 'فانوس',
        assetPath: '',
        category: 'eid',
        type: StickerType.icon,
        iconData: Icons.lightbulb,
      ),
    ],
    'ramadan': [
      Sticker(
        id: 'ramadan_1',
        name: 'هلال',
        assetPath: 'assets/stickers/ramadan/crescent.png',
        category: 'ramadan',
        type: StickerType.image,
      ),
      Sticker(
        id: 'ramadan_2',
        name: 'فانوس',
        assetPath: 'assets/stickers/ramadan/lantern.png',
        category: 'ramadan',
        type: StickerType.image,
      ),
      Sticker(
        id: 'ramadan_3',
        name: 'تهاني متحركة',
        assetPath: 'assets/stickers/ramadan/ramadan_animated.json',
        category: 'ramadan',
        type: StickerType.lottie,
      ),
      Sticker(
        id: 'ramadan_4',
        name: 'فانوس متحرك',
        assetPath: 'assets/stickers/ramadan/lantern_animated.json',
        category: 'ramadan',
        type: StickerType.lottie,
      ),
      Sticker(
        id: 'ramadan_icon_1',
        name: 'هلال',
        assetPath: '',
        category: 'ramadan',
        type: StickerType.icon,
        iconData: Icons.nightlight_round,
      ),
      Sticker(
        id: 'ramadan_icon_2',
        name: 'فانوس',
        assetPath: '',
        category: 'ramadan',
        type: StickerType.icon,
        iconData: Icons.lightbulb,
      ),
    ],
    'wedding': [
      Sticker(
        id: 'wedding_1',
        name: 'خواتم',
        assetPath: 'assets/stickers/wedding/rings.png',
        category: 'wedding',
        type: StickerType.image,
      ),
      Sticker(
        id: 'wedding_2',
        name: 'قلوب',
        assetPath: 'assets/stickers/wedding/hearts.png',
        category: 'wedding',
        type: StickerType.image,
      ),
      Sticker(
        id: 'wedding_3',
        name: 'تهاني متحركة',
        assetPath: 'assets/stickers/wedding/wedding_animated.json',
        category: 'wedding',
        type: StickerType.lottie,
      ),
      Sticker(
        id: 'wedding_icon_1',
        name: 'خواتم',
        assetPath: '',
        category: 'wedding',
        type: StickerType.icon,
        iconData: Icons.favorite,
      ),
      Sticker(
        id: 'wedding_icon_2',
        name: 'قلوب',
        assetPath: '',
        category: 'wedding',
        type: StickerType.icon,
        iconData: Icons.favorite_border,
      ),
    ],
    'graduation': [
      Sticker(
        id: 'graduation_1',
        name: 'قبعة',
        assetPath: 'assets/stickers/graduation/cap.png',
        category: 'graduation',
        type: StickerType.image,
      ),
      Sticker(
        id: 'graduation_2',
        name: 'شهادة',
        assetPath: 'assets/stickers/graduation/certificate.png',
        category: 'graduation',
        type: StickerType.image,
      ),
      Sticker(
        id: 'graduation_3',
        name: 'تهاني متحركة',
        assetPath: 'assets/stickers/graduation/graduation_animated.json',
        category: 'graduation',
        type: StickerType.lottie,
      ),
      Sticker(
        id: 'graduation_icon_1',
        name: 'قبعة',
        assetPath: '',
        category: 'graduation',
        type: StickerType.icon,
        iconData: Icons.school,
      ),
      Sticker(
        id: 'graduation_icon_2',
        name: 'شهادة',
        assetPath: '',
        category: 'graduation',
        type: StickerType.icon,
        iconData: Icons.workspace_premium,
      ),
    ],
    'new_baby': [
      Sticker(
        id: 'new_baby_1',
        name: 'طفل',
        assetPath: 'assets/stickers/new_baby/baby.png',
        category: 'new_baby',
        type: StickerType.image,
      ),
      Sticker(
        id: 'new_baby_2',
        name: 'زجاجة',
        assetPath: 'assets/stickers/new_baby/bottle.png',
        category: 'new_baby',
        type: StickerType.image,
      ),
      Sticker(
        id: 'new_baby_3',
        name: 'تهاني متحركة',
        assetPath: 'assets/stickers/new_baby/baby_animated.json',
        category: 'new_baby',
        type: StickerType.lottie,
      ),
      Sticker(
        id: 'new_baby_icon_1',
        name: 'طفل',
        assetPath: '',
        category: 'new_baby',
        type: StickerType.icon,
        iconData: Icons.child_care,
      ),
      Sticker(
        id: 'new_baby_icon_2',
        name: 'زجاجة',
        assetPath: '',
        category: 'new_baby',
        type: StickerType.icon,
        iconData: Icons.baby_changing_station,
      ),
    ],
    'new_job': [
      Sticker(
        id: 'new_job_1',
        name: 'حقيبة',
        assetPath: 'assets/stickers/new_job/briefcase.png',
        category: 'new_job',
        type: StickerType.image,
      ),
      Sticker(
        id: 'new_job_2',
        name: 'وظيفة',
        assetPath: 'assets/stickers/new_job/job.png',
        category: 'new_job',
        type: StickerType.image,
      ),
      Sticker(
        id: 'new_job_3',
        name: 'تهاني متحركة',
        assetPath: 'assets/stickers/new_job/job_animated.json',
        category: 'new_job',
        type: StickerType.lottie,
      ),
      Sticker(
        id: 'new_job_icon_1',
        name: 'حقيبة',
        assetPath: '',
        category: 'new_job',
        type: StickerType.icon,
        iconData: Icons.work,
      ),
      Sticker(
        id: 'new_job_icon_2',
        name: 'وظيفة',
        assetPath: '',
        category: 'new_job',
        type: StickerType.icon,
        iconData: Icons.business_center,
      ),
    ],
    'new_home': [
      Sticker(
        id: 'new_home_1',
        name: 'منزل',
        assetPath: 'assets/stickers/new_home/house.png',
        category: 'new_home',
        type: StickerType.image,
      ),
      Sticker(
        id: 'new_home_2',
        name: 'مفتاح',
        assetPath: 'assets/stickers/new_home/key.png',
        category: 'new_home',
        type: StickerType.image,
      ),
      Sticker(
        id: 'new_home_3',
        name: 'تهاني متحركة',
        assetPath: 'assets/stickers/new_home/home_animated.json',
        category: 'new_home',
        type: StickerType.lottie,
      ),
      Sticker(
        id: 'new_home_icon_1',
        name: 'منزل',
        assetPath: '',
        category: 'new_home',
        type: StickerType.icon,
        iconData: Icons.home,
      ),
      Sticker(
        id: 'new_home_icon_2',
        name: 'مفتاح',
        assetPath: '',
        category: 'new_home',
        type: StickerType.icon,
        iconData: Icons.key,
      ),
    ],
    'anniversary': [
      Sticker(
        id: 'anniversary_1',
        name: 'قلوب',
        assetPath: 'assets/stickers/anniversary/hearts.png',
        category: 'anniversary',
        type: StickerType.image,
      ),
      Sticker(
        id: 'anniversary_2',
        name: 'خواتم',
        assetPath: 'assets/stickers/anniversary/rings.png',
        category: 'anniversary',
        type: StickerType.image,
      ),
      Sticker(
        id: 'anniversary_3',
        name: 'تهاني متحركة',
        assetPath: 'assets/stickers/anniversary/anniversary_animated.json',
        category: 'anniversary',
        type: StickerType.lottie,
      ),
      Sticker(
        id: 'anniversary_icon_1',
        name: 'قلوب',
        assetPath: '',
        category: 'anniversary',
        type: StickerType.icon,
        iconData: Icons.favorite,
      ),
      Sticker(
        id: 'anniversary_icon_2',
        name: 'خواتم',
        assetPath: '',
        category: 'anniversary',
        type: StickerType.icon,
        iconData: Icons.diamond,
      ),
    ],
    'recovery': [
      Sticker(
        id: 'recovery_1',
        name: 'قلب صحي',
        assetPath: 'assets/stickers/recovery/healthy_heart.png',
        category: 'recovery',
        type: StickerType.image,
      ),
      Sticker(
        id: 'recovery_2',
        name: 'شفاء',
        assetPath: 'assets/stickers/recovery/healing.png',
        category: 'recovery',
        type: StickerType.image,
      ),
      Sticker(
        id: 'recovery_3',
        name: 'تهاني متحركة',
        assetPath: 'assets/stickers/recovery/recovery_animated.json',
        category: 'recovery',
        type: StickerType.lottie,
      ),
      Sticker(
        id: 'recovery_icon_1',
        name: 'قلب صحي',
        assetPath: '',
        category: 'recovery',
        type: StickerType.icon,
        iconData: Icons.favorite,
      ),
      Sticker(
        id: 'recovery_icon_2',
        name: 'شفاء',
        assetPath: '',
        category: 'recovery',
        type: StickerType.icon,
        iconData: Icons.healing,
      ),
    ],
    'success': [
      Sticker(
        id: 'success_1',
        name: 'نجوم',
        assetPath: 'assets/stickers/success/stars.png',
        category: 'success',
        type: StickerType.image,
      ),
      Sticker(
        id: 'success_2',
        name: 'نجاح',
        assetPath: 'assets/stickers/success/success.png',
        category: 'success',
        type: StickerType.image,
      ),
      Sticker(
        id: 'success_3',
        name: 'تهاني متحركة',
        assetPath: 'assets/stickers/success/success_animated.json',
        category: 'success',
        type: StickerType.lottie,
      ),
      Sticker(
        id: 'success_icon_1',
        name: 'نجوم',
        assetPath: '',
        category: 'success',
        type: StickerType.icon,
        iconData: Icons.star,
      ),
      Sticker(
        id: 'success_icon_2',
        name: 'نجاح',
        assetPath: '',
        category: 'success',
        type: StickerType.icon,
        iconData: Icons.emoji_events,
      ),
    ],
    'promotion': [
      Sticker(
        id: 'promotion_1',
        name: 'تاج',
        assetPath: 'assets/stickers/promotion/crown.png',
        category: 'promotion',
        type: StickerType.image,
      ),
      Sticker(
        id: 'promotion_2',
        name: 'ترقية',
        assetPath: 'assets/stickers/promotion/promotion.png',
        category: 'promotion',
        type: StickerType.image,
      ),
      Sticker(
        id: 'promotion_3',
        name: 'تهاني متحركة',
        assetPath: 'assets/stickers/promotion/promotion_animated.json',
        category: 'promotion',
        type: StickerType.lottie,
      ),
      Sticker(
        id: 'promotion_icon_1',
        name: 'تاج',
        assetPath: '',
        category: 'promotion',
        type: StickerType.icon,
        iconData: Icons.workspace_premium,
      ),
      Sticker(
        id: 'promotion_icon_2',
        name: 'ترقية',
        assetPath: '',
        category: 'promotion',
        type: StickerType.icon,
        iconData: Icons.trending_up,
      ),
    ],
    'condolence': [
      Sticker(
        id: 'condolence_1',
        name: 'زهور',
        assetPath: 'assets/stickers/condolence/flowers.png',
        category: 'condolence',
        type: StickerType.image,
      ),
      Sticker(
        id: 'condolence_2',
        name: 'شموع',
        assetPath: 'assets/stickers/condolence/candles.png',
        category: 'condolence',
        type: StickerType.image,
      ),
      Sticker(
        id: 'condolence_3',
        name: 'تعزية متحركة',
        assetPath: 'assets/stickers/condolence/condolence_animated.json',
        category: 'condolence',
        type: StickerType.lottie,
      ),
      Sticker(
        id: 'condolence_icon_1',
        name: 'زهور',
        assetPath: '',
        category: 'condolence',
        type: StickerType.icon,
        iconData: Icons.local_florist,
      ),
      Sticker(
        id: 'condolence_icon_2',
        name: 'شموع',
        assetPath: '',
        category: 'condolence',
        type: StickerType.icon,
        iconData: Icons.candlestick_chart,
      ),
    ],
  };

  /// الحصول على الاستيكرات المتاحة لمناسبة معينة
  static List<Sticker> getStickersForOccasion(String occasion) {
    final category = _convertOccasionToCategory(occasion);
    return _occasionStickers[category] ?? [];
  }

  /// تحويل اسم المناسبة إلى فئة الاستيكرات
  static String _convertOccasionToCategory(String occasion) {
    switch (occasion) {
      case 'عيد ميلاد':
        return 'birthday';
      case 'عيد':
        return 'eid';
      case 'رمضان':
        return 'ramadan';
      case 'زفاف':
        return 'wedding';
      case 'تخرج':
        return 'graduation';
      case 'مولود جديد':
        return 'new_baby';
      case 'وظيفة جديدة':
        return 'new_job';
      case 'بيت جديد':
        return 'new_home';
      case 'ذكرى سنوية':
        return 'anniversary';
      case 'شفاء':
        return 'recovery';
      case 'نجاح':
        return 'success';
      case 'ترقية':
        return 'promotion';
      case 'تعزية':
        return 'condolence';
      default:
        return 'birthday';
    }
  }

  /// الحصول على جميع الاستيكرات
  static List<Sticker> getAllStickers() {
    return _occasionStickers.values.expand((stickers) => stickers).toList();
  }
}

/// نوع الاستيكر
enum StickerType {
  image,
  lottie,
  icon,
}

/// نموذج للاستيكر
class Sticker {
  final String id;
  final String name;
  final String assetPath;
  final String category;
  final StickerType type;
  final IconData? iconData;

  const Sticker({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.category,
    required this.type,
    this.iconData,
  });

  /// تحميل الاستيكر
  Widget get widget {
    switch (type) {
      case StickerType.image:
        return Image.asset(
          assetPath,
          width: 48,
          height: 48,
          fit: BoxFit.contain,
        );
      case StickerType.lottie:
        return Lottie.asset(
          assetPath,
          width: 48,
          height: 48,
          fit: BoxFit.contain,
        );
      case StickerType.icon:
        return Icon(
          iconData,
          size: 32,
          color: Colors.black87,
        );
    }
  }
} 