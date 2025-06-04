import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class ErrorHandler {
  static final ErrorHandler _instance = ErrorHandler._internal();
  factory ErrorHandler() => _instance;
  ErrorHandler._internal();

  static final _errorStreamController = StreamController<ErrorInfo>.broadcast();
  static Stream<ErrorInfo> get errorStream => _errorStreamController.stream;

  void handleError(Object error, {StackTrace? stackTrace}) {
    final errorInfo = ErrorInfo(
      error: error,
      stackTrace: stackTrace,
      timestamp: DateTime.now(),
    );

    _errorStreamController.add(errorInfo);
    _showErrorDialog(errorInfo);
    _logError(errorInfo);
  }

  void _showErrorDialog(ErrorInfo errorInfo) {
    if (errorInfo.error is! Exception) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Navigator.of(AppConstants.navigatorKey.currentContext!).canPop()) {
        Navigator.of(AppConstants.navigatorKey.currentContext!).pop();
      }

      showDialog(
        context: AppConstants.navigatorKey.currentContext!,
        builder: (context) => AlertDialog(
          title: const Text('حدث خطأ'),
          content: Text(errorInfo.userMessage ?? AppConstants.defaultErrorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('موافق'),
            ),
          ],
        ),
      );
    });
  }

  void _logError(ErrorInfo errorInfo) {
    debugPrint('Error: ${errorInfo.error}');
    if (errorInfo.stackTrace != null) {
      debugPrint('Stack Trace: ${errorInfo.stackTrace}');
    }
  }

  void dispose() {
    _errorStreamController.close();
  }
}

class ErrorInfo {
  final Object error;
  final StackTrace? stackTrace;
  final DateTime timestamp;
  final String? userMessage;

  ErrorInfo({
    required this.error,
    this.stackTrace,
    required this.timestamp,
    this.userMessage,
  });

  String get errorMessage => error.toString();
}
