import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import 'error_handler.dart';

class NetworkManager {
  static final NetworkManager _instance = NetworkManager._internal();
  factory NetworkManager() => _instance;
  NetworkManager._internal();

  final Map<String, DateTime> _requestTimes = {};
  final Duration _minRequestInterval = const Duration(milliseconds: 500);

  Future<http.Response> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final lastRequest = _requestTimes[url];
      if (lastRequest != null) {
        final timeSinceLastRequest = DateTime.now().difference(lastRequest);
        if (timeSinceLastRequest < _minRequestInterval) {
          await Future.delayed(_minRequestInterval - timeSinceLastRequest);
        }
      }

      final response = await http
          .get(
            Uri.parse(url).replace(queryParameters: queryParameters),
            headers: headers,
          )
          .timeout(const Duration(seconds: AppConstants.timeoutDuration));

      _requestTimes[url] = DateTime.now();
      return response;
    } catch (e) {
      ErrorHandler().handleError(e);
      rethrow;
    }
  }

  Future<http.Response> post(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Encoding? encoding,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: headers,
            body: body,
            encoding: encoding,
          )
          .timeout(const Duration(seconds: AppConstants.timeoutDuration));

      _requestTimes[url] = DateTime.now();
      return response;
    } catch (e) {
      ErrorHandler().handleError(e);
      rethrow;
    }
  }

  Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> retryRequest(
    Future Function() request, {
    int maxRetries = AppConstants.maxRetries,
    Duration delay = const Duration(seconds: 1),
  }) async {
    int attempt = 0;
    while (attempt < maxRetries) {
      try {
        return await request();
      } catch (e) {
        if (attempt == maxRetries - 1) {
          ErrorHandler().handleError(e);
          rethrow;
        }
        await Future.delayed(delay);
        attempt++;
      }
    }
  }
}
