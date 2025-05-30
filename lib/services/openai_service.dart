import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/app_constants.dart';

class OpenAIService {
  static const String _baseUrl = 'https://api.openai.com/v1';
  static const String _model = 'gpt-3.5-turbo';

  final String apiKey;

  OpenAIService(this.apiKey);

  Future<String> generateGreeting({
    required String occasion,
    required String recipient,
    required String sender,
    String? additionalInfo,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': 'أنت مساعد محترف لتوليد رسائل تهنئة عربية.',
            },
            {
              'role': 'user',
              'content': '''
              توليد رسالة تهنئة باللغة العربية للمناسبة التالية: $occasion
              المرسل إليه: $recipient
              المرسل: $sender
              ${additionalInfo != null ? 'معلومات إضافية: $additionalInfo' : ''}
              ''',
            },
          ],
          'temperature': 0.7,
          'max_tokens': 200,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('فشل في توليد الرسالة');
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء توليد الرسالة: $e');
    }
  }
}
