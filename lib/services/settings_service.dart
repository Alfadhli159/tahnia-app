import 'package:flutter/foundation.dart';

class GeneralSettings {
  final bool showWelcomeScreen;
  final bool enableAnalytics;

  GeneralSettings({
    required this.showWelcomeScreen,
    required this.enableAnalytics,
  });

  GeneralSettings copyWith({
    bool? showWelcomeScreen,
    bool? enableAnalytics,
  }) {
    return GeneralSettings(
      showWelcomeScreen: showWelcomeScreen ?? this.showWelcomeScreen,
      enableAnalytics: enableAnalytics ?? this.enableAnalytics,
    );
  }
}

class AppSettings {
  final GeneralSettings general;

  AppSettings({required this.general});

  AppSettings copyWith({GeneralSettings? general}) {
    return AppSettings(general: general ?? this.general);
  }
}

class SettingsService {
  static final ValueNotifier<AppSettings> settingsNotifier = ValueNotifier(
    AppSettings(
      general: GeneralSettings(
        showWelcomeScreen: true,
        enableAnalytics: false,
      ),
    ),
  );

  static void updateGeneralSettings(GeneralSettings settings) {
    settingsNotifier.value = settingsNotifier.value.copyWith(general: settings);
  }
}
