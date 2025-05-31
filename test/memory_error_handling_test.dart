import 'package:flutter_test/flutter_test.dart';
import 'package:tahania_app/services/memory_optimization_service.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Memory Management Tests', () {
    late MemoryOptimizationService memoryService;

    setUp(() {
      memoryService = MemoryOptimizationService();
    });

    tearDown(() {
      memoryService.dispose();
    });

    test('Cache Cleanup Timer', () async {
      // Initialize service
      memoryService.initialize();
      
      // Wait for potential cleanup
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Verify service is running
      expect(memoryService.isLowMemoryMode, false);
    });

    test('Memory Mode Transitions', () {
      // Test normal to low memory transition
      memoryService.enableLowMemoryMode();
      final lowMemCache = memoryService.getOptimizedImageCache();
      expect(lowMemCache.maximumSize, 50);
      expect(lowMemCache.maximumSizeBytes, 20 * 1024 * 1024);

      // Test low to normal memory transition
      memoryService.disableLowMemoryMode();
      final normalCache = memoryService.getOptimizedImageCache();
      expect(normalCache.maximumSize, 100);
      expect(normalCache.maximumSizeBytes, 50 * 1024 * 1024);
    });

    test('ListView Optimization', () {
      final physics = memoryService.getOptimizedScrollPhysics();
      expect(physics, isA<BouncingScrollPhysics>());

      final builder = memoryService.optimizeListViewBuilder();
      expect(builder, isA<Function>());
    });
  });

  group('Error Handling Tests', () {
    test('Failed Cache Cleanup Recovery', () async {
      final memoryService = MemoryOptimizationService();
      
      // Simulate multiple failed cleanup attempts
      for (var i = 0; i < 4; i++) {
        await memoryService.cleanupCache();
      }
      
      // Service should still be functional
      expect(memoryService.isLowMemoryMode, false);
      
      // Cleanup
      memoryService.dispose();
    });

    testWidgets('Error Widget Display', (WidgetTester tester) async {
      // Create a widget that throws an error
      await tester.pumpWidget(
        MaterialApp(
