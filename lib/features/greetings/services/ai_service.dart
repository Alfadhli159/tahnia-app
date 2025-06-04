import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../models/greeting.dart';
import '../../../core/utils/fallback_generator.dart';
import 'config_service.dart';

class AIService {
  static final Logger _logger = Logger();
  static const int _timeoutSeconds =
      15; // تقليل مهلة الانتظار من 30 إلى 15 ثانية


  /// توليد تهنئة باستخدام الذكاء الاصطناعي مع نظام احتياطي ذكي
  static Future<Greeting> generateGreeting(
    String prompt, {
    String? senderName,
    String? recipientName,
    String? messageType,
    String? occasion,
    String? purpose,
    AIProvider? preferredProvider,
  }) async {
    await ConfigService.initialize();

    final provider = preferredProvider ?? ConfigService.defaultProvider;

    _logger.i('🤖 محاولة توليد رسالة ذكية باستخدام: ${provider.name}');
    _logger.d('النص المطلوب: $prompt');

    // التحقق من وجود مفتاح API
    if (!ConfigService.isApiKeyConfigured(provider)) {
      _logger.w(
          '⚠️ مفتاح API غير مُعرَّف لـ ${provider.name}، استخدام النظام الاحتياطي');
      return _generateFallbackGreeting(
        prompt,
        senderName: senderName,
        recipientName: recipientName,
        messageType: messageType,
        occasion: occasion,
        purpose: purpose,
      );
    }

    try {
      final greeting = await _callAIAPI(provider, prompt);
      _logger.i('✅ تم توليد الرسالة بنجاح باستخدام ${provider.name}');
      return Greeting.fromAI(content: greeting, provider: provider.name);
    } catch (e) {
      _logger.e('❌ فشل في توليد الرسالة: $e');

      // محاولة استخدام مزود بديل
      if (preferredProvider == null) {
        final alternativeProvider = provider == AIProvider.openai
            ? AIProvider.openrouter
            : AIProvider.openai;

        if (ConfigService.isApiKeyConfigured(alternativeProvider)) {
          _logger.i(
              '🔄 محاولة استخدام المزود البديل: ${alternativeProvider.name}');
          try {
            final greeting = await _callAIAPI(alternativeProvider, prompt);
            _logger.i('✅ تم توليد الرسالة بنجاح باستخدام المزود البديل');
            return Greeting.fromAI(
                content: greeting, provider: alternativeProvider.name);
          } catch (e2) {
            _logger.e('❌ فشل المزود البديل أيضاً: $e2');
          }
        }
      }

      // استخدام النظام الاحتياطي
      return _generateFallbackGreeting(
        prompt,
        senderName: senderName,
        recipientName: recipientName,
        messageType: messageType,
        occasion: occasion,
        purpose: purpose,
      );
    }
  }

  /// استدعاء API الذكاء الاصطناعي
  static Future<String> _callAIAPI(AIProvider provider, String prompt) async {
    final apiKey = ConfigService.getApiKey(provider)!;
    final url = ConfigService.getApiUrl(provider);
    final model = ConfigService.getModel(provider);
    final headers = ConfigService.getHeaders(provider, apiKey);

    final requestBody = {
      "model": model,
      "messages": [
        {
          "role": "system",
          "content":
              "أنت مساعد ذكي داخل تطبيق جوال متخصص في توليد رسائل تهنئة باللغة العربية الفصحى، وفقًا لمعلومات المستخدم. رسالتك يجب أن تكون شخصية، سليمة نحويًا، مصاغة بأسلوب أدبي جذاب وغير مكرر. استهدف تحسين تجربة المستفيد بجعل الرسالة قابلة للتعديل لاحقًا، وتُلائم نوع المناسبة والعلاقة، دون استخدام قوالب أو نصوص عامة. الرسالة يجب أن تبدأ بتحية لبقة، وتتضمّن اسم المستلم بلقب إن وُجد، وتنتهي بتوقيع أنيق باسم المرسل."
        },
        {"role": "user", "content": prompt}
      ],
      "max_tokens": 300,
      "temperature": 0.8,
    };

    _logger.d('📤 إرسال طلب إلى: $url');
    _logger.d('🔧 النموذج المستخدم: $model');

    final response = await http
        .post(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode(requestBody),
        )
        .timeout(const Duration(seconds: _timeoutSeconds));

    _logger.d('📥 رمز الاستجابة: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // التحقق من صحة البيانات المُستلمة
      if (!_isValidResponse(data)) {
        throw const AIServiceException('استجابة غير صالحة من الخدمة الذكية');
      }

      final content = data['choices'][0]['message']['content'] as String;

      if (content.trim().isEmpty) {
        throw const AIServiceException('محتوى فارغ من الخدمة الذكية');
      }

      return content.trim();
    } else {
      final errorMessage =
          _getLocalizedErrorMessage(response.statusCode, provider);
      throw AIServiceException(errorMessage);
    }
  }

