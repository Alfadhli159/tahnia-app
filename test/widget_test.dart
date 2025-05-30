import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tahania_app/main.dart';
import 'package:tahania_app/config/app_config.dart';

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    // Create an AppConfig instance for testing
    final appConfig = AppConfig();
    await appConfig.loadSettings();

    // Build our app and trigger a frame
    await tester.pumpWidget(TahniaApp(initialAppConfig: appConfig));

    // Verify that the app initializes without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
