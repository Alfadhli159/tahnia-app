import 'package:flutter_dotenv/flutter_dotenv.dart';

enum AIProvider {
  openai('OpenAI'),
  openrouter('OpenRouter');

  const AIProvider(this.name);
  final String name;
}

class ConfigService {
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await dotenv.load();
      _isInitialized = true;
    } catch (e) {
      // If .env file doesn't exist, continue without it
      _isInitialized = true;
    }
  }

  static AIProvider get defaultProvider {
    final provider = dotenv.env['DEFAULT_AI_PROVIDER']?.toLowerCase();
    switch (provider) {
      case 'openrouter':
        return AIProvider.openrouter;
      case 'openai':
      default:
        return AIProvider.openai;
    }
  }

  static bool isApiKeyConfigured(AIProvider provider) {
    final key = getApiKey(provider);
    return key != null &&
        key.isNotEmpty &&
        !key.contains('your_') &&
        !key.contains('_here');
  }

  static String? getApiKey(AIProvider provider) {
    switch (provider) {
      case AIProvider.openai:
        return dotenv.env['OPENAI_API_KEY'];
      case AIProvider.openrouter:
        return dotenv.env['OPENROUTER_API_KEY'];
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

  static String getModel(AIProvider provider) {
    switch (provider) {
      case AIProvider.openai:
        return dotenv.env['OPENAI_MODEL'] ?? 'gpt-3.5-turbo';
      case AIProvider.openrouter:
        return dotenv.env['OPENROUTER_MODEL'] ??
            'mistralai/mistral-7b-instruct';
    }
  }

  static Map<String, String> getHeaders(AIProvider provider, String apiKey) {
    switch (provider) {
      case AIProvider.openai:
        return {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        };
      case AIProvider.openrouter:
        return {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
          'HTTP-Referer': 'https://tahania-app.com',
          'X-Title': 'Tahania App',
        };
    }
  }
}
