import 'dart:convert';
import 'package:http/http.dart' as http;

// إعداد التبديل بين المحركين (مجاني أو OpenAI)
bool useOpenAI = false; // غيّر إلى true لتفعيل OpenAI عند الحاجة

Future<String> generateMessageWithFreeAPI() async {
  const url = 'https://openrouter.ai/api/v1/chat/completions';
  const apiKey = String.fromEnvironment('OPENROUTER_API_KEY', defaultValue: 'sk-or-v1-REDACTED');

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://tahnia.app',
      },
      body: jsonEncode({
        "model": "mistralai/mistral-7b-instruct",
        "messages": [
          {"role": "user", "content": "اكتب لي تهنئة مميزة لشخص بمناسبة عيد ميلاده."}
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'] ?? 'تهنئة رائعة قادمة قريبًا!';
    } else {
      return 'حدث خطأ في التوليد المجاني: ${response.statusCode}';
    }
  } catch (e) {
    return 'فشل الاتصال بالخدمة المجانية.';
  }
}

Future<String> generateMessageWithOpenAI() async {
  const url = 'https://api.openai.com/v1/chat/completions';
  const apiKey = String.fromEnvironment('OPENAI_API_KEY', defaultValue: 'sk-REDACTED');

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "user", "content": "اكتب لي تهنئة مبتكرة بمناسبة زواج صديق."}
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'] ?? 'تهنئة مميزة في الطريق!';
    } else {
      return 'حدث خطأ في توليد الرسالة من OpenAI: ${response.statusCode}';
    }
  } catch (e) {
    return 'فشل الاتصال بـ OpenAI.';
  }
}
