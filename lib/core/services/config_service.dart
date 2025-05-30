import 'package:flutter_dotenv/flutter_dotenv.dart';

enum AIProvider { openai, openrouter }

class ConfigService {
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (!_isInitialized) {
      await dotenv.load(fileName: ".env");
      _isInitialized = true;
    }
  }

  static AIProvider get defaultProvider {
    final providerString = dotenv.env['DEFAULT_AI_PROVIDER']?.toLowerCase() ?? 'openai';
    return providerString == 'openrouter' ? AIProvider.openrouter : AIProvider.openai;
  }

  static String? getApiKey(AIProvider provider) {
    switch (provider) {
      case AIProvider.openai:
        return dotenv.env['OPENAI_API_KEY'];
      case AIProvider.openrouter:
        return dotenv.env['OPENROUTER_API_KEY'];
    }
  }

  static String getModel(AIProvider provider) {
    switch (provider) {
      case AIProvider.openai:
        return dotenv.env['OPENAI_MODEL'] ?? 'gpt-3.5-turbo';
      case AIProvider.openrouter:
        return dotenv.env['OPENROUTER_MODEL'] ?? 'mistralai/mistral-7b-instruct';
    }
  }

  static String getApiUrl(AIProvider provider) {
    switch (provider) {
      case AIProvider.openai:
        return 'https://api.openai.com/v1/chat/completions';
      case AIProvider.openrouter:
        return 'https://openrouter.ai/api/v1/chat/completions';
    }
  }

  static bool isApiKeyConfigured(AIProvider provider) {
    final apiKey = getApiKey(provider);
    return apiKey != null && 
           apiKey.isNotEmpty && 
           !apiKey.contains('your_') && 
           !apiKey.contains('_here');
  }

  static Map<String, String> getHeaders(AIProvider provider, String apiKey) {
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    if (provider == AIProvider.openrouter) {
      headers['HTTP-Referer'] = 'https://tahnia.app';
      headers['X-Title'] = 'Tahnia App';
    }

    return headers;
  }
}
