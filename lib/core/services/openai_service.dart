import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class OpenAIService {
  static const _freeApiKey = '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';
  static const _freeApiUrl = 'https://openrouter.ai/api/v1/chat/completions';
  static const _openaiApiKey = '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';
  static const _openaiUrl = 'https://api.openai.com/v1/chat/completions';

  static bool useOpenAI = false;

  static Future<String> generateGreeting(
    String prompt, {
    String? senderName,
    String? recipientName,
  }) async {
    final url = useOpenAI ? _openaiUrl : _freeApiUrl;
    final apiKey = useOpenAI ? _openaiApiKey : _freeApiKey;

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
      return _getFallbackGreeting(prompt, senderName: senderName, recipientName: recipientName);
    } catch (e) {
      print('❌ Error generating AI message: $e');
      return _getFallbackGreeting(prompt, senderName: senderName, recipientName: recipientName);
    }
  }

  static String _getFallbackGreeting(
    String prompt, {
    String? senderName,
    String? recipientName,
  }) {
    // تحليل نوع الرسالة
    String type = '';
    if (prompt.contains('نصية')) type = 'نصية';
    else if (prompt.contains('بوستر')) type = 'بوستر';
    else if (prompt.contains('ملصق')) type = 'ملصق';
    else if (prompt.contains('شعري')) type = 'شعري';
    else if (prompt.contains('رسمي')) type = 'رسمي';
    else if (prompt.contains('ودود')) type = 'ودود';

    // تحليل نوع المناسبة
    String occasion = '';
    final occasions = [
      'عيد ميلاد', 'نجاح', 'زواج', 'مناسبة دينية', 'تخرج', 'ترقية', 'مولود', 'عيد الفطر', 'عيد الأضحى', 'اليوم الوطني', 'عيد الأم'
    ];
    for (final o in occasions) {
      if (prompt.contains(o)) {
        occasion = o;
        break;
      }
    }

    // اسم المرسل والمستلم
    String sender = senderName ?? '';
    String recipient = recipientName ?? '';

    // عبارات جاهزة حسب النوع
    final greetings = <String, List<String>>{
      'نصية': [
        'أبارك لك من القلب بمناسبة {occasion}، وأسأل الله أن يديم عليك الفرح والسعادة.',
        'كل عام وأنت بخير يا {recipient}! {occasion} سعيد عليك وعلى أحبابك.',
        'تهنئة خاصة لك بمناسبة {occasion}، أتمنى لك أيامًا مليئة بالنجاح.',
        'أسأل الله أن يجعل {occasion} بداية خير وسعادة لك يا {recipient}.'
      ],
      'بوستر': [
        'مبارك عليكم {occasion}، جعل الله أيامكم كلها أفراح.',
        '{occasion} سعيد! أدام الله عليكم المسرات.',
        'كل عام وأنتم بخير بمناسبة {occasion}، دمتم بخير.',
        'أجمل التهاني وأطيب الأماني بمناسبة {occasion}.'
      ],
      'ملصق': [
        'يا زين {occasion} معاكم!',
        'فرحة {occasion} غير مع الأحباب!',
        '{occasion} = سعادة!',
        'أحلى {occasion}!'
      ],
      'شعري': [
        'في {occasion} أزف لك أصدق الأماني\nوأدعو لك بالسعادة طول الزمانِ',
        'يا {recipient} في {occasion} أقول\nعسى الفرح دومًا يملأ لك الدروب',
        'بمناسبة {occasion} أبعث لك بيت شعر\nيفرح قلبك ويزيدك سرور'
      ],
      'رسمي': [
        'يسرني أن أتقدم إليكم بأسمى آيات التهاني والتبريكات بمناسبة {occasion}. مع أطيب التحيات.',
        'أتشرف بتقديم التهنئة لكم بمناسبة {occasion}، متمنيًا لكم دوام التوفيق.',
        'بمناسبة {occasion}، أبعث لكم أصدق التهاني وأطيب الأمنيات.'
      ],
      'ودود': [
        'من القلب إلى القلب، {occasion} سعيد يا {recipient}!',
        'أرسل لك أطيب التهاني بمناسبة {occasion}، وأتمنى لك كل الفرح.',
        'يا رب أيامك كلها أفراح مثل {occasion} اليوم!'
      ]
    };

    // اختيار عشوائي لعبارة مناسبة
    final rand = Random();
    String greeting = (greetings[type]?.isNotEmpty ?? false)
        ? greetings[type]![rand.nextInt(greetings[type]!.length)]
        : 'ألف مبروك {occasion}! أتمنى لك كل السعادة والتوفيق.';

    // استبدال المتغيرات
    greeting = greeting.replaceAll('{occasion}', occasion.isNotEmpty ? occasion : 'المناسبة');
    greeting = greeting.replaceAll('{recipient}', recipient.isNotEmpty ? recipient : 'صديقي');

    // إضافة توقيع باسم المرسل إن وجد
    if (sender.isNotEmpty) {
      greeting += '\n\n— $sender';
    }

    // إضافة طابع سعودي إذا كانت المناسبة اجتماعية أو دينية
    if (occasion.contains('عيد') || occasion.contains('اليوم الوطني') || occasion.contains('مناسبة دينية')) {
      greeting += '\n🇸🇦';
    }

    return greeting;
  }
}