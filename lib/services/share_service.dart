import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';
import 'package:tahania_app/features/greetings/domain/models/sticker.dart';

class ShareService {
  static final ScreenshotController _screenshotController =
      ScreenshotController();

  /// مشاركة تهنئة مع ملصق
  static Future<void> shareGreeting({
    required String greeting,
    required Sticker sticker,
    required String recipientName,
    required String senderName,
  }) async {
    try {
      // إنشاء صورة من التهنئة
      final bytes = await _screenshotController.captureFromWidget(
        _buildShareableGreeting(
          greeting: greeting,
          sticker: sticker,
          recipientName: recipientName,
          senderName: senderName,
        ),
      );

      // حفظ الصورة مؤقتاً
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/greeting.png');
      await file.writeAsBytes(bytes);

      // مشاركة الصورة
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'تهنئة من $senderName إلى $recipientName',
      );
    } catch (e) {
      print('خطأ في مشاركة التهنئة: $e');
    }
  }

  /// مشاركة رسالة نصية بسيطة
  static Future<void> shareSimpleGreeting({
    required String greeting,
    required String recipientName,
    required String senderName,
  }) async {
    try {
      final String shareText = '$greeting\n\nإلى: $recipientName\nمن: $senderName';
      await Share.share(shareText);
    } catch (e) {
      print('خطأ في مشاركة التهنئة: $e');
    }
  }

  /// مشاركة رسالة توعوية
  static Future<void> shareOfficialMessage({
    required String title,
    required String content,
    required String source,
    String? imageUrl,
  }) async {
    try {
      final String shareText = '$title\n\n$content\n\nالمصدر: $source';

      if (imageUrl != null) {
        // إذا كانت هناك صورة، نقوم بتحميلها ومشاركتها
        final file = File(imageUrl);
        if (await file.exists()) {
          await Share.shareXFiles(
            [XFile(file.path)],
            text: shareText,
          );
          return;
        }
      }

      // إذا لم تكن هناك صورة، نقوم بمشاركة النص فقط
      await Share.share(shareText);
    } catch (e) {
      print('خطأ في مشاركة الرسالة: $e');
    }
  }

  /// بناء واجهة التهنئة القابلة للمشاركة
  static Widget _buildShareableGreeting({
    required String greeting,
    required Sticker sticker,
    required String recipientName,
    required String senderName,
  }) => Container(
      width: 1080,
      height: 1920,
      color: Colors.white,
      child: Stack(
        children: [
          // خلفية التهنئة
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue.shade100,
                    Colors.white,
                  ],
                ),
              ),
            ),
          ),
          // الملصق
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 300,
                height: 300,
                child: sticker.loadWidget(),
              ),
            ),
          ),
          // نص التهنئة
          Positioned(
            top: 450,
            left: 40,
            right: 40,
            child: Text(
              greeting,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // اسم المرسل والمستلم
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'إلى: $recipientName',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'من: $senderName',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
}