  /// التحقق من صحة استجابة API
  static bool _isValidResponse(Map<String, dynamic> data) => data.containsKey('choices') &&
        data['choices'] is List &&
        (data['choices'] as List).isNotEmpty &&
        data['choices'][0] is Map &&
        (data['choices'][0] as Map).containsKey('message') &&
        (data['choices'][0]['message'] as Map).containsKey('content');

  /// توليد رسالة احتياطية
  static Greeting _generateFallbackGreeting(
    String prompt, {
    String? senderName,
    String? recipientName,
    String? messageType,
    String? occasion,
    String? purpose,
  }) {
    _logger.i('🔄 استخدام النظام الاحتياطي لتوليد الرسالة');

    final content = FallbackGenerator.generateGreeting(
      prompt,
      senderName: senderName,
      recipientName: recipientName,
      messageType: messageType,
      occasion: occasion,
      purpose: purpose,
    );

    return Greeting.fallback(content: content);
  }

  /// رسائل خطأ مُعرَّبة للمستخدم النهائي
  static String _getLocalizedErrorMessage(int statusCode, AIProvider provider) {
    switch (statusCode) {
      case 401:
        return 'مفتاح الخدمة الذكية غير صحيح. يرجى التحقق من الإعدادات.';
      case 403:
        return 'ليس لديك صلاحية للوصول إلى هذه الخدمة.';
      case 429:
        return 'تم تجاوز الحد المسموح من الطلبات. يرجى المحاولة لاحقاً.';
      case 500:
      case 502:
      case 503:
        return 'خطأ في الخدمة الذكية. يرجى المحاولة لاحقاً.';
      case 404:
        return 'الخدمة الذكية غير متوفرة حالياً.';
      default:
        return 'فشل في الاتصال بالخدمة الذكية. تأكد من توفر الإنترنت أو أعد المحاولة لاحقاً.';
    }
  }

  /// التحقق من حالة الخدمة
  static Future<ServiceStatus> checkServiceStatus() async {
    await ConfigService.initialize();

    final openaiConfigured =
        ConfigService.isApiKeyConfigured(AIProvider.openai);
    final openrouterConfigured =
        ConfigService.isApiKeyConfigured(AIProvider.openrouter);

    return ServiceStatus(
      openaiAvailable: openaiConfigured,
      openrouterAvailable: openrouterConfigured,
      hasAnyProvider: openaiConfigured || openrouterConfigured,
      defaultProvider: ConfigService.defaultProvider,
    );
  }
}

/// استثناء خاص بخدمة الذكاء الاصطناعي
class AIServiceException implements Exception {
  final String message;
  const AIServiceException(this.message);

  @override
  String toString() => 'AIServiceException: $message';
}

/// حالة الخدمة
class ServiceStatus {
  final bool openaiAvailable;
  final bool openrouterAvailable;
  final bool hasAnyProvider;
  final AIProvider defaultProvider;

  const ServiceStatus({
    required this.openaiAvailable,
    required this.openrouterAvailable,
    required this.hasAnyProvider,
    required this.defaultProvider,
  });

  @override
  String toString() => 'ServiceStatus(openai: $openaiAvailable, openrouter: $openrouterAvailable, default: ${defaultProvider.name})';
}
