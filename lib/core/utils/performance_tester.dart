import 'dart:async';
import 'package:flutter/foundation.dart';

class PerformanceTester {
  static final PerformanceTester _instance = PerformanceTester._internal();
  factory PerformanceTester() => _instance;
  PerformanceTester._internal();

  final Map<String, List<double>> _performanceMetrics = {};
  final Duration _testDuration = const Duration(seconds: 5);

  void startTest(String testName, Future<void> Function() testFunction) {
    _performanceMetrics[testName] = [];
    _runTest(testName, testFunction);
  }

  Future<void> _runTest(String testName, Future<void> Function() testFunction) async {
    final stopwatch = Stopwatch()..start();
    
    while (stopwatch.elapsed < _testDuration) {
      final startTime = DateTime.now().millisecondsSinceEpoch;
      await testFunction();
      final endTime = DateTime.now().millisecondsSinceEpoch;
      
      final duration = endTime - startTime;
      _performanceMetrics[testName]?.add(duration.toDouble());
    }
    
    stopwatch.stop();
    _logResults(testName);
  }

  void _logResults(String testName) {
    final metrics = _performanceMetrics[testName];
    if (metrics == null || metrics.isEmpty) return;

    final average = metrics.reduce((a, b) => a + b) / metrics.length;
    final max = metrics.reduce((a, b) => a > b ? a : b);
    final min = metrics.reduce((a, b) => a < b ? a : b);

    debugPrint('Performance Test Results - $testName:');
    debugPrint('Average: ${average.toStringAsFixed(2)}ms');
    debugPrint('Max: ${max.toStringAsFixed(2)}ms');
    debugPrint('Min: ${min.toStringAsFixed(2)}ms');
    debugPrint('Total Tests: ${metrics.length}');
  }

  void startMemoryTest() {
    final memoryMetrics = [];
    
    Timer.periodic(const Duration(seconds: 1), (timer) {
      final memoryInfo = _getMemoryInfo();
      memoryMetrics.add(memoryInfo);
      
      debugPrint('Memory Usage: ${memoryInfo.toString()}');
    });
  }

  Map<String, dynamic> _getMemoryInfo() {
    final memoryInfo = {
      'total': _getTotalMemory(),
      'used': _getUsedMemory(),
      'free': _getFreeMemory(),
    };
    return memoryInfo;
  }

  int _getTotalMemory() {
    // Implementation depends on platform
    return 0; // Placeholder
  }

  int _getUsedMemory() {
    // Implementation depends on platform
    return 0; // Placeholder
  }

  int _getFreeMemory() {
    // Implementation depends on platform
    return 0; // Placeholder
  }
}
