import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

class PosterGenerator {
  static Future<Uint8List?> generatePoster({
    required String message,
    required String occasion,
    required String senderName,
    required String recipientName,
    String type = 'بوستر',
  }) async {
    try {
      // Create a custom painter for the poster
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      
      // Poster dimensions
      const double width = 800;
      const double height = 1000;
      
      // Background gradient
      final gradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: _getGradientColors(occasion),
      );
      
      final paint = Paint()
        ..shader = gradient.createShader(const Rect.fromLTWH(0, 0, width, height));
      
      canvas.drawRect(const Rect.fromLTWH(0, 0, width, height), paint);
      
      // Add decorative elements
      _drawDecorations(canvas, width, height, occasion);
      
      // Add text content
      await _drawText(canvas, width, height, message, recipientName, senderName, occasion);
      
      // Convert to image
      final picture = recorder.endRecording();
      final img = await picture.toImage(width.toInt(), height.toInt());
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('Error generating poster: $e');
      return null;
    }
  }

  static Future<Uint8List?> generateSticker({
    required String message,
    required String occasion,
    String type = 'ملصق',
  }) async {
    try {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      
// 🚫 تم تعطيل هذا السطر تلقائيًا لتنظيف المشروع:
//       // Sticker dimensions (smaller, square)
      const double size = 400;
      
      // Background with rounded corners
      final paint = Paint()
        ..color = _getStickerColor(occasion)
        ..style = PaintingStyle.fill;
      
      final rrect = RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, size, size),
        const Radius.circular(40),
      );
      
      canvas.drawRRect(rrect, paint);
      
      // Add border
      final borderPaint = Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8;
      
      canvas.drawRRect(rrect, borderPaint);
      
      // Add emoji and text
      await _drawStickerContent(canvas, size, message, occasion);
      
      // Convert to image
      final picture = recorder.endRecording();
      final img = await picture.toImage(size.toInt(), size.toInt());
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('Error generating sticker: $e');
      return null;
    }
  }

  static List<Color> _getGradientColors(String occasion) {
    switch (occasion) {
      case 'عيد ميلاد':
        return [Colors.pink.shade300, Colors.purple.shade400];
      case 'نجاح':
        return [Colors.green.shade300, Colors.teal.shade400];
      case 'زواج':
        return [Colors.red.shade300, Colors.pink.shade400];
      case 'مناسبة دينية':
      case 'عيد الفطر':
      case 'عيد الأضحى':
      case 'رمضان':
        return [Colors.indigo.shade300, Colors.purple.shade400];
      case 'تخرج':
        return [Colors.blue.shade300, Colors.indigo.shade400];
      case 'ترقية':
        return [Colors.orange.shade300, Colors.red.shade400];
      case 'مولود جديد':
        return [Colors.cyan.shade300, Colors.blue.shade400];
      case 'خطوبة':
        return [Colors.pink.shade300, Colors.red.shade400];
      default:
        return [Colors.purple.shade300, Colors.indigo.shade400];
    }
  }

  static Color _getStickerColor(String occasion) {
    switch (occasion) {
      case 'عيد ميلاد':
        return Colors.pink.shade400;
      case 'نجاح':
        return Colors.green.shade400;
      case 'زواج':
        return Colors.red.shade400;
      case 'مناسبة دينية':
      case 'عيد الفطر':
      case 'عيد الأضحى':
      case 'رمضان':
        return Colors.indigo.shade400;
      case 'تخرج':
        return Colors.blue.shade400;
      case 'ترقية':
        return Colors.orange.shade400;
      case 'مولود جديد':
        return Colors.cyan.shade400;
      case 'خطوبة':
        return Colors.pink.shade400;
      default:
        return Colors.purple.shade400;
    }
  }

  static void _drawDecorations(Canvas canvas, double width, double height, String occasion) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Draw decorative circles
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(width * 0.1 + i * width * 0.2, height * 0.1),
        20 + i * 5,
        paint,
      );
    }

    // Draw decorative shapes at bottom
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
        Offset(width * 0.2 + i * width * 0.3, height * 0.9),
        15 + i * 3,
        paint,
      );
    }
  }

  static Future<void> _drawText(
    Canvas canvas,
    double width,
    double height,
    String message,
    String recipientName,
    String senderName,
    String occasion,
  ) async {
    // Title
    final titlePainter = TextPainter(
      text: TextSpan(
        text: _getOccasionEmoji(occasion),
        style: const TextStyle(
          fontSize: 60,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.rtl,
    );
    titlePainter.layout();
    titlePainter.paint(canvas, Offset((width - titlePainter.width) / 2, 100));

    // Recipient name
    if (recipientName.isNotEmpty) {
      final recipientPainter = TextPainter(
        text: TextSpan(
          text: recipientName,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        textDirection: TextDirection.rtl,
      );
      recipientPainter.layout();
      recipientPainter.paint(canvas, Offset((width - recipientPainter.width) / 2, 200));
    }

    // Main message
    final messagePainter = TextPainter(
      text: TextSpan(
        text: message,
        style: const TextStyle(
          fontSize: 28,
          color: Colors.white,
          height: 1.5,
        ),
      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,
    );
    messagePainter.layout(maxWidth: width * 0.8);
    messagePainter.paint(canvas, Offset((width - messagePainter.width) / 2, 300));

    // Sender name
    if (senderName.isNotEmpty) {
      final senderPainter = TextPainter(
        text: TextSpan(
          text: '— $senderName',
          style: const TextStyle(
            fontSize: 24,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        textDirection: TextDirection.rtl,
      );
      senderPainter.layout();
      senderPainter.paint(canvas, Offset((width - senderPainter.width) / 2, height - 150));
    }
  }

  static Future<void> _drawStickerContent(
    Canvas canvas,
    double size,
    String message,
    String occasion,
  ) async {
    // Emoji
    final emojiPainter = TextPainter(
      text: TextSpan(
        text: _getOccasionEmoji(occasion),
        style: const TextStyle(fontSize: 80),
      ),
      textDirection: TextDirection.rtl,
    );
    emojiPainter.layout();
    emojiPainter.paint(canvas, Offset((size - emojiPainter.width) / 2, 80));

    // Short message
    final shortMessage = message.length > 50 ? '${message.substring(0, 50)}...' : message;
    final messagePainter = TextPainter(
      text: TextSpan(
        text: shortMessage,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          height: 1.3,
        ),
      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,
    );
    messagePainter.layout(maxWidth: size * 0.8);
    messagePainter.paint(canvas, Offset((size - messagePainter.width) / 2, 200));
  }

  static String _getOccasionEmoji(String occasion) {
    switch (occasion) {
      case 'عيد ميلاد':
        return '🎂';
      case 'نجاح':
        return '🎓';
      case 'زواج':
        return '💍';
      case 'مناسبة دينية':
      case 'عيد الفطر':
      case 'عيد الأضحى':
      case 'رمضان':
        return '🌙';
      case 'تخرج':
        return '🎓';
      case 'ترقية':
        return '📈';
      case 'مولود جديد':
        return '👶';
      case 'خطوبة':
        return '💕';
      default:
        return '🎉';
    }
  }
}
