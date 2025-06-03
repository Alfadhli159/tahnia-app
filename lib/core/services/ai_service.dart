class AIService {
  static Future<GreetingResult> generateGreeting(
    String prompt, {
    String? senderName,
    String? recipientName,
  }) async {
    try {
      final namePart =
          recipientName?.isNotEmpty == true ? ' ${recipientName!},' : '';
      final senderPart =
          senderName?.isNotEmpty == true ? '\nمن: ${senderName!}' : '';
      final content = '🎉 $namePart $prompt $senderPart';

      await Future.delayed(const Duration(seconds: 1)); // محاكاة انتظار الشبكة
      return GreetingResult(content: content);
    } catch (e) {
      throw AIServiceException('فشل توليد الرسالة');
    }
  }
}

class GreetingResult {
  final String content;
  GreetingResult({required this.content});
}

class AIServiceException implements Exception {
  final String message;
  AIServiceException(this.message);
}
