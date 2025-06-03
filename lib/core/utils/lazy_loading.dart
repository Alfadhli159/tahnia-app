import 'dart:async';
import 'package:flutter/material.dart';
import 'performance_optimizer.dart';

class LazyLoading {
  static final LazyLoading _instance = LazyLoading._internal();
  factory LazyLoading() => _instance;
  LazyLoading._internal();

  final Map<String, bool> _loadingStates = {};
  final Map<String, Timer> _loadingTimers = {};
  final Duration _loadingDelay = const Duration(milliseconds: 300);

  Widget buildLazyWidget({
    required Widget child,
    required String key,
    Widget? loadingWidget,
    Widget? errorWidget,
  }) {
    return FutureBuilder<bool>(
      future: _loadData(key),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget ??
              const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return errorWidget ?? const Icon(Icons.error);
        }

        return PerformanceOptimizer().optimizeWidget(
          child: child,
          maintainState: true,
        );
      },
    );
  }

  Future<bool> _loadData(String key) async {
    if (_loadingStates[key] == true) return true;

    _loadingStates[key] = true;
    await Future.delayed(_loadingDelay);

    try {
      // Simulate data loading
      await Future.delayed(const Duration(seconds: 1));
      _loadingStates[key] = false;
      return true;
    } catch (e) {
      _loadingStates[key] = false;
      rethrow;
    }
  }

  void cancelLoading(String key) {
    _loadingStates[key] = false;
    _loadingTimers[key]?.cancel();
    _loadingTimers.remove(key);
  }

  void dispose() {
    _loadingTimers.values.forEach((timer) => timer.cancel());
    _loadingTimers.clear();
    _loadingStates.clear();
  }
}
