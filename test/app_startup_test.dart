import 'package:flutter_test/flutter_test.dart';
import 'package:tahania_app/main.dart';
import 'package:tahania_app/config/app_config.dart';
import 'package:tahania_app/services/memory_optimization_service.dart';
import 'package:flutter/material.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('App Startup Tests', () {
    test('Memory Optimization Service Initialization', () async {
      final memoryService = MemoryOptimizationService();
      
      // Test initialization
      memoryService.initialize();
      expect(memoryService.isLowMemoryMode, false);
      
      // Test low memory mode
      memoryService.enableLowMemoryMode();
      expect(memoryService.isLowMemoryMode, true);
      
      // Test cache settings in low memory mode
      final cache = memoryService.getOptimizedImageCache();
      expect(cache.maximumSize, 50);
      expect(cache.maximumSizeBytes, 20 * 1024 * 1024);
      
      // Test disabling low memory mode
      memoryService.disableLowMemoryMode();
      expect(memoryService.isLowMemoryMode, false);
      
      // Cleanup
      memoryService.dispose();
    });

    testWidgets('App Widget Initialization', (WidgetTester tester) async {
      final appConfig = AppConfig();
      await appConfig.loadSettings();
      
      // Build app
      await tester.pumpWidget(TahniaApp(initialAppConfig: appConfig));
      await tester.pumpAndSettle();
      
      // Verify basic app structure
      expect(find.byType(MaterialApp), findsOneWidget);
      
      // Verify error widget customization
      final errorBuilder = ErrorWidget.builder;
      final errorDetails = FlutterErrorDetails(
        exception: Exception('Test Error'),
        stack: StackTrace.current,
      );
      final errorWidget = errorBuilder(errorDetails) as Widget;
      
      // Build error widget
      await tester.pumpWidget(MaterialApp(home: errorWidget));
      await tester.pumpAndSettle();
      
      // Verify error widget content
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('عذراً، حدث خطأ ما'), findsOneWidget);
    });
  });
}
