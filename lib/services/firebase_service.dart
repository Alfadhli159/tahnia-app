import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../core/utils/firebase_dev_helper.dart';
import '../firebase_options.dart';

class FirebaseService {
  static bool _initialized = false;

  /// Initialize Firebase if not already initialized
  static Future<void> initialize() async {
    if (_initialized && Firebase.apps.isNotEmpty) {
      return;
    }

    try {
      // Handle development mode scenarios
      if (kDebugMode) {
        await FirebaseDevHelper.initializeForDevelopment();
      }

      // Check if Firebase is already initialized
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        _initialized = true;
        if (kDebugMode) {
          print('Firebase initialized successfully');
          FirebaseDevHelper.logFirebaseStatus();
        }
      } else {
        _initialized = true;
        if (kDebugMode) {
          print('Firebase was already initialized');
          FirebaseDevHelper.logFirebaseStatus();
        }
      }
    } catch (e) {
      if (e.toString().contains('duplicate-app')) {
        _initialized = true;
        if (kDebugMode) {
          print('Firebase duplicate app detected, continuing...');
        }
      } else {
        if (kDebugMode) {
          print('Firebase initialization error: $e');
        }
        rethrow;
      }
    }
  }

  /// Check if Firebase is initialized
  static bool get isInitialized => _initialized && Firebase.apps.isNotEmpty;

  /// Get the default Firebase app
  static FirebaseApp get defaultApp {
    if (!isInitialized) {
      throw Exception(
          'Firebase is not initialized. Call FirebaseService.initialize() first.');
    }
    return Firebase.app();
  }

  /// Reinitialize Firebase (useful for testing)
  static Future<void> reinitialize() async {
    _initialized = false;
    if (kDebugMode) {
      await FirebaseDevHelper.resetForTesting();
    }
    await initialize();
  }
}
