import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  static const _freeApiKey = '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'; // ضع المفتاح الصحيح هنا
  static const _freeApiUrl = 'https://openrouter.ai/api/v1/chat/completions';
  static const _openaiApiKey = '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'; // المفتاح الخاص بـ OpenAI إن أردت
  static const _openaiUrl = 'https://api.openai.com/v1/chat/completions';

  static bool useOpenAI = false;

  static Future<String> generateGreeting(String prompt) async {
    final url = useOpenAI ? _openaiUrl : _freeApiUrl;
    final apiKey = useOpenAI ? _openaiApiKey : _freeApiKey;

    // Always try API first, only fallback if there's an actual error
    try {
      print('🤖 Attempting to generate AI message with prompt: $prompt');
      
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
          if (!useOpenAI) 'HTTP-Referer': 'https://tahnia.app',
        },
        body: jsonEncode({
          "model": useOpenAI ? "gpt-3.5-turbo" : "mistralai/mistral-7b-instruct",
          "messages": [
            {"role": "user", "content": prompt}
          ],
          "max_tokens": 300,
          "temperature": 0.8,
        }),
      );

      print('🌐 API Response Status: ${response.statusCode}');
      print('🌐 API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final generatedText = data['choices'][0]['message']['content'];
        if (generatedText != null && generatedText.toString().trim().isNotEmpty) {
          print('✅ Successfully generated AI message');
          return generatedText.toString().trim();
        }
      }
      
      print('⚠️ API call failed, using fallback message');
      return _getFallbackGreeting(prompt);
    } catch (e) {
      print('❌ Error generating AI message: $e');
      return _getFallbackGreeting(prompt);
    }
  }

  static String _getFallbackGreeting(String prompt) {
    // Extract occasion and type from prompt for fallback messages
    if (prompt.contains('عيد ميلاد')) {
      return '🎂 كل عام وأنت بخير! أتمنى لك عاماً مليئاً بالسعادة والنجاح والصحة. عيد ميلاد سعيد! 🎉';
    } else if (prompt.contains('نجاح')) {
      return '🎓 مبروك النجاح! إنجاز رائع يستحق كل التقدير. أتمنى لك المزيد من التفوق والنجاح في المستقبل! 👏';
    } else if (prompt.contains('زواج')) {
      return '💍 ألف مبروك! أتمنى لكما حياة زوجية سعيدة مليئة بالحب والسعادة والبركة. كل عام وأنتما بخير! 💕';
    } else if (prompt.contains('مناسبة دينية')) {
      return '🌙 كل عام وأنتم بخير! أعاده الله عليكم وعلى الأمة الإسلامية بالخير والبركة والسعادة. تقبل الله منا ومنكم! ✨';
    } else if (prompt.contains('تخرج')) {
      return '🎓 ألف مبروك التخرج! إنجاز عظيم يستحق كل الفخر والاعتزاز. أتمنى لك مستقبلاً مشرقاً مليئاً بالنجاح! 🌟';
    } else if (prompt.contains('ترقية')) {
      return '📈 مبروك الترقية! إنجاز يستحق كل التقدير والاحترام. أتمنى لك المزيد من التقدم والنجاح في مسيرتك المهنية! 💼';
    } else if (prompt.contains('مولود جديد')) {
      return '👶 ألف مبروك المولود الجديد! أتمنى أن يكون قرة عين لكم وأن يحفظه الله ويبارك فيه. كل عام وأنتم بخير! 🍼';
    } else {
      return '🎉 ألف مبروك! أتمنى لك كل السعادة والتوفيق. دمت بخير وسعادة دائمة! ✨';
    }
  }

  static String _buildPrompt(String type) {
    switch (type) {
      case 'بوستر':
        return 'اكتب لي تهنئة أنيقة مناسبة للعرض على بوستر مميز.';
      case 'ملصق':
        return 'أنشئ تهنئة قصيرة تصلح كملصق Sticker.';
      default:
        return 'اكتب لي تهنئة نصية مميزة بمناسبة سعيدة.';
    }
  }
}
